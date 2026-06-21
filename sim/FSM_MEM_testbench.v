module FSM_MEM_testbench; 
reg read, data_valid, waitrequest, clk, in ;
wire out;

FSM_MEM inst_fsm(.clk(clk), .read(read), .waitrequest(waitrequest), .data_valid(data_valid), .in(in), .out(out)); 
initial begin 
clk = 1; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 0; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 1; read = 0; waitrequest = 0; data_valid = 0; in = 1; #100; 
clk = 0; read = 1; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 1; read = 1; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 0; read = 0; waitrequest = 1; data_valid = 0; in = 0; #100; 
clk = 1; read = 0; waitrequest = 1; data_valid = 0; in = 0; #100; 
clk = 0; read = 0; waitrequest = 1; data_valid = 0; in = 0; #100; 
clk = 1; read = 0; waitrequest = 1; data_valid = 1; in = 0; #100; 
clk = 0; read = 0; waitrequest = 0; data_valid = 1; in = 0; #100; 
clk = 1; read = 0; waitrequest = 0; data_valid = 1; in = 0; #100; 
clk = 0; read = 0; waitrequest = 0; data_valid = 1; in = 0; #100; 
clk = 1; read = 0; waitrequest = 0; data_valid = 1; in = 0; #100; 
clk = 0; read = 0; waitrequest = 0; data_valid = 1; in = 0; #100; 
clk = 1; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 0; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 1; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 0; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 1; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 0; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 1; read = 0; waitrequest = 0; data_valid = 0; in = 1; #100; 
clk = 0; read = 1; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 1; read = 1; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 0; read = 0; waitrequest = 1; data_valid = 0; in = 0; #100; 
clk = 1; read = 0; waitrequest = 1; data_valid = 0; in = 0; #100; 
clk = 0; read = 0; waitrequest = 1; data_valid = 0; in = 0; #100; 
clk = 1; read = 0; waitrequest = 1; data_valid = 0; in = 0; #100; 
clk = 0; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 1; read = 0; waitrequest = 0; data_valid = 1; in = 0; #100; 
clk = 0; read = 0; waitrequest = 0; data_valid = 1; in = 0; #100; 
clk = 1; read = 0; waitrequest = 0; data_valid = 1; in = 0; #100; 
clk = 0; read = 0; waitrequest = 0; data_valid = 1; in = 0; #100; 
clk = 1; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 0; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 1; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 0; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 1; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
clk = 0; read = 0; waitrequest = 0; data_valid = 0; in = 0; #100; 
end 
endmodule