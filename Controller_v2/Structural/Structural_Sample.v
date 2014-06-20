//sample = ~REreq & ~a & ~b & REack | REreq & ~a & ~b & ~REack ;
//sample = ~c & ~a & ~b & d | c & ~a & ~b & ~d ;

module HS65_GS_AOI22X1 (Z, A, B, C, D);
	output Z;
	input A, B, C, D;

	and    U1 (INTERNAL2, A, B) ;
	and    U2 (INTERNAL3, C, D) ;
	or    U3 (INTERNAL1, INTERNAL2, INTERNAL3) ;
	not   #1 U4 (Z, INTERNAL1) ;
endmodule


module HS65_GS_AND3ABCX18 (Z, A, B, C);
	output Z;
	input A, B, C;

	or    U1 (INTERNAL1, A, B, C) ;
	not   #1 U2 (Z, INTERNAL1) ;
endmodule

module Structural_sample();

reg [3:0] truth_table ;
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
	repeat (16) begin
		#10
		$display("%b	|| %b   |  %b", {a, b, c, d}, zb, zs);
		truth_table = truth_table + 1;
	end
	$finish;
end

//Structural
wire d_, c_;
HS65_GS_AOI22X1 U0 (INTERNAL1, c_, d, c, d_);
HS65_GS_AND3ABCX18 U1 (zs, a, b, INTERNAL1);
not(d_, d);
not(c_, c);

//Function
assign #1 zb = ~c & ~a & ~b & d | c & ~a & ~b & ~d ;

//Truth Table
assign {a, b, c, d} = truth_table ;

endmodule