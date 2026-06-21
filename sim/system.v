
module FSM_MEM(clk, read, waitrequest, data_valid, in, out); 
input clk;                                //Trivial
input read, data_valid, waitrequest;      //FROM MEMORY BLOCK 
input in;                              //from ADDRESS_CNTRL
output out;                        //to ADDRESS_CNTRL
reg [4:0] state;   //logic [5:0] state; 

parameter idle                         = 5'b0000_0; 
parameter check_oper                   = 5'b0001_0; 
parameter wait_for_waitrequest_negedge = 5'b0010_0; 
parameter wait_for_datavalid_negedge   = 5'b0100_0; 
parameter again                        = 5'b1000_1; 

always@(posedge clk)
    begin
	    case(state) 
	    5'b0000_0: state <= (in)? check_oper : idle;
	    5'b0001_0: state <= (read)? wait_for_waitrequest_negedge : check_oper; 
	    5'b0010_0: state <= (~waitrequest)? wait_for_datavalid_negedge : wait_for_datavalid_negedge; 
	    5'b0100_0: state <= (~data_valid)? again : wait_for_datavalid_negedge; 
	    5'b1000_1: state <= idle;
	    default:   state <= idle; 
	endcase 
    end
assign out = state[0]; 
endmodule 

module NASER(reset, clk, in_data, LEDSTUFF);
input clk, reset; // silent and reset not useful
input  [7:0] in_data; 
output  [9:0] LEDSTUFF; 
reg [9:0] count, averaged, LEDSHIT;
reg [11:0] state; 
reg [19:0] value;
parameter IDLE    = 12'b0000_0000_1000;
parameter RESET   = 12'b0000_0000_0100;
parameter GETDATA = 12'b1111_1111_0001;
parameter SUM     = 12'b1111_1110_0001;
parameter AGAIN   = 12'b1111_1100_0001;
parameter REPLACE = 12'b1111_1000_0001;
parameter AVERAGE = 12'b1111_0000_0001;

assign LEDSTUFF = LEDSHIT; 
 
always@(posedge clk) begin
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

always@(posedge clk) 
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
module COUNTER(clk, up, down, rst,count); 
 
input up, down, rst, clk; 
output [31:0] count; 
reg [31:0 ] counterino = 32'd1136; 
always@(posedge clk)
    begin
        if (rst)    begin counterino <= 32'd1136; end                 //if rst count = 1136
        else if (up) begin counterino <= counterino + 32'd15; end     //if up then count > 1136
        else if (down) begin counterino <= counterino - 32'd15; end   //if down then count < 1136
        else begin counterino <= counterino; end
    end 
assign count = counterino; 
endmodule
module CALCULATOR(clk, num_one, num_two, operation, results, calculator_done,in1, in2, in3);
input  clk; 
input [4:0] num_one, num_two;
input [3:0] operation; 
input in1, in2, in3; 

output  reg [4:0] results; 
output reg calculator_done; 
wire decide_plus,decide_minus,reset;

assign decide_plus =  ((operation == 4'b1010) && (in1 == 1'b1) && (in2 == 1'b1) && (in3 == 1'b1))? 1'b1:1'b0; 
assign decide_minus = ((operation == 4'b1000) && (in1 == 1'b1) && (in2 == 1'b1) && (in3 == 1'b1))? 1'b1:1'b0; 
assign reset = (in1 == 1'b0) && (in2 == 1'b0) && (in3 == 1'b0);
always@(posedge clk) 
    begin
            if      (reset       == 1'b1) begin calculator_done = 1'b0; end
            else if (decide_plus == 1'b1) begin results <= num_one + num_two; calculator_done <= 1'b1; end
            else if (decide_minus== 1'b1) begin results <= num_one - num_two; calculator_done <= 1'b1; end
            else                          begin results <= results; calculator_done <= calculator_done; end
    end 
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// ABS DATA
module abs(clk, data, abs_data); 
parameter n = 8; 
input clk;
input [n-1:0] data; 
output reg [n-1:0] abs_data;

wire [n-1:0] ext = {n{data[n-1]}};  

always@(posedge clk) 
    begin 
	abs_data <= (ext^data) - (ext); 
    end 
endmodule  


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

module ADDRESS_CNTRL(EQ_DONE, NUM_TWO_DONE,OPER_DONE, address_in,clk, frequency_clk,NUM_ONE_DONE, flash_stop, DATA_START_PHONEME, flash_data, start_address, end_address, silent, flash_begin, read, DATA_FINISH_PHONEME, out_data, address_out, state_indi); 

input  clk, frequency_clk;  //trivial
input  NUM_ONE_DONE, NUM_TWO_DONE; 
input  OPER_DONE;
input  [7:0] EQ_DONE;
input  flash_stop;          //from FSM_MEM
input  DATA_START_PHONEME, silent;
input  [31:0] flash_data;   //from flash memory 
input [23:0] start_address, end_address; 
input [23:0] address_in;

output  flash_begin, read; // to FSM_MEM //  to falsh memory 
output  [23:0] address_out; //to flash memory 
output reg [7:0] out_data; //To audio 
output  DATA_FINISH_PHONEME;   

reg [11:0] state;      
reg [23:0] address; //new

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
 

///////OUTPUTS
    assign flash_begin = state[0]; 
    assign read = state[0]; 
    assign DATA_FINISH_PHONEME = state[2]; 

    assign address_out = address; //new
///////SEQUENTIAL
always@(posedge clk) 
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
always@(posedge clk) 
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