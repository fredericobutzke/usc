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
	wire goML, goLM ;

	assign #1 Lack = goML ;
	assign #1 Rreq = goLM & ~Rack | goLM & Rreq | ~Rack & Rreq & rst ;
	assign #1 LEreq = Lreq ;
	assign #1 REack = goML & REack & rst | b & Rreq | a & Rreq | ~a & ~b & REack & rst ;
	assign #1 clk = ~goLM & Rack & ~Err1 & ~Err0 & REack | goLM & ~Rack & ~Err1 & ~Err0 & ~REack ;
	assign #1 sample = ~REreq & ~a & ~b & REack | REreq & ~a & ~b & ~REack ;

	assign #1 goLM = LEack ;
	assign #1 goML = ~sample & goML & rst | Err1 & Rreq | Err0 & Rreq | ~Err1 & ~Err0 & REack ;	

	assign #5 a = Err0 ;
	assign #15 b = Err1;

	
endmodule