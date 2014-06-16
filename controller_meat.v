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


	wire a, b;						
	
	assign #1 Lack = Rack;
	assign #1 Rreq = LEack;
	assign #1 LEreq = Lreq;
	assign #1 REack = rst & (a&LEreq|b&LEreq|REreq&REack|~a&~b&REack);
	assign #1 clk = ~LEack&~Err1&~Err0&REack|LEack&~Err1&~Err0&~REack;
	assign #1 sample = ~REreq&~a&~b&REack|REreq&~a&~b&~REack;
	
	assign #1 a = Err0 ;
	assign #5 b = Err1 ;

endmodule