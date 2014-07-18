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

	assign LEreq = Lreq ;

	//assign #3 a = Err0 ;
	HS65_GS_BFX4 UB11 (INTERNALB11, Err0);
	HS65_GS_BFX4 UB12 (INTERNALB12, INTERNALB11);
	HS65_GS_BFX4 UB13 (a, INTERNALB12);

	//assign #15 b = Err1;	
	HS65_GS_BFX4 UB21 (INTERNALB21, Err1);
	HS65_GS_BFX4 UB22 (INTERNALB22, INTERNALB21);
	HS65_GS_BFX4 UB23 (INTERNALB23, INTERNALB22);
	HS65_GS_BFX4 UB24 (INTERNALB24, INTERNALB23);
	HS65_GS_BFX284 UB25 (b, INTERNALB24);

	//Inverters
	HS65_GS_IVX9 U01 (Rack_, Rack);
	HS65_GS_IVX9 U02 (REreq_, REreq);
	HS65_GS_IVX9 U03 (REack_, REack);
	HS65_GS_IVX9 U04 (Err0_, Err0);
	HS65_GS_IVX9 U05 (Err1_, Err1);
	
	HS65_GS_IVX9 U06 (sample_, sample);

	HS65_GS_IVX9 U07 (LEack_, LEack);
	HS65_GS_IVX9 U08 (a_, a);
	HS65_GS_IVX9 U09 (b_, b);
	
	//Rreq = LEack & ~Rack | LEack & Rreq | ~Rack & Rreq & rst ;
	HS65_GS_AOI222X2 U11 (INTERNAL11, LEack, Rack_, LEack, Rreq, Rack_, Rreq);
	HS65_GS_NOR2AX3  U12 (Rreq, rst, INTERNAL11);
	
	//assign #1 REack = Lack & REack & rst | b & Rreq | a & Rreq | ~a & ~b & REack & rst ;
	//assign #1 REack_ = ~REack;
	HS65_GS_AO222X4  U21 (INTERNAL21, Lack, backREack, b, Rreq, a, Rreq);
	HS65_GS_AND3X4   U22 (INTERNAL22, a_, b_, backREack);
	HS65_GS_OR2X4    U23 (REack, INTERNAL21, INTERNAL22);
	HS65_GS_AND2X4   U24 (backREack, rst, REack);

	//Lack = ~sample & Lack & rst | Err1 & Rreq | Err0 & Rreq | ~Err1 & ~Err0 & REack ;	
	HS65_GS_AOI32X10 U31 (INTERNAL31, Err1_, Err0_, REack, Err1, Rreq);
	HS65_GS_AOI32X10 U32 (INTERNAL32, sample_, Lack, rst, Err0, Rreq);
	HS65_GS_NAND2X2  U33 (Lack, INTERNAL31, INTERNAL32);

	//clk = ~LEack & Rack & ~Err1 & ~Err0 & REack | LEack & ~Rack & ~Err1 & ~Err0 & ~REack ;
	HS65_GS_AO33X4 U41 (INTERNAL41, LEack_, Rack, REack, LEack, Rack_, REack_);
	HS65_GS_NOR2X2 U42 (INTERNAL42, Err1, Err0);
	HS65_GS_AND2X4 U43 (clk, INTERNAL41, INTERNAL42);
	//HS65_GS_NOR3X2 U42 (clk, Err0, Err1, INTERNAL41);

	//sample = ~REreq & ~a & ~b & REack | REreq & ~a & ~b & ~REack ;
	HS65_GS_AO22X4 U51 (INTERNAL51, REreq_, REack, REreq, REack_);
	HS65_GS_NOR2X2 U52 (INTERNAL52, a, b);
	HS65_GS_AND2X4 U53 (sample, INTERNAL52, INTERNAL51);

endmodule