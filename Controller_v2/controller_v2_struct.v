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

	assign Lack = goML ;
	assign LEreq = Lreq ;

	assign #3 a = Err0 ;
	assign #15 b = Err1;

	//Inverters
	HS65_GS_IVX9 U1 (Rack_, Rack);
	HS65_GS_IVX9 U2 (REreq_, REreq);
	HS65_GS_IVX9 U3 (REack_, REack);
	HS65_GS_IVX9 U4 (Err0_, Err0);
	HS65_GS_IVX9 U5 (Err1_, Err1);
	
	HS65_GS_IVX9 U6 (sample_, sample);

	HS65_GS_IVX9 U7 (goLM_, goLM);
	HS65_GS_IVX9 U8 (a_, a);
	HS65_GS_IVX9 U9 (b_, b);
	
	//Rreq = goLM & ~Rack | goLM & Rreq | ~Rack & Rreq & rst ;
	HS65_GS_AOI222X2 U11 (INTERNAL11, goLM, Rack_, goLM, Rreq, Rack_, Rreq);
	HS65_GS_NOR2AX3  U12 (Rreq, rst, INTERNAL11);
	
	//assign #1 REack = goML & REack & rst | b & Rreq | a & Rreq | ~a & ~b & REack & rst ;
	//assign #1 REack_ = ~REack;
	HS65_GS_AO222X4  U21 (INTERNAL21, goML, backREack, b, Rreq, a, Rreq);
	HS65_GS_AND3X4   U22 (INTERNAL22, a_, b_, backREack);
	HS65_GS_OR2X4    U23 (REack, INTERNAL21, INTERNAL22);
	HS65_GS_AND2X4   U24 (backREack, rst, REack);

	//goML = ~sample & goML & rst | Err1 & Rreq | Err0 & Rreq | ~Err1 & ~Err0 & REack ;	
	HS65_GS_AOI32X10 U31 (INTERNAL31, Err1_, Err0_, REack, Err1, Rreq);
	HS65_GS_AOI32X10 U32 (INTERNAL32, sample_, goML, rst, Err0, Rreq);
	HS65_GS_NAND2X2  U33 (goML, INTERNAL31, INTERNAL32);

	//clk = ~goLM & Rack & ~Err1 & ~Err0 & REack | goLM & ~Rack & ~Err1 & ~Err0 & ~REack ;
	HS65_GS_AO33X4 U41 (INTERNAL41, goLM_, Rack, REack, goLM, Rack_, REack_);
	HS65_GS_NOR2X2 U42 (INTERNAL42, Err1, Err0);
	HS65_GS_AND2X4 U43 (clk, INTERNAL41, INTERNAL42);
	//HS65_GS_NOR3X2 U42 (clk, Err0, Err1, INTERNAL41);

	//sample = ~REreq & ~a & ~b & REack | REreq & ~a & ~b & ~REack ;
	HS65_GS_AO22X4 U51 (INTERNAL51, REreq_, REack, REreq, REack_);
	HS65_GS_NOR2X2 U52 (INTERNAL52, a, b);
	HS65_GS_AND2X4 U53 (sample, INTERNAL52, INTERNAL51);

	//goLM = LEack & rst;
    HS65_GS_AND2X4 U61 (goLM, LEack, rst);

endmodule