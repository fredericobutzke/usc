module C12T28SOI_LR_XOR3 (input A, input B, input C, output Y);
	xor #1 U1 (Y, A, B, C);
endmodule

module C12T28SOI_LR_XOR2 (input A, input B, output Y);
	xor #1 U1 (Y, A, B);
endmodule

module C12T28SOI_LR_XNOR3 (input A, input B, input C, output Y);
	xnor #1 U1 (Y, A, B, C);
endmodule

module C12T28SOI_LR_XNOR2 (input A, input B, output Y);
	xnor #1 U1 (Y, A, B);
endmodule

module C12T28SOI_LR_AND2 (input A, input B, output Y);
	and #1 U1 (Y, A, B);
endmodule

module C12T28SOI_LR_AND3 (input A, input B, input C, output Y);
	and #1 U1 (Y, A, B, C);
endmodule

module C12T28SOI_LR_AND4 (input A, input B, input C, input D, output Y);
	and #1 U1 (Y, A, B, C, D);
endmodule

module C12T28SOI_LR_AO112 (input A, input B, input C, input D, output Y);
	and U1 (w1, A, B);
	or #1 U3 (Y, w1, C, D);
endmodule

module C12T28SOI_LR_AO12 (input A, input B, input C, output Y);
	and U1 (w1, A, B);
	or #1 U2 (Y, w1, C);
endmodule

module C12T28SOI_LR_AO212 (input A, input B, input C, input D, input E, output Y);
	and U1 (w1, A, B);
	and U3 (w2, C, D);
	or #1 U2 (Y, w1, w2, E);
endmodule

module C12T28SOI_LR_AO222 (input A, input B, input C, input D, input E, input F, output Y);
	and U1 (w1, A, B);
	and U3 (w2, C, D);
	and U4 (w3, E, F);
	or #1 U2 (Y, w1, w2, w3);
endmodule

module C12T28SOI_LR_AO22 (input A, input B, input C, input D, output Y);
	and U1 (w1, A, B);
	and U2 (w2, C, D);
	or #1 U3 (Y, w1, w2);
endmodule

module C12T28SOI_LR_AOI112 (input A, input B,input C,input D,output Y);
	and U2 (w1, A, B);
	nor #1 U3 (Y, w1, C, D);
endmodule

module C12T28SOI_LR_AOI12 (input A, input B, input C, output Y);
	and U2 (w1, A, B);
	nor #1 U3 (Y, w1, C);
endmodule

module C12T28SOI_LR_AOI13 (input A, input B, input C, input D, output Y);
	and U2 (w1, A, B, C);
	nor #1 U3 (Y, w1, D);
endmodule

module C12T28SOI_LR_AOI211 (input A, input B, input C, input D, output Y);
	and U2 (w1, A, B);
	nor #1 U3 (Y, w1, C, D);
endmodule

module C12T28SOI_LR_AOI21(input A, input B, input C, output Y);
	and U1 (w1, A, B);
	nor #1 U2 (Y, w1, C);
endmodule

module C12T28SOI_LR_AOI222 (input A, input B, input C, input D, input E, input F, output Y);
	and U1 (w1, A, B);
	and U2 (w2, C, D);
	and U4 (w3, E, F);
	nor #1 U3 (Y, w1, w2, w3);
endmodule

module C12T28SOI_LR_AOI22(input A, input B, input C, input D, output Y);
	and U1 (w1, A, B);
	and U2 (w2, C, D);
	nor #1 U3 (Y, w1, w2);
endmodule

module C12T28SOI_LR_BF (input A, output Y);
	buf #1 U1 (Y, A);
endmodule

module C12T28SOI_LR_IV (input A, output Y);
	not #1 U1 (Y, A);
endmodule

module C12T28SOI_LR_NAND2A (input A, input B, output Y);
	not(w1, A);
	nand #1 U1 (Y, w1, B);
endmodule

module C12T28SOI_LR_NAND2(input A, input B, output Y);
	nand #1 U1 (Y, A, B);
endmodule

