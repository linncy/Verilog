`timescale 10ns/1ns
module sim_upcount;
	parameter DELAY=10;
	reg Clear,clk;
	wire[1:0] outp;
	upcount up1(Clear,clk,outp);
	always #(DELAY/2)clk=~clk;
	initial begin
				clk=0;Clear=1;
				#DELAY Clear=0;
  end
endmodule