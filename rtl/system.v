/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// CLOCK DIVIDER 



module LAB1V2(rst, clk, constant, clk_div); //clock divider code from LAB 1
parameter n= 32;
input clk;  
input rst;
input [n-1:0] constant; 
output reg clk_div = 0; 
reg [n-1:0] counterboy; 
	
always@(posedge clk) 
    begin 
	    if (rst == 1) begin counterboy <= 0; clk_div <= 0; end 
	    else          begin if (counterboy < constant -1) begin counterboy <= counterboy + 1; end 
                            else                          begin counterboy <= 0; clk_div <= ~clk_div; end end 
	end 
endmodule 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// COUNTER 

module COUNTER(clk, up, down, rst,count); 
 
input up, down, rst, clk; 
output reg [31:0] count; 
reg [31:0 ] counterino = 32'd3472; 
always_ff @(posedge clk)
    begin
        if (rst)    begin counterino <= 32'd3472; end                 //if rst count = 3472
        else if (up) begin counterino <= counterino + 32'd15; end     //if up then count > 3472
        else if (down) begin counterino <= counterino - 32'd15; end   //if down then count < 3472
        else begin counterino <= counterino; end
    end 
assign count = counterino; 
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// MEMORY VERIFIER 
module FSM_MEM(clk, read, waitrequest, data_valid, in, out); 
input clk;                                //Trivial
input read, data_valid, waitrequest;      //FROM MEMORY BLOCK 
input in;                              //from ADDRESS_CNTRL
output reg out;                        //to ADDRESS_CNTRL
reg [4:0] state;   //logic [5:0] state; 

parameter idle                         = 5'b0000_0; 
parameter check_oper                   = 5'b0001_0; 
parameter wait_for_waitrequest_negedge = 5'b0010_0; 
parameter wait_for_datavalid_negedge   = 5'b0100_0; 
parameter again                        = 5'b1000_1; 

always_ff@(posedge clk)
    begin
	    case(state) 
	    idle: 	                        state <= (in)?           check_oper : idle;
	    check_oper:                     state <= (read)?         wait_for_waitrequest_negedge : check_oper; 
	    wait_for_waitrequest_negedge:   state <= (~waitrequest)? wait_for_datavalid_negedge : wait_for_datavalid_negedge; 
	    wait_for_datavalid_negedge:     state <= (~data_valid)?  again : wait_for_datavalid_negedge; 
	    again:                          state <=                 idle;
	    default:                        state <=                 idle; 
	endcase 
    end
assign out = state[0]; 
endmodule 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// ADDRESS CNTRL
module ADDRESS_CNTRL(EQ_DONE, NUM_TWO_DONE,OPER_DONE,done_audio2, finish_reading_oper, address_in,done_audio,clk, frequency_clk,NUM_ONE_DONE, flash_stop, DATA_START_PHONEME, flash_data, start_address, end_address, silent, flash_begin, read, DATA_FINISH_PHONEME, out_data, address_out, state_indi); 

input logic clk, frequency_clk;  //trivial
input logic NUM_ONE_DONE, NUM_TWO_DONE; 
input logic OPER_DONE;
input logic [7:0] EQ_DONE;
input logic flash_stop,finish_reading_oper;          //from FSM_MEM
input logic DATA_START_PHONEME, silent;
input logic [31:0] flash_data;   //from flash memory 
input logic [23:0] start_address, end_address; 
input logic [23:0] address_in;
output logic done_audio,done_audio2; 
output logic flash_begin, read; // to FSM_MEM //  to falsh memory 
output logic [23:0] address_out; //to flash memory 
output logic [7:0] out_data; //To audio 
output logic DATA_FINISH_PHONEME;   
output logic [11:0] state_indi;
logic [11:0] state;      
logic [23:0] address; //new

