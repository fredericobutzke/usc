module tb_controller();

   // simulation variables
   parameter hs_delay		  = 5;

   parameter   reset_time           = 5;
   parameter   break_time		    = 500;
   parameter   step_time            = 1;
   integer     done                 = 0;
   integer     i                    = 1;

	wire Lack;
	wire Rreq;
	wire LEreq;
	wire REack;
	wire clk;
	wire sample;
	reg Lreq;
	reg Rack;
	reg LEack;
	reg REreq;
	reg Err1;
	reg Err0;
	reg rst;

	reg reseted;

	controller uut(
		.Lack(Lack),
		.Rreq(Rreq),
		.LEreq(LEreq),
		.REack(REack),
		.clk(clk),
		.sample(sample),
		.Lreq(Lreq),
		.Rack(Rack),
		.LEack(LEack),
		.REreq(REreq),
		.Err1(Err1),
		.Err0(Err0),
		.rst(rst)
 	);

 	initial begin

 		$dumpfile("tb_controller.vcd");
      	$dumpvars(0, tb_controller);

 		Lreq = 'b0;
		Rack = 'b0;
		LEack = 'b0;
		REreq = 'b0;
		Err1 = 'b0;
		Err0 = 'b0;
		rst = 'b0;
		
		#(reset_time);
 		Lreq = 'b1;
 		rst = 'b1;
 		
		#(break_time);
		$finish;
 	end


 	//Here I need to simulate the pipeline environment
  	always @ (REack) begin 
 		#(hs_delay) 
 		Rack = REack;
	end

	always @ (Rack) begin 
		#(hs_delay) 
		Lreq = ~Rack;
	end

	always @ (LEreq) begin 
 		#(hs_delay) 
		LEack = LEreq;
	end

	always @ (Rreq) begin 
 		#(hs_delay) 
 		REreq = Rreq;
	end

	always @ (sample) begin 
 		#(hs_delay) 
 		Err0 = sample;
	end

endmodule