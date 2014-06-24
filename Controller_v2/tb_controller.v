module tb_controller();

   // simulation variables
   parameter hs_delay		  		= 20;
   parameter error_delay		  	= 7;
   parameter no_error_delay		  	= 2;

   parameter   reset_time           = 30;
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
    reg [1:0] counter_error ;
    reg [1:0] counter_rack ;

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

 		{Lreq, Rack, LEack, REreq, Err1, Err0, rst} = 'b0;
		
		state = 'b1;
		{counter_error, counter_rack} = 'b0;
		
		#(reset_time);
 		rst = 'b1;

 		#2
 		Lreq = 'b1;
 		
		#(break_time);
		$finish;
 	end


 	//Here I need to simulate the pipeline environment

	//Lreq
	always @ (Lack) begin 
		if(rst)	#10	Lreq = ~Lack;
	end

	//LEack
	always @ (LEreq) begin 
 		if(rst)	#(hs_delay)	LEack = LEreq;
	end

	//REreq
	always @ (Rreq) begin 
 		if(rst)	#(hs_delay)	REreq = Rreq;
	end
  	
  	//Rack
  	always @ (REack) begin 
 		if(rst && counter_rack < 3) begin
			#(hs_delay)	Rack = REack;
			counter_rack = counter_rack + 1;
 		end else begin
 			#50 Rack = REack;
 			counter_rack = 'b0;
 		end
	end

	//Err0 and Err1
	always @ (sample) begin 
		if(rst) begin
			if (state) begin 
				#5 Err0 = sample;
				if (~sample) begin
					counter_error = counter_error + 1;
					if(counter_error > 1) begin
					 	state = 'b0 ;
					 	counter_error = 0;
					end
				end
			end else begin
				#5 Err1 = sample;
				if (~sample) begin
					counter_error = counter_error + 1;
					if(counter_error > 1) begin
					 	state = 'b1 ;
					 	counter_error = 0;
					end
				end
			end
		end
	end

endmodule