parameter idle_state                 = 12'b00000_0000_000; //000
parameter read_state                 = 12'b00000_0001_001; //009
parameter beginin                    = 12'b00000_0010_000; //010
parameter read_forth_bits            = 12'b00000_0100_000; //020
parameter wait_to_read_first_bits    = 12'b00000_1000_000; //040
parameter read_first_bits            = 12'b01110_0000_000; //080
parameter wait_to_read_second_bits   = 12'b00010_0000_000; //100
parameter read_second_bits           = 12'b00100_0000_000; //200
parameter wait_to_read_third_bits    = 12'b01000_0000_000; //400
parameter read_third_bits            = 12'b10000_0000_000; //800
parameter wait_to_read_forth_bits    = 12'b11000_0000_000; //c00
parameter check_addresses_left       = 12'b01100_0000_000; //600
parameter should_I_get_new_phoneme   = 12'b00110_0000_000; //300
parameter Yes                        = 12'b11110_0000_100; //184
parameter No                         = 12'b00000_1000_110; //0c2
parameter interrupt_1                = 12'b00000_1100_000; //060
parameter finish                     = 12'b00000_0110_110; //032 // bit 2 was 0 i made it 1 5:45[pm] holy fuck imma leave this in cause it worked rn :)
parameter prep_read                  = 12'b00000_0011_000; //018
parameter read_again                 = 12'b00000_0111_000; //038
parameter finish2                    = 12'b00000_1110_100; //070
parameter finish3                    = 12'b00010_1100_100; //070
parameter finish4                    = 12'b00111_1000_100; //070
parameter reset                      = 12'b01111_1000_000; //070
///////OUTPUTS
    assign state_indi = state; 

///////OUTPUTS
    assign flash_begin = state[0]; 
    assign read = state[0]; 
    assign DATA_FINISH_PHONEME = state[2]; 
    assign done_audio = state[1];
    assign done_audio2 = state[7];
    assign address_out = address; //new
