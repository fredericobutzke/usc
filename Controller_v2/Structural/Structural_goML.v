//goML = ~sample & goML & rst | Err1 & ~Rreq | Err0 & ~Rreq | ~Err1 & ~Err0 & goML & rst ; 
//goML = ~a & goML & rst | b & ~c | d & ~c | ~b & ~d & goML & rst ; 


module HS65_GS_AO32X4 (Z, A, B, C, D, E);
	output Z;
	input A, B, C, D, E;
	and    U1 (INTERNAL1, A, B, C) ;
	and    U2 (INTERNAL2, D, E) ;
	or   #1 U3 (Z, INTERNAL1, INTERNAL2) ;
endmodule

module HS65_GS_AO22X4 (Z, A, B, C, D);
	output Z;
	input A, B, C, D;
	and    U1 (INTERNAL1, A, B) ;
	and    U2 (INTERNAL2, C, D) ;
	or   #1 U3 (Z, INTERNAL1, INTERNAL2) ;
endmodule

module HS65_GS_OA12X4 (Z, A, B, C);
	output Z;
	input A, B, C;
	or    U1 (INTERNAL1, A, B) ;
	and   #1 U2 (Z, INTERNAL1, C) ;
endmodule

module Structural_goML();

reg [3:0] truth_table ;
reg rst ;

initial begin

	$dumpfile("Structural_goML.vcd");
	$dumpvars(0, Structural_goML);	

	rst = 'b0;
	truth_table = 'b0;
	#10
	rst = 'b1;

	$display("Starting Simulation");
	$display("inputs	|| o1  | o2");
	repeat (15) begin
		#10
		$display("%b	|| %b   |  %b", {a, b, c, d }, goML_beh, goML_struct);
		truth_table = truth_table + 1;
	end

	repeat (16) begin
		#10
		$display("%b	|| %b   |  %b", {a, b, c, d }, goML_beh, goML_struct);
		truth_table = truth_table - 1;
	end
	$display("End of Simulation");
	$finish;
end

//Structural
HS65_GS_AO32X4 U1 (INTERNAL1, ~b, ~d, goML_struct, d, ~c);
HS65_GS_AO22X4 U2 (INTERNAL2, b, ~c, ~a, goML_struct);
HS65_GS_OA12X4 U3 (goML_struct, INTERNAL1, INTERNAL2, rst);

//Function
assign #1 goML_beh = ~a & goML_beh & rst | b & ~c | d & ~c | ~b & ~d & goML_beh & rst ;

//Truth Table
assign {a, b, c, d} = truth_table ;

endmodule