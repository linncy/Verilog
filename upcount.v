module upcount(Clear,Clock,Q); //��λ�������ۼ���
	input Clear,Clock;
	output[1:0] Q;
	reg[1:0] Q;	
	always @(posedge Clock)
	begin
		if(Clear)
			Q=2'b0;
		else
			Q=Q+1'b1;
	end
endmodule
	