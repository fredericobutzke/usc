//Rreq = ~goLM & ~Rack | ~goLM & Rreq | ~Rack & Rreq & rst;
//Rreq = ~a & ~b | ~a & Rreq | ~b & Rreq & rst ;

module HS65_GS_AOI222X2 (Z, A, B, C, D, E, F);
	output Z;
	input A, B, C, D, E, F;
	and    U1 (INTERNAL2, A, B) ;
	and    U2 (INTERNAL3, C, D) ;
	and    U3 (INTERNAL4, E, F) ;
	or    U4 (INTERNAL1, INTERNAL2, INTERNAL3, INTERNAL4) ;
	not   #1 U5 (Z, INTERNAL1) ;
endmodule

module HS65_GS_NOR2AX3 (Z, A, B);
	output Z;
	input A, B;
	not    U1 (INTERNAL1, B) ;
	and   #1 U2 (Z, A, INTERNAL1) ;
endmodule

module Structural_Rreq();

reg rst ;
reg [1:0] truth_table ;

initial begin

	$dumpfile("Structural_Rreq.vcd");
	$dumpvars(0, Structural_Rreq);	
	rst = 'b0;
	truth_table = 'b0;
	#10
	rst = 'b1;

	$display("Inputs 	|| Beh | Struct");
	repeat (3) begin
		#5
		$display("%b 	||  %b | %b", {a,b}, Rreq_beh, Rreq_struct);
		truth_table = truth_table + 1;
	end

	repeat (4) begin
		#5
		$display("%b 	||  %b | %b", {a,b}, Rreq_beh, Rreq_struct);
		truth_table = truth_table - 1;
	end
	$finish;

end

//Structural
HS65_GS_AOI222X2 U1 (INTERNAL1, ~a, ~b, ~a, Rreq_struct, ~b, Rreq_struct);
HS65_GS_NOR2AX3 U2 (Rreq_struct, rst, INTERNAL1);

//Function
assign #1 Rreq_beh = ~a & ~b | ~a & Rreq_beh | ~b & Rreq_beh & rst ;

//Truth Table
assign {a,b} = truth_table ;

endmodule