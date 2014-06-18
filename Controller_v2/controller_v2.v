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
	
	//internal signals
	wire goLR, goME, goML, goEM, goLM, done ;

	assign #1 Lack = goML ;
	assign #1 Rreq = goLR ; 
	assign #1 LEreq = Lreq ;
	assign #1 REack = goME ;
	assign #1 clk = ~goLM & ~done & ~Err1 & ~Err0 & goME | goLM & done & ~Err1 & ~Err0 & ~goME ;
	assign #1 sample = ~goEM & ~a & ~b & goME | goEM & ~a & ~b & ~goME ;

	assign #1 goEM = REreq ;
	assign #1 done = ~Rack ;
	assign #1 goLR = LEack ;
	assign #1 goLM = LEack ;
	assign #1 goML = goEM & Err1 | goEM & Err0 | ~sample & goML & rst | ~Err1 & ~Err0 & goME ;	
	assign #1 goME = a & goML | b & goML | goML & goME & rst | ~a & ~b & goME & rst ;

	assign #1 a = Err0 ;
	assign #5 b = Err1;

	
endmodule