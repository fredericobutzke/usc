// clk = ~goLM & ~Rack & ~Err1 & ~Err0 & goML | goLM & Rack & ~Err1 & ~Err0 & REack ;
// clk = ~a & ~b & ~c & ~d & e | a & b & ~c & ~d & f ;

module HS65_GS_AOI33 (Z, A, B, C, D, E, F);
	output Z;
	input A, B, C, D, E, F;

	and    U1 (INTERNAL2, A, B, C) ;
	and    U2 (INTERNAL3, D, E, F) ;
	or    U3 (INTERNAL1, INTERNAL2, INTERNAL3) ;
	not   #1 U4 (Z, INTERNAL1) ;
endmodule

module HS65_GS_AND3ABC (Z, A, B, C);
	output Z;
	input A, B, C;

	or    U1 (INTERNAL1, A, B, C) ;
	not   #1 U2 (Z, INTERNAL1) ;
endmodule

module Structural_clk();

reg [5:0] truth_table ;
reg rst ;

initial begin

	$dumpfile("Structural_clk.vcd");
	$dumpvars(0, Structural_clk);	

	rst = 'b0;
	truth_table = 'b0;
	#10
	rst = 'b1;

	$display("inputs	|| Beh  | Struct");
	repeat (64) begin
		#10
		$display("%b	|| %b   |  %b", {a, b, c, d, e, f}, clk_beh, clk_struct);
		truth_table = truth_table + 1;
	end
	$finish;
end

//Structural
HS65_GS_AOI33X2	U11 (INTERNAL1, ~a, ~b, e, a, b, f);
HS65_GS_AND3ABCX9 U12 (clk_struct, c, d, INTERNAL1);

//Function
assign #1 clk_beh = ~a & ~b & ~c & ~d & e | a & b & ~c & ~d & f ;

//Truth Table
assign {a, b, c, d, e, f} = truth_table ;

endmodule