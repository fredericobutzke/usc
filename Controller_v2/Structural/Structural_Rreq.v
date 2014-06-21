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

module Structural_Rreq();

wire zb, a2, zs, a5, a, e, f;
reg rst ;
reg [1:0] truth_table ;

initial begin

	$dumpfile("Structural_Rreq.vcd");
	$dumpvars(0, Structural_Rreq);	
	rst = 'b0;
	truth_table = 'b0;
	#10
	rst = 'b1;

	$display("Inputs 	|| zb | zs");
	repeat (3) begin
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
not(zs, INTERNAL2);
and(INTERNAL1, rst, zs);

//Function
assign #1 zb = e & ~f | e & zb | ~f & zb & rst ;

//Truth Table
assign {f, e} = truth_table ;

endmodule