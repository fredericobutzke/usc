module tb_controller();

   // simulation variables
   parameter hs_delay		  		= 5;
   parameter error_delay		  	= 7;
   parameter no_error_delay		  	= 2;

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

	reg state;
    reg [1:0] cnt ;

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
		
		state = 'b1;
		cnt = 'b0;
		#(reset_time);
 		rst = 'b1;

 		#2
 		Lreq = 'b1;
 		
		#(break_time);
		$finish;
 	end


 	//Here I need to simulate the pipeline environment
  	always @ (REack) begin 
 		if(rst)	#(hs_delay)	Rack = REack;
	end

	always @ (Lack) begin 
		if(rst)	#(hs_delay)	Lreq = ~Lack;
	end

	always @ (LEreq) begin 
 		if(rst)	#(hs_delay)	LEack = LEreq;
	end

	always @ (Rreq) begin 
 		if(rst)	#(hs_delay)	REreq = Rreq;
	end


	always @ (sample) begin 
		if(rst) begin
			if (state) begin 
				#2 Err0 = sample;
				if (~sample) begin
					cnt = cnt + 1;
					if(cnt > 1) begin
					 	state = 'b0 ;
					 	cnt = 0;
					end
				end
			end else begin
				#2 Err1 = sample;
				if (~sample) begin
					cnt = cnt + 1;
					if(cnt > 1) begin
					 	state = 'b1 ;
					 	cnt = 0;
					end
				end
			end
		end
	end

endmodule