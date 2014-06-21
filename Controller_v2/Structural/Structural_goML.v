//goML = ~sample & goML & rst | Err1 & Rreq | Err0 & Rreq | ~Err1 & ~Err0 & REack ;	
//zs = 			~a & zs & rst | 	  b & c | 		d & c | ~b & ~d & e ;	

module HS65_GS_AOI32X10 (Z, A, B, C, D, E);
	output Z;
	input A, B, C, D, E;

	and    U1 (INTERNAL2, A, B, C) ;
	and    U2 (INTERNAL3, D, E) ;
	or    U3 (INTERNAL1, INTERNAL2, INTERNAL3) ;
	not   #1 U4 (Z, INTERNAL1) ;
endmodule

module Structural_goML();

reg [5:0] truth_table ;
reg rst ;

wire zb, zs; 
wire b, c, d, e ;

initial begin

	$dumpfile("Structural_goML.vcd");
	$dumpvars(0, Structural_goML);	

	rst = 'b0;
	truth_table = 'b0;
	#10
	rst = 'b1;

	$display("Starting Simulation");
	$display("inputs	|| o1  | o2");
	repeat (31) begin
		#10
		$display("%b	|| %b   |  %b", {a, b, c, d, e}, zb, zs);
		truth_table = truth_table + 1;
	end

	repeat (32) begin
		#10
		$display("%b	|| %b   |  %b", {a, b, c, d, e}, zb, zs);
		truth_table = truth_table - 1;
	end
	$display("End of Simulation");
	$finish;
end

//Structural
wire a_, b_, d_;

not (a_, a);
not (b_, b);
not (d_, d);
HS65_GS_AOI32X10 U0 (INTERNAL1, a_, zs, rst, b, c);
HS65_GS_AOI32X10 U1 (INTERNAL2, b_, d_, e, d, c);
nand #1 (zs, INTERNAL1, INTERNAL2);

//Function
assign #1 zb = ~a & zb & rst | b & c | d & c | ~b & ~d & e ;

//Truth Table
assign {a, b, c, d, e} = truth_table ;

endmodule