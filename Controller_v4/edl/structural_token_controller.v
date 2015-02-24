module token_controller( Lack, Rreq, LEreq, REack, clk, sample, Lreq, Rack, LEack, REreq, Err1, Err0, rst);

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
wire delay, edi, edo, z0, z1, z2;

wire w11, w12, w13, w21, w32, w33, w41, w42, w43;
wire w51, w61, w62, w71, w101, w102, w103;
wire LEack_, Rack_, delay_, edi_, REreq_, goD_, REack_, Rreq_, Lack_, z0_;

assign LEreq = Lreq;

//inverters
C12T28SOI_LR_IV UI01 (.Y(LEack_), .A(LEack));
C12T28SOI_LR_IV UI02 (.Y(Rack_), .A(Rack));
C12T28SOI_LR_IV UI03 (.Y(delay_), .A(delay));
C12T28SOI_LR_IV UI04 (.Y(edi_), .A(edi));
C12T28SOI_LR_IV UI05 (.Y(REreq_), .A(REreq));

//REack
C12T28SOI_LR_AO222 U11 (.Y(w11), .A(REreq), .B(goD_), .C(edi), .D(Rreq), .E(REreq), .F(REack));
C12T28SOI_LR_NOR4AB U12 (.Y(w12), .A(REack), .B(1'b1), .C(edi), .D(Err0));
C12T28SOI_LR_AND3 U13 (.Y(w13), .A(REreq), .B(Err0), .C(Rreq));
C12T28SOI_LR_NOR3 U14 (.Y(REack_), .A(w11), .B(w12), .C(w13));
C12T28SOI_LR_NOR2A U15 (.Y(REack), .A(rst), .B(REack_));

//Rreq
C12T28SOI_LR_AOI222 U21 (.Y(Rreq_), .A(LEack_), .B(Rreq), .C(Rack_), .D(Rreq), .E(LEack_), .F(Rack_));
C12T28SOI_LR_NOR2A U22 (.Y(Rreq), .A(rst), .B(Rreq_));

//clk
C12T28SOI_LR_NOR3A U31 (.Y(clk), .A(goD), .B(delay), .C(sample));

//sample
C12T28SOI_LR_AO22 U41  (.Y(sample), .A(goD), .B(sample), .C(delay), .D(delay));

//Lack
C12T28SOI_LR_AOI222 U51 (.Y(Lack_), .A(delay_), .B(Lack), .C(Lack), .D(z0_), .E(delay), .F(z0_));
C12T28SOI_LR_NOR2A  U52 (.Y(Lack), .A(rst), .B(Lack_));

//goD
C12T28SOI_LR_AND3 U61 (.Y(w41), .A(LEack), .B(Rack), .C(REreq));
C12T28SOI_LR_NOR4AB U62 (.Y(w42), .A(goD), .B(rst), .C(Err0), .D(edi));
C12T28SOI_LR_AND4 U63 (.Y(w43), .A(LEack_), .B(Rack_), .C(REreq_), .D(z2));
C12T28SOI_LR_NOR3 U64 (.Y(goD_), .A(w41), .B(w42), .C(w43));
C12T28SOI_LR_IV U65 (.Y(goD), .A(goD_));

//edo
C12T28SOI_LR_XNOR2 U71 (.Y(w51), .A(REreq), .B(REack));
C12T28SOI_LR_NOR3A U72 (.Y(edo), .A(Err1), .B(edi), .C(w51));

//z0
C12T28SOI_LR_NOR4AB U81 (.Y(w61), .A(goD), .B(Lack), .C(delay), .D(sample));
C12T28SOI_LR_AOI22 U82  (.Y(w62), .A(goD), .B(z0), .C(delay), .D(z0));
C12T28SOI_LR_NOR2A U83 (.Y(z0_), .A(w62), .B(w61));
C12T28SOI_LR_IV U84 (.Y(z0), .A(z0_));

//z2
C12T28SOI_LR_NOR4AB  U101 (.Y(w101), .A(rst), .B(z2), .C(REreq), .D(1'b0));
C12T28SOI_LR_NOR4AB U102 (.Y(w102), .A(rst), .B(z2), .C(Err1), .D(Err0));
C12T28SOI_LR_NOR4AB U103 (.Y(w103), .A(Rack), .B(REack_), .C(Err1), .D(Err0));
C12T28SOI_LR_OR4 U104 (.Y(z2), .A(w101), .B(w102), .C(w103), .D(1'b0));

// Delay lines
assign #DELAY_E edi = edo;
assign #DELAY_B delay = clk;

endmodule