module controller( Lack, Rreq, LEreq, REack, clk, sample, Lreq, Rack, LEack, REreq, Err1, Err0, rst);

parameter DELAY_B = 5;
parameter DELAY_E = 5;

output Lack;
output Rreq;
output LEreq;
output REack;
output clk;
output sample;
input Lreq;
input Rack;
input LEack;
input REreq;
input Err1;
input Err0;
input rst;

wire Lack, Rreq, LEreq, REack, clk, sample, Lreq, Rack, LEack, REreq, Err1, Err0, rst;
wire delay, edi, edo, z0, z1;

wire w11, w12, w31, w32, w33, w41, w42, w43, w51, w71, w81;
wire delay_, edi_, goD_, REack_, Rreq_, Lack_, z0_;

assign LEreq = Lreq ;

//inverters
C12T28SOI_LR_IV UI01 (.Y(delay_), .A(delay));
C12T28SOI_LR_IV UI03 (.Y(Rack_), .A(Rack));
C12T28SOI_LR_IV UI04 (.Y(edi_), .A(edi));

//Lack
C12T28SOI_LR_AOI222 U11 (.Y(Lack_), .A(delay_), .B(Lack), .C(Lack), .D(z0_), .E(delay), .F(z0_));
C12T28SOI_LR_NOR2A  U12 (.Y(Lack), .A(rst), .B(Lack_));

//Rreq
C12T28SOI_LR_OA112 U21 (.Y(w21), .A(LEack), .B(Rack_), .C(Rreq), .D(rst));
C12T28SOI_LR_AO12 U22 (.Y(Rreq), .A(LEack), .B(Rack_), .C(w21));

//REack
C12T28SOI_LR_NOR4AB U31 (.Y(w31), .A(REack), .B(rst), .C(edi), .D(Err0));
C12T28SOI_LR_AO22 U32 (.Y(w32), .A(edi), .B(Rreq), .C(REack), .D(REreq));
C12T28SOI_LR_AND3 U33 (.Y(w33), .A(REreq), .B(Err0), .C(Rreq));
C12T28SOI_LR_NOR4 U34 (.Y(REack_), .A(w32), .B(w33), .C(w31), .D(1'b0));
C12T28SOI_LR_IV U35 (.Y(REack), .A(REack_));

//goD
C12T28SOI_LR_NOR4AB U41 (.Y(w41), .A(Rack), .B(REreq), .C(LEack), .D(1'b0));
C12T28SOI_LR_NOR4AB U42 (.Y(w42), .A(LEack), .B(1'b1), .C(Rack), .D(REreq));
C12T28SOI_LR_NOR4AB U43 (.Y(w43), .A(goD), .B(rst), .C(edi), .D(Err0));
C12T28SOI_LR_OR4 U44(.Y(goD), .A(w41), .B(w42), .C(w43), .D(1'b0));

//edo
C12T28SOI_LR_XOR2 U51 (.Y(w51), .A(REreq), .B(REack));
C12T28SOI_LR_AND3 U52 (.Y(edo), .A(Err1), .B(edi_), .C(w51));

//clk
C12T28SOI_LR_NOR3A U61 (.Y(clk), .A(goD), .B(delay), .C(sample));

//sample
C12T28SOI_LR_AO22 U71  (.Y(sample), .A(goD), .B(sample), .C(delay), .D(delay));

//z0
C12T28SOI_LR_NOR4AB U81 (.Y(w61), .A(goD), .B(Lack), .C(delay), .D(sample));
C12T28SOI_LR_AOI22 U82  (.Y(w62), .A(goD), .B(z0), .C(delay), .D(z0));
C12T28SOI_LR_NOR2A U83 (.Y(z0_), .A(w62), .B(w61));
C12T28SOI_LR_IV U84 (.Y(z0), .A(z0_));

// Delay lines
assign #DELAY_E edi = edo;
assign #DELAY_B delay = clk;

endmodule