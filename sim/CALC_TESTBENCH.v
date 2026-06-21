module CALC_TESTBENCH; 
reg  clk; 
reg [4:0] num2, num1;
reg [3:0] op; 
reg in1, in2, in3; 

wire [4:0] results; 
wire calculator_done; 

CALCULATOR inst(.clk(clk), .num_one(num1), .num_two(num2), .operation(op), .results(results), .calculator_done(calc_done), .in1(in1), .in2(in2), .in3(in3));
initial begin 
clk = 0 ;  num1 = 5'd4;  num2 = 5'd4; op = 4'd8; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 1 ;  num1 = 5'd4;  num2 = 5'd4; op = 4'd8; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 0 ;  num1 = 5'd4;  num2 = 5'd4; op = 4'd10; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 1 ;  num1 = 5'd4;  num2 = 5'd4; op = 4'd10; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 0 ;  num1 = 5'd4;  num2 = 5'd3; op = 4'd8; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 1 ;  num1 = 5'd4;  num2 = 5'd3; op = 4'd8; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 0 ;  num1 = 5'd4;  num2 = 5'd3; op = 4'd10; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 1 ;  num1 = 5'd4;  num2 = 5'd3; op = 4'd10; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 0 ;  num1 = 5'd4;  num2 = 5'd4; op = 4'd8; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 1 ;  num1 = 5'd4;  num2 = 5'd4; op = 4'd8; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 0 ;  num1 = 5'd4;  num2 = 5'd4; op = 4'd10; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 1 ;  num1 = 5'd4;  num2 = 5'd4; op = 4'd10; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 0 ;  num1 = 5'd4;  num2 = 5'd3; op = 4'd8; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 1 ;  num1 = 5'd4;  num2 = 5'd3; op = 4'd8; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 0 ;  num1 = 5'd4;  num2 = 5'd3; op = 4'd10; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 
clk = 1 ;  num1 = 5'd4;  num2 = 5'd3; op = 4'd10; in1 = 1'd1; in2 = 1'd1; in3 = 1'd1; #100; 

end 
endmodule