module controller(
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

    // goL = Lack 
    // goR = LEack
  
    parameter DELAY_B = 5;
    parameter DELAY_E = 5;
  
    wire goD, edo, z0,edi;
    wire delay; 
  
    assign LEreq = Lreq ;

    assign #1 Lack = ~delay & Lack & rst | Lack & ~z0 & rst | delay & ~z0 ;
    assign #1 Rreq = LEack & ~Rack | LEack & Rreq | ~Rack & Rreq & rst;
    assign #1 REack = edi & Rreq | REreq & REack | ~Err0 & ~edi & REack & rst | REreq & Err0 & Rreq ;
    
    assign #1 goD = ~LEack & Rack & REreq | LEack & ~Rack & ~REreq | ~Err0 & ~edi & goD & rst ;
    assign #1 edo = ~REreq & Err1 & ~edi & REack | REreq & Err1 & ~edi & ~REack ;
    
    assign #1 clk = goD & ~delay & ~sample;
    assign #1 sample = delay | goD & sample;
    
    assign #1 z0 = goD & z0 & rst | delay & z0 & rst | goD & ~delay & Lack & ~sample;

    // Delay lines
    assign #DELAY_E edi = edo;
    assign #DELAY_B delay = clk;

endmodule