///////SEQUENTIAL
always_ff@(posedge clk) 
    begin 
	    case(state) 
		idle_state:                 state <= (NUM_ONE_DONE)?           beginin : idle_state; 
        beginin:                    state <=                           interrupt_1;
        interrupt_1:                state <= (DATA_START_PHONEME== 1'b1)?     prep_read : interrupt_1;
        prep_read:                  state <=                           read_state; 
    read_again:                     state <=                           read_state;
		read_state:                 state <= (flash_stop)?             wait_to_read_first_bits: read_state;   
		wait_to_read_first_bits:    state <= (frequency_clk)?          read_first_bits : wait_to_read_first_bits; 
		read_first_bits:            state <=                           wait_to_read_second_bits;                      
		wait_to_read_second_bits:   state <= (frequency_clk)?          read_second_bits : wait_to_read_second_bits;   
		read_second_bits:           state <=                           wait_to_read_third_bits; 
        wait_to_read_third_bits:    state <= (frequency_clk)?          read_third_bits : wait_to_read_third_bits; 
        read_third_bits:            state <=                           wait_to_read_forth_bits; 
        wait_to_read_forth_bits:    state <= (frequency_clk)?          read_forth_bits : wait_to_read_forth_bits;                       
        read_forth_bits:            state <=                           check_addresses_left;
        check_addresses_left:       state <= (address == end_address)? should_I_get_new_phoneme:read_again; 
        should_I_get_new_phoneme:   state <= (silent)?                 No : Yes;
        Yes:                        state <= (DATA_START_PHONEME == 1'b0)?  interrupt_1:Yes;
        No:                         state <= (OPER_DONE)?     finish2: finish; 
        finish:                     state <= (OPER_DONE ==1'b1 && silent== 1'b0)?     beginin: finish; 
        finish2:                    state <= (NUM_TWO_DONE)?  finish3:finish2;
        finish3:                    state <= (NUM_TWO_DONE == 1'b1 && silent== 1'b0)?     beginin: finish4; 
        finish4:                    state <= (EQ_DONE == 8'h3d)?                            reset: finish3; 
		default:                    state <= idle_state; 	
	    endcase 
    end 
always_ff@(posedge clk) 
    begin 
	    case (state)
        read_again:                   begin address <= address + 1'b1; out_data <= out_data;          end 
        prep_read:                    begin address <= start_address;  out_data <= out_data;          end 
		read_first_bits:              begin address <= address;        out_data <= flash_data[7:0];   end                         
		read_second_bits:             begin address <= address;        out_data <= flash_data[15:8];  end    
        read_third_bits:              begin address <= address;        out_data <= flash_data[23:16]; end                        
        read_forth_bits:              begin address <= address;        out_data <= flash_data[31:24]; end
	     default:                     begin address <= address;        out_data <= out_data;          end
	    endcase 
    end 

endmodule 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// KEYBOARD 
module KEYBOARD(clk,  sound_done, calc_finished, key, number_one, number_two, operation, done_number_one, done_operation, done_number_two, done_equal_reg);
input logic clk, calc_finished, sound_done;
input logic [7:0] key; 
output logic done_number_one, done_operation, done_number_two, done_equal_reg; 
output logic [4:0] number_one, number_two;
output logic [3:0] operation; 
logic [8:0] state; 
logic done_num_one, done_num_two, done_oper, done_equal;
logic [4:0] num_one, num_two;
logic [3:0] oper;

parameter check_num_one       = 9'b000000000; 
parameter check_num_two       = 9'b000000001;
parameter check_oper          = 9'b000000010;
parameter state_equal         = 9'b000000100;
parameter state_check_0       = 9'b000001000;
parameter state_check_1       = 9'b000010000;
parameter state_check_2       = 9'b000100000;
parameter state_check_3       = 9'b001000000;
parameter state_check_4       = 9'b010000000;
parameter state_check_5       = 9'b011000000;
parameter state_check_6       = 9'b111110000;
parameter state_check_7       = 9'b111110001;
parameter state_check_8       = 9'b111110010;
parameter state_check_9       = 9'b111110011;
parameter state_check_plus    = 9'b111110100;
parameter state_check_minus   = 9'b111110101;
parameter state_error_oper    = 9'b111110110; 
parameter state_error_num_one = 9'b111110111;
parameter state_error_num_two = 9'b111111000;
parameter state_reset         = 9'b111111001;
//Uppercase Letters

parameter character_idle  = 8'h0;
parameter character_plus  = 8'h2b;
parameter character_minus = 8'h2d;
parameter character_equal = 8'h3d;
parameter character_0     = 8'h30;
parameter character_1     = 8'h31;
parameter character_2     = 8'h32;
parameter character_3     = 8'h33;
parameter character_4     = 8'h34;
parameter character_5     = 8'h35;
parameter character_6     = 8'h36;
parameter character_7     = 8'h37;
parameter character_8     = 8'h38;
parameter character_9     = 8'h39;


assign done_number_one = done_num_one; 
assign done_number_two = done_num_two; 
assign done_operation = done_oper;
assign done_equal_reg = done_equal;
assign number_one = num_one; 
assign number_two = num_two; 
assign operation = oper;  
	
	
always_ff@(posedge clk)
    begin
		case(state)
		check_num_one: 
            begin 
			if      ((key == character_idle) || (key == character_equal)) begin state <= check_num_one; end
            else if (key == character_0)    begin state <= state_check_0; end
            else if (key == character_1)    begin state <= state_check_1; end
			else if (key == character_2)    begin state <= state_check_2; end
            else if (key == character_3)    begin state <= state_check_3; end
            else if (key == character_4)    begin state <= state_check_4; end
            else if (key == character_5)    begin state <= state_check_5; end
            else if (key == character_6)    begin state <= state_check_6; end
            else if (key == character_7)    begin state <= state_check_7; end
            else if (key == character_8)    begin state <= state_check_8; end
            else if (key == character_9)    begin state <= state_check_9; end
			else                                  state <= state_error_num_one; 
			end 
        state_check_0:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_oper; end
            else                               state <= state_check_0;
			end 
        state_check_1:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_oper; end
            else                               state <= state_check_1;
			end 
        state_check_2:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_oper; end
            else                               state <= state_check_2;
			end 
        state_check_3:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_oper; end
            else                               state <= state_check_3;
			end 
        state_check_4:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_oper; end
            else                               state <= state_check_4;
			end 
        state_check_5:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_oper; end
            else                               state <= state_check_5;
			end 
        state_check_6:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_oper; end
            else                               state <= state_check_6;
			end 
        state_check_7:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_oper; end
            else                               state <= state_check_7;
			end 
        state_check_8:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_oper; end
            else                               state <= state_check_8;
			end 
        state_check_9:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_oper; end
            else                               state <= state_check_9;
			end 
		check_oper: 
            begin 
			if      ((key < 8'h3a) && (key > 8'h2f)) begin state <= check_oper; end
            else if (key == character_plus) begin state <= (calc_finished)? state_error_oper :state_check_plus;  end
            else if (key == character_minus)begin state <= (calc_finished)? state_error_oper :state_check_minus; end
            else if (key == character_equal)begin state <= (calc_finished)? state_equal      :state_error_oper;  end
			else                                  state <= state_error_oper; 
			end       
        state_check_plus:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_num_two; end
            else                               state <= state_check_plus;
			end 
        state_check_minus:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_num_two; end
            else                               state <= state_check_minus;
			end          
        state_equal:
            begin 
            if     (sound_done == 1'b1)  begin state <= state_reset; end
            else                               state <= state_equal;
			end           
		check_num_two:
            begin 
			if      ((key == character_plus)||(key == character_minus)) begin state <= check_num_two; end
            else if (key == character_0)    begin state <= state_check_0; end
            else if (key == character_1)    begin state <= state_check_1; end
			else if (key == character_2)    begin state <= state_check_2; end
            else if (key == character_3)    begin state <= state_check_3; end
            else if (key == character_4)    begin state <= state_check_4; end
            else if (key == character_5)    begin state <= state_check_5; end
            else if (key == character_6)    begin state <= state_check_6; end
            else if (key == character_7)    begin state <= state_check_7; end
            else if (key == character_8)    begin state <= state_check_8; end
            else if (key == character_9)    begin state <= state_check_9; end
			else                                  state <= state_error_num_two;   
			end 
        state_error_num_one:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_num_one; end
            else                               state <= state_error_num_one;
			end 
        state_error_oper:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_oper; end
            else                               state <= state_error_oper;
			end 
        state_error_num_two:
            begin 
            if     (sound_done == 1'b1)  begin state <= check_num_two; end
            else                               state <= state_error_num_two;
			end 
        state_reset: begin state <= check_num_one; end

		default: state <= state_reset; 
		endcase
	end
	
always_ff@(posedge clk)
    begin
		case(state)
		check_num_one: 
            begin 
			if      ((key == character_idle) || (key == character_equal))begin num_one <= num_one ; oper <= oper; num_two <= num_two; done_num_one <= 1'b0; done_num_two <= 1'b0; done_oper <= 1'b0; done_equal <= 1'b0; end ///if it has trouble it is because this- num one- has no value 
            else if (key == character_0)                                 begin num_one <= 5'b00000; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_1)                                 begin num_one <= 5'b00001; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
			else if (key == character_2)                                 begin num_one <= 5'b00010; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_3)                                 begin num_one <= 5'b00011; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_4)                                 begin num_one <= 5'b00100; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_5)                                 begin num_one <= 5'b00101; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_6)                                 begin num_one <= 5'b00110; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_7)                                 begin num_one <= 5'b00111; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_8)                                 begin num_one <= 5'b01000; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_9)                                 begin num_one <= 5'b01001; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
			else                                                         begin num_one <= num_one ; oper <= oper; num_two <= num_two; done_num_one <= 1'b0; done_num_two <= 1'b0; done_oper <= 1'b0; done_equal <= 1'b0;end
			end 
		check_oper:
            begin 
			if      ((key < 8'h3a)&& (key > 8'h2f))                     begin num_one <= num_one; oper <= oper; num_two <= num_two; done_oper <= 1'b0;      done_equal <= done_equal; done_num_one <= done_num_one; done_num_two <= done_num_two;end
            else if (key == character_plus)                             begin num_one <= num_one; oper <=  oper;        num_two <= num_two; done_oper <= done_oper; done_equal <= done_equal; done_num_one <= done_num_one; done_num_two <= done_num_two;end
            else if (key == character_minus)                            begin num_one <= num_one; oper <=  oper;        num_two <= num_two; done_oper <= done_oper; done_equal <= done_equal; done_num_one <= done_num_one; done_num_two <= done_num_two;end
            else if (key == character_equal)                            begin num_one <= num_one; oper <=  oper;        num_two <= num_two; done_oper <= done_oper; done_equal <= done_equal; done_num_one <= done_num_one; done_num_two <= done_num_two;end
			else                                                        begin num_one <= num_one; oper <= oper; num_two <= num_two; done_oper <= done_oper; done_equal <= done_equal; done_num_one <= done_num_one; done_num_two <= done_num_two;end
			end             
		check_num_two:
            begin
			if      ((key == character_plus)||(key == character_minus)) begin num_one <= num_one; oper <= oper; num_two <= num_two ; done_num_one <= done_num_one; done_num_two <= 1'b0; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_0)                                begin num_one <= num_one; oper <= oper;num_two <= 5'b00000; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_1)                                begin num_one <= num_one; oper <= oper;num_two <= 5'b00001; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
			else if (key == character_2)                                begin num_one <= num_one; oper <= oper;num_two <= 5'b00010; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_3)                                begin num_one <= num_one; oper <= oper;num_two <= 5'b00011; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_4)                                begin num_one <= num_one; oper <= oper;num_two <= 5'b00100; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_5)                                begin num_one <= num_one; oper <= oper;num_two <= 5'b00101; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_6)                                begin num_one <= num_one; oper <= oper;num_two <= 5'b00110; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_7)                                begin num_one <= num_one; oper <= oper;num_two <= 5'b00111; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_8)                                begin num_one <= num_one; oper <= oper;num_two <= 5'b01000; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_9)                                begin num_one <= num_one; oper <= oper;num_two <= 5'b01001; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
			else                                                        begin num_one <= num_one; oper <= oper;num_two <= num_two ; done_num_two <= done_num_two; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            end
        state_check_0:                      begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;  end
        state_check_1:                      begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;  end
        state_check_2:                      begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;  end
        state_check_3:                      begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;  end
        state_check_4:                      begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;  end
        state_check_5:                      begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;  end
        state_check_6:                      begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;  end
        state_check_7:                      begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;  end
        state_check_8:                      begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;  end
        state_check_9:                      begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;  end
        state_check_plus:                   begin num_one <= num_one; oper <=  (calc_finished)? oper : 4'b1010; num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= 1'b1;      done_equal <= done_equal;  end
        state_check_minus:                  begin num_one <= num_one; oper <=  (calc_finished)? oper : 4'b1000; num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= 1'b1;      done_equal <= done_equal;  end
        state_equal:                        begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= 1'b1;  end
        state_error_num_one:                begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;  end
        state_error_oper:                   begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;  end
        state_error_num_two:                begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= done_num_one; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;  end
        state_reset:                        begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= 1'b0;         done_num_two <= 1'b0;         done_oper <= done_oper; done_equal <= 1'b0;end
		default:                            begin num_one <= 5'b11111;oper <= 4'b0000;                          num_two <= 5'b11111;done_num_one <= 1'b0;         done_num_two <= 1'b0;         done_oper <= 1'b0;      done_equal <= 1'b0;end
		endcase
	end
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// CALCULATOR
module CALCULATOR(clk, num_one, num_two, operation, results, calculator_done,in1, in2, in3);
input logic clk; 
input logic [4:0] num_one, num_two;
input logic [3:0] operation; 
input logic in1, in2, in3; 

