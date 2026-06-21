
`default_nettype none
 `define USE_PACOBLAZE
module picoblaze_template #(parameter clk_freq_in_hz = 25000000) (
    output reg[7:0] PHONEME, 
output reg DATA_START_PHONEME, 
output reg finish_reading_oper, 
input clk,
input [7:0] input_data, 
input [7:0] input_data_2, 
input [7:0] input_data_3, 
input [7:0] DATA_FINISH_PHONEME, 
input [7:0] NUM_ONE_DONE, 
input [7:0] NUM_TWO_DONE,
input [7:0] OPER_DONE, 
input [7:0] EQ_DONE,
input [7:0] DONE,
input [7:0] stop_oper,
 input signal_from_interrupt); 
//------------------------------------------------------------------------------------
//--
//-- Signals used to connect KCPSM3 to program ROM and I/O logic
//--
wire[9:0]  address;
wire[17:0]  instruction;
wire[7:0]  port_id;
wire[7:0]  out_port;
reg[7:0]  in_port;
wire  write_strobe;
wire  read_strobe;
reg  interrupt;
wire  interrupt_ack;
wire  kcpsm3_reset;
//--
//-- Signals used to generate interrupt 
//--
reg[26:0] int_count;
reg event_1hz;
//-- Signals for LCD operation
//--
//--
reg        lcd_rw_control;
reg[7:0]   lcd_output_data;
    
    pacoblaze3 led_8seg_kcpsm( .address(address), .instruction(instruction), .port_id(port_id), .write_strobe(write_strobe), .out_port(out_port), .read_strobe(read_strobe), .in_port(in_port), .interrupt(interrupt), .interrupt_ack(interrupt_ack), .reset(kcpsm3_reset),.clk(clk));

wire [19:0] raw_instruction;
	
    pacoblaze_instruction_memory pacoblaze_instruction_memory_inst(.addr(address),.outdata(raw_instruction));
	
    always @ (posedge clk)
	begin
	      instruction <= raw_instruction[17:0];
	end

    assign kcpsm3_reset = 0;                       
  
//  ----------------------------------------------------------------------------------------------------------------------------------
//  -- Interrupt 
//  ----------------------------------------------------------------------------------------------------------------------------------
//  --
//  --
//  -- Interrupt is used to provide a 1 second time reference.
//  --
//  --
//  -- A simple binary counter is used to divide the 50MHz system clock and provide interrupt pulses.
//  --
    assign event_1hz = signal_from_interrupt? 1'b1: 1'b0; 
    always @ (posedge clk or posedge interrupt_ack)  //FF with clock "clk" and reset "interrupt_ack"
    begin
        if (interrupt_ack) //if we get reset, reset interrupt in order to wait for next clock.
                interrupt <= 0;
        else
            begin 
                if (event_1hz)   //clock enable
                    interrupt <= 1;
                    else
                        interrupt <= interrupt;
        end
    end
//  --
//  ----------------------------------------------------------------------------------------------------------------------------------
//  -- KCPSM3 input ports 
//  ----------------------------------------------------------------------------------------------------------------------------------
//  --
//  --
//  -- The inputs connect via a pipelined multiplexer
//  --
    always @ (posedge clk)
    begin
        case (port_id[7:0])
            8'd00:    in_port <= input_data;
            8'd01:    in_port <= DATA_FINISH_PHONEME;
            8'd02:    in_port <= NUM_ONE_DONE;
            //8'd03:    in_port <= DONE;//sto in psm
            8'd04:    in_port <= input_data_2;
            8'd05:    in_port <= OPER_DONE;
            //8'd06:    in_port <= stop_oper;
            8'd07:    in_port <= input_data_3;
            8'd08:    in_port <= NUM_TWO_DONE;
            8'd09:    in_port <= EQ_DONE;
            default: in_port <= 8'bx;
        endcase
    end
//
//  --
//  ----------------------------------------------------------------------------------------------------------------------------------
//  -- KCPSM3 output ports 
//  ----------------------------------------------------------------------------------------------------------------------------------
//  --
//  -- adding the output registers to the processor
//  --
//  
    always @ (posedge clk)
    begin

            //port 80 hex 
            if (write_strobe & port_id[7])  //clock enable 
            PHONEME <= out_port;

            //port 40 hex 
            if (write_strobe & port_id[6])  //clock enable 
            DATA_START_PHONEME <= out_port; 	
            //port 20 hex 
            if (write_strobe & port_id[5])  //clock enable 
            finish_reading_oper <= out_port;	      
    end
endmodule

module pacoblaze_instruction_memory
(
 input [9:0] addr,
 output  [17:0] outdata
 );
 
           reg [19:0] memory [1024];
           integer   index;

           initial begin
              $readmemh("pracpico.mem",memory);
           end
		   
		  assign     outdata = memory[addr];
		 
 endmodule
