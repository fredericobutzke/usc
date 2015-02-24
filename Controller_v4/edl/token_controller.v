module token_controller(
  output Lack,
  output Rreq,
  output LEreq,
  output REack,
  output clk,
  output sample,
  input Lreq,
  input Rack,
  input LEack,
  input REreq,
  input Err1,
  input Err0,
  input rst
);

    //assign goR = LEack;
    //assign Lack = goL;

    parameter DELAY_B = 5;
    parameter DELAY_E = 5;
    
    wire goD, edo, edi, z0, z2 ;
    wire delay; 

    assign LEreq = Lreq;

    assign #1 REack = REreq & ~goD | edi & Rreq | REreq & REack | ~Err0 & ~edi & REack & rst | REreq & Err0 & Rreq;
    assign #1 Rreq = ~LEack & Rreq & rst | ~Rack & Rreq & rst | ~LEack & ~Rack & rst;

    assign #1 clk = goD & ~delay & ~sample;
    assign #1 sample = delay | goD & sample;

    assign #1 Lack = ~delay & Lack & rst | Lack & ~z0 & rst | delay & ~z0 ;
    
    assign #1 goD = LEack & Rack & REreq | ~Err0 & ~edi & goD & rst | ~LEack & ~Rack & ~REreq & z2;

    assign #1 edo = ~REreq & Err1 & ~edi & REack | REreq & Err1 & ~edi & ~REack;

    assign #1 z0 = goD & z0 & rst | delay & z0 & rst | goD & ~delay & Lack & ~sample;
    assign #1 z2 = ~REreq & z2 & rst | ~Err1 & ~Err0 & z2 & rst | Rack & ~Err1 & ~Err0 & ~edi & ~REack;

    // Delay lines
    assign #DELAY_E edi = edo;
    assign #DELAY_B delay = clk;

endmodule

