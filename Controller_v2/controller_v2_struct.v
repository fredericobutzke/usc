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

	//Inverters
	not #1 (rack_, Rack);
	not #1 (rereq_, REreq);
	not #1 (reack_, REack);
	not #1 (golm_, goLM);
	not #1 (sample_, sample);
	not #1 (err0_, Err0);
	not #1 (err1_, Err1);
	not #1 (a_, a);
	not #1 (b_, b);

	assign #1 Lack = goML ;
	assign #1 LEreq = Lreq ;
	assign #1 goLM = LEack ;

	assign #5 a = Err0 ;
	assign #15 b = Err1;

	//assign #1 Rreq = goLM & ~Rack | goLM & Rreq | ~Rack & Rreq & rst ;
	//Rreq
	HS65_GS_AOI222X13 #1 U11 (INTERNAL2, INTERNAL1, rack_, INTERNAL1, goLM, rack_, goLM);
	and #1 (INTERNAL1, rst, Rreq);
	not #1 (Rreq, INTERNAL2);
	
	//assign #1 REack = goML & REack & rst | b & Rreq | a & Rreq | ~a & ~b & REack & rst ;
	//REack
	HS65_GS_AO222X18 U21 (INTERNAL21, goML, INTERNAL22, b, Rreq, a, Rreq);
	HS65_GS_AOI13X10 U22 (INTERNAL23, a_, b_, INTERNAL22, INTERNAL21);
	not #1 (REack, INTERNAL23);
	and #1 (INTERNAL22, rst, REack);
	
	//assign #1 clk = ~goLM & Rack & ~Err1 & ~Err0 & REack | goLM & ~Rack & ~Err1 & ~Err0 & ~REack ;
	//Clk
	HS65_GS_AOI33X14 #1 U31 (INTERNAL31, golm_, Rack, REack, goLM, rack_, reack_);
	HS65_GS_AND3ABCX18 #1 U32 (clk, Err0, Err1, INTERNAL31);

	//assign #1 sample = ~REreq & ~a & ~b & REack | REreq & ~a & ~b & ~REack ;
	//Sample
	HS65_GS_AOI22X1 #1 U41 (INTERNAL41, rereq_, REack, REreq, reack_);
	HS65_GS_AND3ABCX18 #1 U42 (sample, a, b, INTERNAL41);

	//assign #1 goML = ~sample & goML & rst | Err1 & Rreq | Err0 & Rreq | ~Err1 & ~Err0 & REack ;	
	//goML
	HS65_GS_AOI32X10 U51 (INTERNAL51, sample_, goML, rst, Err1, Rreq);
	HS65_GS_AOI32X10 U52 (INTERNAL52, err1_, err0_, REack, Err0, Rreq);
	nand #1 (goML, INTERNAL51, INTERNAL52);

	
endmodule