output logic [4:0] results; 
output logic calculator_done; 
logic decide_plus,decide_minus,reset;

assign decide_plus =  ((operation == 4'b1010) && (in1 == 1'b1) && (in2 == 1'b1) && (in3 == 1'b1))? 1'b1:1'b0; 
assign decide_minus = ((operation == 4'b1000) && (in1 == 1'b1) && (in2 == 1'b1) && (in3 == 1'b1))? 1'b1:1'b0; 
assign reset = (in1 == 1'b0) && (in2 == 1'b0) && (in3 == 1'b0);
always_ff@(posedge clk) 
    begin
            if      (reset       == 1'b1) begin calculator_done = 1'b0; end
            else if (decide_plus == 1'b1) begin results <= num_one + num_two; calculator_done <= 1'b1; end
            else if (decide_minus== 1'b1) begin results <= num_one - num_two; calculator_done <= 1'b1; end
            else                          begin results <= results; calculator_done <= calculator_done; end
    end 
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// ABS DATA
module abs(input clk, input [n-1:0] data, output [n-1:0] abs_data); 
parameter n = 8; 
wire [n-1:0] ext = {n{data[n-1]}};  

always_ff@(posedge clk) 
    begin 
	abs_data <= (ext^data) - (ext); 
    end 
endmodule  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// LED AVERAGE 
module NASER(reset, clk, in_data, LEDSTUFF, in1, silent, store,key);
input logic clk, in1, reset, silent; // silent and reset not useful
input logic [7:0] in_data; 
input logic [7:0] key; //not useful
output logic [9:0] LEDSTUFF; 
output logic [11:0] store; //not useful just for debugging

logic [9:0] count, averaged, LEDSHIT;
logic [11:0] state; 
logic [19:0] value;

parameter IDLE    = 12'b0000_0000_1000;
parameter RESET   = 12'b0000_0000_0100;
parameter GETDATA = 12'b1111_1111_0001;
parameter SUM     = 12'b1111_1110_0001;
parameter AGAIN   = 12'b1111_1100_0001;
parameter REPLACE = 12'b1111_1000_0001;
parameter AVERAGE = 12'b1111_0000_0001;


assign LEDSTUFF = LEDSHIT; 
assign store = state; 
always_ff @(posedge clk) begin
	case(state)		
        IDLE:    state <=                              RESET; 
        RESET:   state <=                            GETDATA; 
    	GETDATA: state <=                                SUM; 
		SUM:     state <= (count == 10'hFF)?   AVERAGE:AGAIN; 
        AGAIN:   state <= (reset)?             RESET:GETDATA;
        AVERAGE: state <=                            REPLACE; 
        REPLACE: state <=                               IDLE;  
		default: state <=                               IDLE;
	endcase
end

always_ff @(posedge clk) 
    begin
    case(state)
        RESET:   begin count <= 10'h0; value <= 20'b0; averaged <= 10'h0; LEDSHIT <= LEDSHIT; end 
        GETDATA: begin value <= value + in_data; count <= count + 1; end
        AVERAGE: begin averaged <= value[18:9];count <= 10'h0; end 
        REPLACE: 
                 begin
                    if (averaged[9])      begin LEDSHIT <= 10'b11111_11111; end 
                    else if (averaged[8]) begin LEDSHIT <= 10'b11111_11110; end
                    else if (averaged[7]) begin LEDSHIT <= 10'b11111_11100; end
                    else if (averaged[6]) begin LEDSHIT <= 10'b11111_11000; end
                    else if (averaged[5]) begin LEDSHIT <= 10'b11111_10000; end
                    else if (averaged[4]) begin LEDSHIT <= 10'b11111_00000; end
                    else if (averaged[3]) begin LEDSHIT <= 10'b11110_00000; end
                    else if (averaged[2]) begin LEDSHIT <= 10'b11100_00000; end
                    else if (averaged[1]) begin LEDSHIT <= 10'b11000_00000; end
                    else if (averaged[0]) begin LEDSHIT <= 10'b10000_00000; end
                    else begin LEDSHIT <= 10'b0; end
                 end
        default: begin count <= count; value <= value; averaged <= averaged; LEDSHIT <= LEDSHIT; end
    endcase
    end

endmodule