module C12T28SOI_LR_NAND3AB (input A, input B, input C, output Y);
	not(w1, A);
	not(w2, B);
	nand #1(Y, w1, w2, C);
endmodule

module C12T28SOI_LR_NAND3A (input A, input B, input C, output Y);
	not(w1, A);
	nand #1(Y, w1, B, C);
endmodule

module C12T28SOI_LR_NAND3(input A, input B, input C, output Y);
	nand #1 U1 (Y, A, B, C);
endmodule

module C12T28SOI_LR_NAND4AB (input A, input B, input C, input D, output Y);
	not(w1, A);
	not(w2, B);
	nand #1(Y, w1, w2, C, D);
endmodule

module C12T28SOI_LR_NAND4 (input A, input B, input C, input D, output Y);
	nand #1(Y, A, B, C, D);
endmodule

module C12T28SOI_LR_NOR2A (input A, input B, output Y);
	not(w1, A);
	nor #1(Y, w1, B);
endmodule

module C12T28SOI_LR_NOR2 (input A, input B, output Y);
	nor #1(Y, A, B);
endmodule

module C12T28SOI_LR_NOR3A (input A, input B, input C, output Y);
	not(w1, A);
	nor #1(Y, w1, B, C);
endmodule

module C12T28SOI_LR_NOR3 (input A, input B, input C, output Y);
	nor #1(Y, A, B, C);
endmodule

module C12T28SOI_LR_NOR4AB (input A, input B, input C, input D, output Y);
	not(w1, A);
	not(w2, B);
	nor #1 (Y, w1, w2, C, D);
endmodule

module C12T28SOI_LR_NOR4 (input A, input B, input C, input D, output Y);
	nor #1 (Y, A, B, C, D);
endmodule

module C12T28SOI_LR_OA112 (input A, input B, input C, input D, output Y);
	or(w1, A, B);
	and #1 (Y, w1, C, D);
endmodule

module C12T28SOI_LR_OA12 (input A, input B, input C, output Y);
	or(w1, A, B);
	and #1 (Y, w1, C);
endmodule

module C12T28SOI_LR_OA222 (input A, input B, input C, input D, input E, input F, output Y);
	or(w1, A, B);
	or(w2, C, D);
	or(w3, E, F);
	and #1 (Y, w1, w2, w3);
endmodule

module C12T28SOI_LR_OA22 (input A, input B, input C, input D, output Y);
	or(w1, A, B);
	or(w2, C, D);
	and #1 (Y, w1, w2);
endmodule

module C12T28SOI_LR_OAI112 (input A, input B, input C, input D, output Y);
	or(w1, A, B);
	nand #1 (Y, w1, C, D);
endmodule

module C12T28SOI_LR_OAI12 (input A, input B, input C, output Y);
	or(w1, A, B);
	nand #1 (Y, w1, C);
endmodule

module C12T28SOI_LR_OAI211 (input A, input B, input C, input D, output Y);
	or(w1, A, B);
	nand #1 (Y, w1, C, D);
endmodule

module C12T28SOI_LR_OAI21(input A, input B, input C, output Y);
	or U1 (w1, A, B);
	nand #1 U2 (Y, w1, C);
endmodule

module C12T28SOI_LR_OAI222 (input A, input B, input C, input D, input E, input F, output Y);
	or(w1, A, B);
	or(w2, C, D);
	or(w3, E, F);
	nand #1 (Y, w1, w2, w3);
endmodule

module C12T28SOI_LR_OAI22(input A, input B, input C, input D, output Y);
	or U1 (w1, A, B);
	or U2 (w2, C, D);
	nand #1 U3 (Y, w1, w2);
endmodule

module C12T28SOI_LR_OR2AB (input A, input B, output Y);
	not(w1, A);
	not(w2, B);
	or #1 (Y, w1, w2);
endmodule

module C12T28SOI_LR_OR2(input A, input B, output Y);
	or #1 U1 (Y, A, B);
endmodule

module C12T28SOI_LR_OR4 (input A, input B, input C, input D, output Y);
	or #1 (Y, A, B, C, D);
endmodule
