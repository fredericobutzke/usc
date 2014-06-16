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


	wire a, b, z0;						
	
	assign #1 Lack = rst & (Err1 & Rreq | Err0 & Rreq | Lack & ~sample | ~Err1 & ~Err0 & REack);
	assign #1 Rreq = ~Rack & LEack | LEack & Rreq | Err1 & Rreq | Err0 & Rreq | a & Rreq & rst | b & Rreq & rst | ~Rack & REack & z0 | LEack & ~Err1 & ~Err0 & ~a & ~b & ~z0;	
	assign #1 LEreq = Lreq & ~Rack | Lreq & LEreq | Err1 & LEreq & z0 | Err0 & LEreq & z0 | a & LEreq & z0 & rst | b & LEreq & z0 & rst | Lreq & a & ~z0 | Lreq & b & ~z0 | ~Rack & ~a & ~b & LEreq & ~z0 & rst | Lreq & ~Err1 & ~Err0 & ~a & ~b & z0;
	assign #1 REack = rst & (a & Rreq | b & Rreq | Lack & REack | ~a & ~b & REack);
	assign #1 clk = Rack & ~LEack & REreq | ~Rack & LEack & ~REreq | ~LEack & ~Err1 & ~Err0 & ~a & ~b & REack & ~z0 | LEack & ~Err1 & ~Err0 & ~a & ~b & ~REack & ~z0;
	assign #1 sample = Rack & ~REreq & Lack | ~Rack & REreq & ~Lack | ~a & ~b & sample & rst;
	assign #1 z0 = Err1 & z0 | Err0 & z0 | Lreq & a & Rreq | Lreq & b & Rreq | ~Lreq & a & ~Rreq & rst | ~Lreq & b & ~Rreq & rst | Lreq & Rack & z0 & rst | ~Lreq & ~Rack & z0 & rst | Rack & ~LEack & ~Err1 & ~Err0 & ~a & ~b & LEreq | ~Rack & LEack & ~Err1 & ~Err0 & ~a & ~b & ~LEreq;
	
	assign #1 a = Err0 ;
	assign #5 b = Err1;

	/*
		Ok z0 =
		  Err1 z0 +
		  Err0 z0 +
		  Lreq a Rreq +
		  Lreq b Rreq +
		  Lreq' a Rreq' +
		  Lreq' b Rreq' +
		  Lreq Rack z0 +
		  Lreq' Rack' z0 +
		  Rack LEack' Err1' Err0' a' b' LEreq +
		  Rack' LEack Err1' Err0' a' b' LEreq'

		Ok sample =
		  Rack REreq' Lack +
		  Rack' REreq Lack' +
		  a' b' sample 

		Ok clk =
		  Rack LEack' REreq +
		  Rack' LEack REreq' +
		  LEack' Err1' Err0' a' b' REack z0' +
		  LEack Err1' Err0' a' b' REack' z0' 

		Ok REack =
		  a Rreq +
		  b Rreq +
		  Lack REack +
		  a' b' REack 

		Ok LEreq =
		  Lreq Rack' +
		  Lreq LEreq +
		  Err1 LEreq z0 +
		  Err0 LEreq z0 +
		  a LEreq z0 +
		  b LEreq z0 +
		  Lreq a z0' +
		  Lreq b z0' +
		  Rack' a' b' LEreq z0' +
		  Lreq Err1' Err0' a' b' z0 

		Ok Lack =
		  Err1 Rreq +
		  Err0 Rreq +
		  Lack sample' +
		  Err1' Err0' REack 
		
		Ok Rreq =
		  Rack' LEack +
		  LEack Rreq +
		  Err1 Rreq +
		  Err0 Rreq +
		  a Rreq +
		  b Rreq +
		  Rack' REack z0 +
		  LEack Err1' Err0' a' b' z0' 
	*/

endmodule