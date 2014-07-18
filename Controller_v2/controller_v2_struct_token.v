module controller_token(
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
	HS65_GS_IVX9 U03 (Err0_, Err0);
	HS65_GS_IVX9 U04 (Err1_, Err1);
	
	HS65_GS_IVX9 U05 (sample_, sample);
	HS65_GS_IVX9 U06 (Lack_, Lack);

	HS65_GS_IVX9 U07 (LEack_, LEack);
	HS65_GS_IVX9 U08 (a_, a);
	HS65_GS_IVX9 U09 (b_, b);

 	//Rreq = ~LEack & ~Rack | ~LEack & Rreq | ~Rack & Rreq & rst;
	HS65_GS_AOI222X2 U11 (Rreq_, LEack_, Rack_, LEack_, Rreq, Rack_, Rreq);
	HS65_GS_NOR2AX3  U12 (Rreq, rst, Rreq_);

    //REack = b & Rreq | a & Rreq | REreq & ~sample & ~Lack & rst | ~a & ~b & REack & rst; 
	HS65_GS_AO33X4   U21 (INTERNAL21, a_, b_, REack, REreq, sample_, Lack_);
	HS65_GS_AOI212X2 U22 (REack_, b, Rreq, a, Rreq, INTERNAL21);
	HS65_GS_NOR2AX3  U23 (REack, rst, REack_);

    //Lack = ~sample & Lack & rst | Err1 & ~Rreq | Err0 & ~Rreq | ~Err1 & ~Err0 & Lack & rst ; 
	HS65_GS_AO32X4 U31 (INTERNAL31, Err1_, Err0_, Lack, Err0, Rreq_);
	HS65_GS_AO22X4 U32 (INTERNAL32, Err1, Rreq_, sample_, Lack);
	HS65_GS_OA12X4 U33 (Lack, INTERNAL31, INTERNAL32, rst);

	//HS65_GS_AND3ABCX9 must be 3 times slower.. Delay of #3.
    //clk = ~LEack & ~Rack & ~Err1 & ~Err0 & Lack | LEack & Rack & ~Err1 & ~Err0 & REack ;
	HS65_GS_AOI33X2   U41 (INTERNAL41, LEack_, Rack_, Lack, LEack, Rack, REack);
	HS65_GS_AND3ABCX9 U42 (clk, Err0, Err1, INTERNAL41);

    //assign #2 sample = REreq & Lack | ~a & ~b & sample & rst | ~REreq & ~Lack & ~Rreq & rst;
	HS65_GS_AOI33X2 U51 (INTERNAL51, a_, b_, sample, REreq_, Lack_, Rreq_);
	HS65_GS_NAND2X4 U52 (INTERNAL52, REreq, Lack);
	HS65_GS_NAND2X4	U53 (INTERNAL53, INTERNAL51, INTERNAL52);
    HS65_GS_AND2X4  U54 (sample, INTERNAL53, rst);
 
endmodule