//	REack = goML & REack & rst 	| b & Rreq 	| a & Rreq 	| ~a & ~b & REack & rst ;
//		a = 	b & a & rst 	| 	c & d 	| 	e & d 	| 	~e & ~c & a & rst ;

module HS65_GS_AOI13X10 (Z, A, B, C, D);
	output Z;
	input A, B, C, D;

	and    U1 (INTERNAL2, A, B, C) ;
	or    U2 (INTERNAL1, INTERNAL2, D) ;
	not   #1 U3 (Z, INTERNAL1) ;
endmodule

module HS65_GS_AO222 (Z, A, B, C, D, E, F);
	output Z;
	input A, B, C, D, E, F;

	and    U1 (INTERNAL2, A, B) ;
	and    U2 (INTERNAL3, C, D) ;
	and    U3 (INTERNAL4, E, F) ;
	or  #1 U4 (Z, INTERNAL2, INTERNAL3, INTERNAL4) ;
endmodule

module Structural_REack();

reg [3:0] truth_table ;
reg rst ;

wire zb, zs; 
wire b, c, d, e ;

initial begin

	$dumpfile("Structural_REack.vcd");
	$dumpvars(0, Structural_REack);	

	rst = 'b0;
	truth_table = 'b0;
	#10
	rst = 'b1;

	$display("inputs	|| o1  | o2");
	repeat (15) begin
		#10
		$display("%b	|| %b   |  %b", {b, c, d, e}, zb, zs);
		truth_table = truth_table + 1;
	end

	repeat (16) begin
		#10
		$display("%b	|| %b   |  %b", {b, c, d, e}, zb, zs);
		truth_table = truth_table - 1;
	end

	$finish;
end

//Structural
wire e_, c_;
wire zs_;

not #1 (e_, e);
not #1 (c_, c);
HS65_GS_AO222 U1 (INTERNAL1, b, INTERNAL2, c, d, e, d);
HS65_GS_AOI13X10 U0 (zs_, e_, c_, INTERNAL2, INTERNAL1);
nor #1 (INTERNAL2, ~rst, zs_);
not #1 (zs, zs_);

//Function
assign #1 zb = b & zb | c & d | e & d | ~e & ~c & zb & rst ;

//Truth Table
assign {b, c, d, e} = truth_table ;

endmodule