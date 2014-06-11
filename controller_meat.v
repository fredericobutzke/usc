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

//Y0 = RACK~*ERR0 + RACK~*ERR1 + Y0*RACK~*REREQ
assign #1 y0 = ~Rack & Err0 | ~Rack & Err1 | y0 & ~Rack & REreq;

//LACK = LEACK
assign #1 Lack = LEack;

//RREQ = LEACK
assign #1 Rreq = LEack;

//LEREQ = LREQ
assign #1 LEreq = Lreq;

//REACK = RACK + Y0*REREQ
assign #1 REack = Rack | y0 & REreq;

//CLK = LEACK*REREQ~
assign #1 clk = LEack & ~REreq;

//SAMPLE = Y0~*RACK~*REREQ
assign #1 sample = ~y0 * ~Rack * REreq;

endmodule