module controller(
	output Lack,
	output Rreq,
	output LEreq,
	output REack,
	output clk,
	output sample,
	input Lreq,
	input Rack,
	input LEack,
	input REreq,
	input Err1,
	input Err0,
	input rst
);

	//Delta delay
	wire a, b;						
	
	//Internal signals
	wire goML, goLM ;
	wire REack_ ;

	//Inverters
	not #1 (Rack_, Rack);
	not #1 (REreq_, REreq);
	not #1 (goLM_, goLM);
	not #1 (sample_, sample);
	not #1 (Err0_, Err0);
	not #1 (Err1_, Err1);
	not #1 (a_, a);
	not #1 (b_, b);

	assign Lack = goML ;
	assign LEreq = Lreq ;
	assign goLM = LEack ;

	assign #1 a = Err0 ;
	assign #15 b = Err1;

	//assign #1 Rreq = goLM & ~Rack | goLM & Rreq | ~Rack & Rreq & rst ;
	//Rreq
	HS65_GS_AOI222X13 U11 (INTERNAL2, Rreq, Rack_, Rreq, goLM, Rack_, goLM);
	HS65_GS_NOR2AX13 U12 (Rreq, rst, INTERNAL2);
	
	//assign #1 REack = goML & REack & rst | b & Rreq | a & Rreq | ~a & ~b & REack & rst ;
	//REack
	HS65_GS_AO222X18 U21 (INTERNAL21, goML, REack, b, Rreq, a, Rreq);
	HS65_GS_AOI13X10 U22 (REack_, a_, b_, REack, INTERNAL21);
	HS65_GS_NOR2AX13 U23 (REack, rst, REack_);

	//assign #1 clk = ~goLM & Rack & ~Err1 & ~Err0 & REack | goLM & ~Rack & ~Err1 & ~Err0 & ~REack ;
	//Clk
	HS65_GS_AOI33X14 U31 (INTERNAL31, goLM_, Rack, REack, goLM, Rack_, REack_);
	HS65_GS_AND3ABCX18 U32 (clk, Err0, Err1, INTERNAL31);

	//assign #1 sample = ~REreq & ~a & ~b & REack | REreq & ~a & ~b & ~REack ;
	//Sample
	HS65_GS_AOI22X1 U41 (INTERNAL41, REreq_, REack, REreq, REack_);
	HS65_GS_AND3ABCX18 U42 (sample, a, b, INTERNAL41);

	//assign #1 goML = ~sample & goML & rst | Err1 & Rreq | Err0 & Rreq | ~Err1 & ~Err0 & REack ;	
	//goML
	HS65_GS_AOI32X10 U51 (INTERNAL51, sample_, goML, rst, Err1, Rreq);
	HS65_GS_AOI32X10 U52 (INTERNAL52, Err1_, Err0_, REack, Err0, Rreq);
	HS65_GS_NAND2X11 U53 (goML, INTERNAL51, INTERNAL52);

	
endmodule