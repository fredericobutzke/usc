//Rreq
//Rreq = goLM & ~Rack | goLM & Rreq | ~Rack & Rreq & rst ;

module HS65_GS_AOI222X13 (Z, A, B, C, D, E, F);
	output Z;
	input A, B, C, D, E, F;

	and    U1 (INTERNAL2, A, B) ;
	and    U2 (INTERNAL3, C, D) ;
	and    U3 (INTERNAL4, E, F) ;
	or    U4 (INTERNAL1, INTERNAL2, INTERNAL3, INTERNAL4) ;
	not   #1 U5 (Z, INTERNAL1) ;
endmodule

module HS65_GS_NAND2AX14 (Z, A, B);
	output Z;
	input A, B;

	not    U1 (INTERNAL1, B) ;
	or   #1 U2 (Z, A, INTERNAL1) ;
endmodule

module Structural_Rreq();

wire zb, a2, zs, a5, a, e, f;
reg rst ;
reg [1:0] truth_table ;

initial begin

	//$dumpfile("Structural_Rreq.vcd");
	//$dumpvars(0, Structural_Rreq);	
	rst = 'b0;
	truth_table = 'b1;
	#10
	rst = 'b1;

	$display("Inputs 	|| zb | zs");
	repeat (2) begin
		#5
		$display("%b 	||  %b | %b", {f, e}, zb, zs);
		truth_table = truth_table + 1;
	end

	repeat (4) begin
		#5
		$display("%b 	||  %b | %b", {f, e}, zb, zs);
		truth_table = truth_table - 1;
	end
	$finish;

end

//Structural
wire f_;
not(f_, f);
HS65_GS_AOI222X13 U0 (INTERNAL2, INTERNAL1, f_, INTERNAL1, e, f_, e);
nand(INTERNAL1, rst, INTERNAL2);
not(zs, INTERNAL2);

//Function
assign #1 zb = e & ~f | e & zb | ~f & zb & rst ;

//Truth Table
assign {f, e} = truth_table ;

endmodule