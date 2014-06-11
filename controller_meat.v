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
	input Err0
);

wire y0 ;

assign #1 y0 = LEack & ~REreq | y0 & LEack & ~Err1 & ~Err0;
assign #1 Lack = LEack;
assign #1 Rreq = LEack;
assign #1 LEreq = Lreq;
assign #1 REack = ~y0 & REreq;
assign #1 clk = LEack & ~REreq;
assign #1 sample = y0 & REreq;

endmodule