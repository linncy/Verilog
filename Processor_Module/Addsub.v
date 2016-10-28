module Addsub(AddSub,input_A,input_B,output_ans);
	input AddSub;
	input [15:0] input_A,input_B;
	output reg[15:0] output_ans;
	always@(input_A or input_B)
	begin
	if(AddSub==0)
		begin
			output_ans=input_A+input_B;
		end
	else
		begin
			output_ans=input_A-input_B;
		end
	end
endmodule