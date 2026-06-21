module led_TESTBENCH; 
reg clk, reset; // silent and reset not useful
reg  [7:0] in_data; 
wire  [9:0] LEDSTUFF; 

NASER inst(.reset(reset), .clk(clk), .in_data(in_data), .LEDSTUFF(LEDSTUFF));
initial begin 
clk = 0 ;  reset = 1'b0; in_data = 8'h2a;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h31;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h53;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h53;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h00;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h00;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h00;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h53;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h2a;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h31;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h53;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h53;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h00;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h00;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h00;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h53;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h2a;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h31;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h53;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h53;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h00;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h00;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h00;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h53;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h2a;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h31;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h53;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h53;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h00;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h00;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h00;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h53;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h2a;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h31;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h53;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h53;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h00;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h00;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h00;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h53;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h2a;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h31;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h53;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h53;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h00;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h00;  #100;
clk = 0 ;  reset = 1'b0; in_data = 8'h00;  #100; 
clk = 1 ;  reset = 1'b0; in_data = 8'h53;  #100;
end 
endmodule