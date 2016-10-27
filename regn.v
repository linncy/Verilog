module regn(R,Rin,Clock,Q);//16位D触发器 R十六位输入 Rin使能 Q十六位输出
	parameter n=16;
	input[n-1:0] R;
	input Rin,Clock;
	output[n-1:0] Q;
	reg[n-1:0] Q;
	always @(posedge Clock)
		if(Rin)
			Q<=R;
endmodule