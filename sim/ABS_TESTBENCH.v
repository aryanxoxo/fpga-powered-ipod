module ABS_TESTBENCH; 
reg clk;
reg [7:0] data; 
wire [7:0] abs_data;
abs inst(.clk(clk), .data(data), .abs_data(abs_data));

initial begin 
clk = 0 ; data =8'h17;  #100; 
clk = 1 ; data =8'h18;  #100; 
clk = 0 ; data =8'h19;  #100; 
clk = 1 ; data =8'h1A;  #100; 
clk = 0 ; data =8'h1B;  #100; 
clk = 1 ; data =8'h1C;  #100; 
clk = 0 ; data =8'h1D;  #100; 
clk = 1 ; data =8'h1E;  #100;
clk = 0 ; data= 8'h1F;  #100; 
clk = 1 ; data =8'h01;  #100; 
clk = 0 ; data =8'h02;  #100; 
clk = 1 ; data =8'h03;  #100;
clk = 0 ; data =8'h04;  #100; 
clk = 1 ; data =8'h05;  #100; 
clk = 0 ; data =8'h06;  #100; 
clk = 1 ; data =8'h07;  #100;

end 
endmodule