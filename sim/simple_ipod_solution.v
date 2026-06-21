
/*
logic calc_finished, done_number_one, done_operation, done_number_two, done_equal_reg; 
logic [4:0] number_one, number_two; 
logic [3:0] operation; 

//assign calc_finished = (done_number_one && done_operation && done_number_two) ;
KEYBOARD keyboarder(.clk(CLK_50M),  .sound_done(1'b1), .calc_finished(SW[5]), .key(kbd_received_ascii_code), .number_one(LED[9:5]), .number_two(LED[4:0]),
.operation(operation), .done_number_one(done_number_one), .done_operation(done_operation), .done_number_two(done_number_two), .done_equal_reg(done_equal_reg));
//assign LED[9:2] = kbd_received_ascii_code; 
//======================================================================================
// 
// Keyboard Interface
//
//*/

module KEYBOARD(clk,  sound_done, calc_finished, key, number_one, number_two, operation, done_number_one, done_operation, done_number_two, done_equal_reg);
input clk, calc_finished, sound_done;
input  [7:0] key; 
output  done_number_one, done_operation, done_number_two, done_equal_reg; 
output [4:0] number_one, number_two;
output [3:0] operation; 

reg [8:0] state; 
reg done_num_one, done_num_two, done_oper, done_equal;
reg [4:0] num_one, num_two;
reg [3:0] oper;

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

parameter character_idle  = 8'h2a;
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
	
	
always@(posedge clk)
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
	
always@(posedge clk)
    begin
		case(state)
		check_num_one: 
            begin 
			if      ((key == character_idle) || (key == character_equal)) begin num_one <= num_one ; oper <= oper; num_two <= num_two; done_num_one <= 1'b0; done_num_two <= 1'b0; done_oper <= 1'b0; done_equal <= 1'b0; end ///if it has trouble it is because this- num one- has no value 
            else if (key == character_0)    begin num_one <= 5'b00000; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_1)    begin num_one <= 5'b00001; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
			else if (key == character_2)    begin num_one <= 5'b00010; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_3)    begin num_one <= 5'b00011; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_4)    begin num_one <= 5'b00100; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_5)    begin num_one <= 5'b00101; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_6)    begin num_one <= 5'b00110; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_7)    begin num_one <= 5'b00111; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_8)    begin num_one <= 5'b01000; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_9)    begin num_one <= 5'b01001; oper <= oper; num_two <= num_two; done_num_one <= 1'b1; done_num_two <= done_num_two; done_oper <= done_oper; done_equal <= done_equal;end
			else                                                         begin num_one <= num_one ; oper <= oper; num_two <= num_two; done_num_one <= 1'b0; done_num_two <= 1'b0; done_oper <= 1'b0; done_equal <= 1'b0;end
			end 
		check_oper:
            begin 
			if      ((key < 8'h3a)&& (key > 8'h2f)) begin num_one <= num_one; oper <= oper; num_two <= num_two; done_oper <= 1'b0;      done_equal <= done_equal; done_num_one <= done_num_one; done_num_two <= done_num_two;end
            else if (key == character_plus) begin num_one <= num_one; oper <=  oper;        num_two <= num_two; done_oper <= done_oper; done_equal <= done_equal; done_num_one <= done_num_one; done_num_two <= done_num_two;end
            else if (key == character_minus)begin num_one <= num_one; oper <=  oper;        num_two <= num_two; done_oper <= done_oper; done_equal <= done_equal; done_num_one <= done_num_one; done_num_two <= done_num_two;end
            else if (key == character_equal)begin num_one <= num_one; oper <=  oper;        num_two <= num_two; done_oper <= done_oper; done_equal <= done_equal; done_num_one <= done_num_one; done_num_two <= done_num_two;end
			else                                    begin num_one <= num_one; oper <= oper; num_two <= num_two; done_oper <= done_oper; done_equal <= done_equal; done_num_one <= done_num_one; done_num_two <= done_num_two;end
			end             
		check_num_two:
            begin
			if      ((key == character_plus)||(key == character_minus)) begin num_one <= num_one; oper <= oper; num_two <= num_two ; done_num_one <= done_num_one; done_num_two <= 1'b0; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_0)    begin num_one <= num_one; oper <= oper;num_two <= 5'b00000; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_1)    begin num_one <= num_one; oper <= oper;num_two <= 5'b00001; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
			else if (key == character_2)    begin num_one <= num_one; oper <= oper;num_two <= 5'b00010; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_3)    begin num_one <= num_one; oper <= oper;num_two <= 5'b00011; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_4)    begin num_one <= num_one; oper <= oper;num_two <= 5'b00100; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_5)    begin num_one <= num_one; oper <= oper;num_two <= 5'b00101; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_6)    begin num_one <= num_one; oper <= oper;num_two <= 5'b00110; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_7)    begin num_one <= num_one; oper <= oper;num_two <= 5'b00111; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_8)    begin num_one <= num_one; oper <= oper;num_two <= 5'b01000; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
            else if (key == character_9)    begin num_one <= num_one; oper <= oper;num_two <= 5'b01001; done_num_two <= 1'b1; done_num_one <= done_num_one; done_oper <= done_oper; done_equal <= done_equal;end
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
        state_reset:                        begin num_one <= num_one; oper <= oper;                             num_two <= num_two; done_num_one <= 1'b0;         done_num_two <= 1'b0;         done_oper <= 1'b0;      done_equal <= 1'b0;end
		default:                            begin num_one <= 5'b11111;oper <= 4'b0000;                          num_two <= 5'b11111;done_num_one <= 1'b0;         done_num_two <= 1'b0;         done_oper <= 1'b0;      done_equal <= 1'b0;end
		endcase
	end
endmodule
