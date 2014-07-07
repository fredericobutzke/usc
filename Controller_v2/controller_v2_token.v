module controller_token(
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

    //Delta delay
    wire a, b;            
    
    //internal signals
    wire goML, goLM ;
  
    assign Lack = goML ;
    assign LEreq = Lreq;

    assign #1 Rreq = ~goLM & ~Rack | ~goLM & Rreq | ~Rack & Rreq & rst;
    assign #1 REack = b & Rreq | a & Rreq | REreq & ~sample & ~goML & rst | ~a & ~b & REack & rst;
    assign #1 clk = ~goLM & ~Rack & ~Err1 & ~Err0 & goML | goLM & Rack & ~Err1 & ~Err0 & REack ;
    assign #1 sample = REreq & goML | ~a & ~b & sample & rst | ~REreq & ~goML & ~Rreq;
  
    assign #1 goLM = LEack & rst;
    assign #1 goML = ~sample & goML & rst | Err1 & ~Rreq | Err0 & ~Rreq | ~Err1 & ~Err0 & goML & rst ; 
  
    assign #1 a = Err0 ;
    assign #15 b = Err1;

endmodule