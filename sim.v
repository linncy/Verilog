`timescale 10ns/1ns
module sim;
	parameter DELAY=10;
	reg[15:0] DIN;
	reg Resetn,clk,Run;
	wire Done;
	wire[15:0] BUS;
	Processor CPU(DIN,Resetn,clk,Run,Done,BUS);
	always #(DELAY/2)clk=~clk;
	initial begin
				clk=0;Resetn=0;DIN=16'b0000000000000000;
				#(DELAY) Resetn=1;DIN=16'b0000000001000000;//mvi 000
				#(DELAY) DIN=16'b1010101010101010;//DIN->R0		
						
				#(DELAY) DIN=16'b0000000000001000;//mv R0->R1
				
				#(DELAY*2) DIN=16'b0000000001000000;//mvi 000
				#(DELAY) DIN=16'b0101010101010101;//DIN->R0
				
				#(DELAY) DIN=16'b0000000010000001;//add 000 001
				
				#(DELAY*4) DIN=16'b0000000011000001;//sub 000 001
				
  end
	initial $monitor($time,,,"Clock=%d Resetn=%d DIN=%d Run=%d Done=%d BUS=%d",clk,Resetn,DIN,Run,Done,BUS);
endmodule