module Processor(DIN,Resetn,Clock,Run,Done,BUS);	
	input [15:0] DIN;
	input Resetn,Clock,Run;
	output reg Done;
	output reg[15:0] BUS;
	//declare variables
	wire [15:0] R0in,R1in,R2in,R3in,R4in,R5in,R6in,R7in,Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Aout;
	wire [15:0] output_ans,G_16output;
   reg Ain_en,Gin_en,AddSub,DINout;
	reg IRen,Gout,IRin;
	reg [7:0] Rout,Rin_en;
	wire [1:9] IR;
	wire [1:3] I;
	wire [7:0] Xreg,Yreg;
	wire Clear=Done||~Resetn;
	wire[1:0] Tstep_Q;
	reg [9:0] MUXsel;
	
	regn R0(BUS,Rin_en[0],Clock,Q0);
	regn R1(BUS,Rin_en[1],Clock,Q1);
	regn R2(BUS,Rin_en[2],Clock,Q2);
	regn R3(BUS,Rin_en[3],Clock,Q3);
	regn R4(BUS,Rin_en[4],Clock,Q4);
	regn R5(BUS,Rin_en[5],Clock,Q5);
	regn R6(BUS,Rin_en[6],Clock,Q6);
	regn R7(BUS,Rin_en[7],Clock,Q7);
	regn IRreg (DIN,IRen,Clock,IR);
	regn A(BUS,Ain_en,Clock,Aout);
	regn G(output_ans,Gin_en,Clock,G_16output);
   defparam IRreg.n = 9;
	
	upcount Tstep(Clear,Clock,Tstep_Q);
	//Multiplexers multiplexer(Rout,Gout,DINout,DIN,G_16output,Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,BUS);
	
	Addsub addsub(AddSub,Aout,BUS,output_ans);
	
	assign I=IR[1:3];
	
	dec3to8 dexC(IR[4:6],1'b1,Xreg);
	dec3to8 decY(IR[7:9],1'b1,Yreg);
	
	always @(Tstep_Q or I or Xreg or Yreg)
	begin
	//initialize 
		IRen = 1'b0;
		Rout[7:0] = 8'b00000000;
		Rin_en[7:0] = 8'b00000000;
		DINout = 1'b0;
		Ain_en = 1'b0;
		Gout = 1'b0;
		Gin_en = 1'b0;
		AddSub = 1'b0;
		Done = 1'b0;
		
		case(Tstep_Q)//Time Step
		2'b00://Step 0
		begin
			IRen=1'b1;//store DIN in IR in time step 0
		end
		2'b01://Step 1
		begin
			case(I)
				3'b000:
				begin
					Rout=Yreg;
					Rin_en=Xreg;
					Done=1'b1;
				end
				3'b001:
				begin
					DINout=1'b1;
					Rin_en=Xreg;
					Done=1'b1;
				end
				3'b010:
				begin
					Rout=Xreg;
					Ain_en=1'b1;
				end
				3'b011:
				begin
					Rout=Xreg;
					Ain_en=1'b1;
				end
			endcase
		end
		2'b10://Step 2
		begin
			case(I)
			3'b010:
				begin
					Rout=Yreg;
					Gin_en=1'b1;
				end
			3'b011:
				begin
					Rout=Yreg;
					Gin_en=1'b1;
					AddSub=1'b1;
				end
			endcase
		end
		2'b11://Step3
		begin
			case(I)
			3'b010:
				begin
					Gout=1'b1;
					Rin_en=Xreg;
					Done=1'b1;
				end
			3'b011:
				begin
					Gout=1'b1;
					Rin_en=Xreg;
					Done=1'b1;
				end
			endcase
		end
		endcase	
	end
	
  always @ (MUXsel or Rout or Gout or DINout or DIN or G_16output)
  begin
    MUXsel[9:2] = Rout;
    MUXsel[1] = Gout;
    MUXsel[0] = DINout;
    
    case (MUXsel)
      10'b0000000001: BUS = DIN;
      10'b0000000010: BUS = G_16output;
      10'b0000000100: BUS = Q0;
      10'b0000001000: BUS = Q1;
      10'b0000010000: BUS = Q2;
      10'b0000100000: BUS = Q3;
      10'b0001000000: BUS = Q4;
      10'b0010000000: BUS = Q5;
      10'b0100000000: BUS = Q6;
      10'b1000000000: BUS = Q7;
    endcase
  end
 endmodule