//REack = b & Rreq | a & Rreq | REreq & ~sample & ~goML & rst | ~a & ~b & REack & rst; 
//REack = b & c | a & c | d & ~e & ~f & rst | ~a & ~b & REack & rst; 

module HS65_GS_AO33X4 (Z, A, B, C, D, E, F);
	output Z;
	input A, B, C, D, E, F;
	and    U1 (INTERNAL1, A, B, C) ;
	and    U2 (INTERNAL2, D, E, F) ;
	or   #1 U3 (Z, INTERNAL1, INTERNAL2) ;
endmodule

module HS65_GS_AOI212X2 (Z, A, B, C, D, E);
	output Z;
	input A, B, C, D, E;
	and    U1 (INTERNAL2, A, B) ;
	and    U2 (INTERNAL3, C, D) ;
	or    U3 (INTERNAL1, INTERNAL2, INTERNAL3, E) ;
	not   #1 U4 (Z, INTERNAL1) ;
endmodule

module HS65_GS_NOR2AX3 (Z, A, B);
	output Z;
	input A, B;
	not    U1 (INTERNAL1, B) ;
	and   #1 U2 (Z, A, INTERNAL1) ;
endmodule

module Structural_REack();

reg [5:0] truth_table ;
reg rst ;

initial begin

	$dumpfile("Structural_REack.vcd");
	$dumpvars(0, Structural_REack);	

	rst = 'b0;
	truth_table = 'b0;
	#10
	rst = 'b1;

	$display("inputs	|| o1  | o2");
	repeat (63) begin
		#10
		$display("%b	|| %b   |  %b", {a, b, c, d, e, f}, REack_beh, REack_struct);
		truth_table = truth_table + 1;
	end

	repeat (64) begin
		#10
		$display("%b	|| %b   |  %b", {a, b, c, d, e, f}, REack_beh, REack_struct);
		truth_table = truth_table - 1;
	end

	$finish;
end

//Structural
HS65_GS_AO33X4   U1 (INTERNAL1, ~a, ~b, REack_struct, d, ~e, ~f);
HS65_GS_AOI212X2 U2 (REack_struct_, b, c, a, c, INTERNAL1);
HS65_GS_NOR2AX3  U3 (REack_struct, rst, REack_struct_);

//Function
assign #1 REack_beh = b & c | a & c | d & ~e & ~f & rst | ~a & ~b & REack_beh & rst; 

//Truth Table
assign {a, b, c, d, e, f} = truth_table ;

endmodule