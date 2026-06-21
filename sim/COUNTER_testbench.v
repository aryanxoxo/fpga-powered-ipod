module COUNTER_testbench; 
reg up, down, rst, clk; 
wire [31:0] count; 
COUNTER inst_test(.clk(clk), .up(up), .down(down), .rst(rst), .count(count)); 
initial begin 
clk = 1; up = 0; down = 0; rst = 0; #100;
clk = 0; up = 0; down = 0; rst = 0; #100;
clk = 1; up = 0; down = 0; rst = 0; #100;
clk = 0; up = 0; down = 0; rst = 0; #100;
clk = 1; up = 0; down = 0; rst = 0; #100;
clk = 0; up = 0; down = 0; rst = 0; #100;
clk = 1; up = 0; down = 0; rst = 0; #100;
clk = 0; up = 1; down = 0; rst = 0; #100;
clk = 1; up = 1; down = 0; rst = 0; #100;
clk = 0; up = 0; down = 0; rst = 0; #100;
clk = 1; up = 0; down = 0; rst = 0; #100;
clk = 0; up = 0; down = 0; rst = 1; #100;
clk = 1; up = 0; down = 0; rst = 1; #100;
clk = 0; up = 0; down = 0; rst = 1; #100;
clk = 1; up = 0; down = 0; rst = 0; #100;
clk = 0; up = 0; down = 0; rst = 0; #100;
clk = 1; up = 0; down = 0; rst = 0; #100;
clk = 0; up = 0; down = 0; rst = 0; #100;
clk = 1; up = 0; down = 0; rst = 0; #100;
clk = 0; up = 0; down = 0; rst = 0; #100;
clk = 1; up = 0; down = 0; rst = 0; #100;
clk = 0; up = 0; down = 1; rst = 0; #100;
clk = 1; up = 0; down = 1; rst = 0; #100;
clk = 0; up = 0; down = 1; rst = 0; #100;
clk = 1; up = 0; down = 1; rst = 0; #100;
clk = 0; up = 0; down = 0; rst = 0; #100;
clk = 1; up = 0; down = 0; rst = 0; #100;
clk = 0; up = 0; down = 0; rst = 0; #100;
clk = 1; up = 0; down = 0; rst = 0; #100;
clk = 0; up = 0; down = 0; rst = 0; #100;
clk = 1; up = 0; down = 0; rst = 0; #100;
clk = 0; up = 0; down = 0; rst = 0; #100;
clk = 1; up = 0; down = 0; rst = 0; #100;
clk = 0; up = 0; down = 0; rst = 0; #100;

end 
endmodule