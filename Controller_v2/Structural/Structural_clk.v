// clk = ~goLM & Rack & ~Err1 & ~Err0 & REack | goLM & ~Rack & ~Err1 & ~Err0 & ~REack ;
// clk = 			~a & b & ~c & ~d & e 	  | 		a & ~b & ~c & ~d & ~e ;

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

reg [4:0] truth_table ;
reg rst ;

wire zb, zs; 
wire a, b, c, d, e ;

initial begin

	//$dumpfile("Structural_Rreq.vcd");
	//$dumpvars(0, Structural_Rreq);	

	rst = 'b0;
	truth_table = 'b0;
	#10
	rst = 'b1;

	$display("inputs	|| zb  | zs");
	repeat (32) begin
		#10
		$display("%b	|| %b   |  %b", {a, b, c, d, e}, zb, zs);
		truth_table = truth_table + 1;
	end
	$finish;
end

//Structural
wire a_, b_, e_;
not(a_, a);
not(b_, b);
not(e_, e);
HS65_GS_AOI33 U0 (INTERNAL1, a_, b, e, a, b_, e_);
HS65_GS_AND3ABC U1 (zs, c, d, INTERNAL1);

//Function
assign #1 zb = ~a & b & ~c & ~d & e | a & ~b & ~c & ~d & ~e ;

//Truth Table
assign {a, b, c, d, e} = truth_table ;

endmodule