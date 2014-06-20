//	REack = goML & REack & rst 	| b & Rreq 	| a & Rreq 	| ~a & ~b & REack & rst ;
//		a = 	b & a & rst 	| 	c & d 	| 	e & d 	| 	~e & ~c & a & rst ;

module HS65_GS_AO13 (Z, A, B, C, D);
	output Z;
	input A, B, C, D;

	and    	 U1 (INTERNAL2, A, B, C) ;
	or   #1	 U2 (Z, INTERNAL2, D) ;
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

	//$dumpfile("Structural_Rreq.vcd");
	//$dumpvars(0, Structural_Rreq);	

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
HS65_GS_AO13 U0 (zs, e_, c_, INTERNAL3, INTERNAL1);
HS65_GS_AO222 U1 (INTERNAL1, e, d, c, d, b, zs);
not(e_, e);
not(c_, c);
and(INTERNAL3, rst, zs);

//Function
assign #1 zb = b & zb | c & d | e & d | ~e & ~c & zb & rst ;

//Truth Table
assign {b, c, d, e} = truth_table ;

endmodule