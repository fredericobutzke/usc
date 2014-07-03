//sample = REreq & goML | ~a & ~b & sample & rst | ~REreq & ~goML & ~Rreq & rst;
//sample = c & d | ~a & ~b & sample & rst | ~c & ~d & ~e & rst;


module HS65_GS_AOI33X2 (Z, A, B, C, D, E, F);
	output Z;
	input A, B, C, D, E, F;
	and    U1 (INTERNAL2, A, B, C) ;
	and    U2 (INTERNAL3, D, E, F) ;
	or    U3 (INTERNAL1, INTERNAL2, INTERNAL3) ;
	not   #1 U4 (Z, INTERNAL1) ;
endmodule

module HS65_GS_NAND2X2 (Z, A, B);
	output Z;
	input A, B;
	and    U1 (INTERNAL1, A, B) ;
	not   #1 U2 (Z, INTERNAL1) ;
endmodule

module HS65_GS_NAND3X2 (Z, A, B, C);
	output Z;
	input A, B, C;
	and    U1 (INTERNAL1, A, B, C) ;
	not   #1 U2 (Z, INTERNAL1) ;
endmodule

module Structural_sample();

reg [4:0] truth_table ;
reg rst ;

initial begin

	$dumpfile("Structural_sample.vcd");
	$dumpvars(0, Structural_sample);	

	rst = 'b0;
	truth_table = 'b0;
	#10
	rst = 'b1;

	$display("inputs	|| zb  | zs");
	repeat (31) begin
		#10
		$display("%b	|| %b   |  %b", {a, b, c, d, e}, sample_beh, sample_struct);
		truth_table = truth_table + 1;
	end
	repeat (32) begin
		#10
		$display("%b	|| %b   |  %b", {a, b, c, d, e}, sample_beh, sample_struct);
		truth_table = truth_table - 1;
	end
	$finish;
end

//Structural
HS65_GS_AOI33X2 U1 (INTERNAL1, ~a, ~b, sample_struct, ~c, ~d, ~e);
HS65_GS_NAND2X2 U2 (INTERNAL2, c, d);
HS65_GS_NOR2X2  U3 (sample_struct, INTERNAL1, INTERNAL2, rst);

//Function
assign #1 sample_beh = c & d | ~a & ~b & sample_beh & rst | ~c & ~d & ~e & rst;

//Truth Table
assign {a, b, c, d, e} = truth_table ;

endmodule