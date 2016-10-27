module regn(R,Rin,Clock,Q);//16λD������ Rʮ��λ���� Rinʹ�� Qʮ��λ���
	parameter n=16;
	input[n-1:0] R;
	input Rin,Clock;
	output[n-1:0] Q;
	reg[n-1:0] Q;
	always @(posedge Clock)
		if(Rin)
			Q<=R;
endmodule