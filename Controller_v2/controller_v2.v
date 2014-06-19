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
	wire goLR, goME, goML, goEM, goLM ;

	assign #1 Lack = goML ;
	assign #1 Rreq = goLM & ~Rack | goLM & Rreq | ~Rack & Rreq & rst ;
	assign #1 LEreq = Lreq ;
	assign #1 REack = goME ;
	assign #1 clk = ~goLM & Rack & ~Err1 & ~Err0 & goME | goLM & ~Rack & ~Err1 & ~Err0 & ~goME ;
	assign #1 sample = ~goEM & ~a & ~b & goME | goEM & ~a & ~b & ~goME ;

	assign #1 goEM = REreq ;
	assign #1 goLR = LEack ;
	assign #1 goLM = LEack ;
	assign #1 goML = ~sample & goML & rst | Err1 & Rreq | Err0 & Rreq | ~Err1 & ~Err0 & goME ;	
	assign #1 goME = goML & goME & rst | b & Rreq | a & Rreq | ~a & ~b & goME & rst ;

	assign #1 a = Err0 ;
	assign #15 b = Err1;

	
endmodule