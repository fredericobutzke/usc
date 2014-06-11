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

wire z0 ;

assign #1 Lack = LEack ;
assign #1 Rreq = LEack ;
assign #1 LEreq = Lreq ;
assign #1 REack = Err1&LEreq | Err0&LEreq | REreq&REack | ~Err1&~Err0&REack&rst ;
assign #1 clk = ~LEack&REreq | LEack&~REreq ;
assign #1 sample = rst&~REreq&~Err1&~Err0&REack | REreq&~Err1&~Err0&~REack ;

endmodule