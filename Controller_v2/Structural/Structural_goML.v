//goML = ~sample & goML & rst | Err1 & Rreq | Err0 & Rreq | ~Err1 & ~Err0 & REack ;	
//zs = ~a & zs & rst | b & c | d & c | ~b & ~d & e ;	

module HS65_GS_OA12X18 (Z, A, B, C);
	output Z;
	input A, B, C;

	or    U1 (INTERNAL1, A, B) ;
	and   #1 U2 (Z, INTERNAL1, C) ;
endmodule

module HS65_GS_AO32X18 (Z, A, B, C, D, E);
	output Z;
	input A, B, C, D, E;

	and    U1 (INTERNAL1, A, B, C) ;
	and    U2 (INTERNAL2, D, E) ;
	or   #1 U3 (Z, INTERNAL1, INTERNAL2) ;
endmodule

module Structural_goML();

reg [5:0] truth_table ;
reg rst ;

wire zb, zs; 
wire b, c, d, e ;

initial begin

	//$dumpfile("Structural_Rreq.vcd");
	//$dumpvars(0, Structural_Rreq);	

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

not(a_, a);
not(b_, b);
not(d_, d);
HS65_GS_OA12X18 U1 (INTERNAL1, b, d, c);
HS65_GS_AO32X18 U2 (INTERNAL2, b_, d_, e, INTERNAL3, a_);
and(INTERNAL3, rst, zs);
or(zs, INTERNAL1, INTERNAL2);

//Function
assign #1 zb = ~a & zs & rst | b & c | d & c | ~b & ~d & e ;

//Truth Table
assign {a, b, c, d, e} = truth_table ;

endmodule