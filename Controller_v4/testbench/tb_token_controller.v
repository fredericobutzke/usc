
module tb_controller();

   // simulation variables
   parameter hs_delay		  		= 20;
   parameter error_delay		  	= 7;
   parameter no_error_delay		  	= 2;

   parameter   reset_time           = 50;
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

	token_controller uut(
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

	function integer rand;
	  input integer max; input integer min;
	  begin
	    rand = min + {$random} % (max - min) ; 
	  end
	endfunction

 	initial begin

 		$dumpfile("tb_controller.vcd");
      	$dumpvars(0, tb_controller);

 		{Lreq, Rack, LEack, REreq, Err1, Err0, rst} = 'b0;
		
		state = 'b1;
		{counter_error, counter_rack} = 'b0;

		#(reset_time);
 		rst = 'b1;

		#(break_time);
		$finish;

 	end

	integer hs_delay_Lreq;
	integer hs_delay_LEack;
	integer hs_delay_REreq;
	integer hs_delay_Rack;

 	//Here I need to simulate the pipeline environment
	//Lreq
	always @ (Rack) begin 
		hs_delay_Lreq = rand(15, 1);
		if(rst)	#(hs_delay_Lreq) Lreq = Rack;
	end

	//LEack
	always @ (LEreq) begin 
		hs_delay_LEack = rand(15, 1);
 		if(rst)	#(hs_delay_LEack)	LEack = LEreq;
	end

	//REreq
	always @ (Rreq, posedge rst) begin 
		hs_delay_REreq = rand(15, 1);
 		if(rst)	#(hs_delay_REreq)	REreq = Rreq;
	end
  	
  	//Rack
  	always @ (REack) begin 
  		hs_delay_Rack = rand(15, 1);
 		if(rst && counter_rack < 3) begin
			#(hs_delay_Rack) Rack = REack;
			counter_rack = counter_rack + 1;
 		end else begin
 			#(hs_delay_Rack) Rack = REack;
 			counter_rack = 'b0;
 		end
	end

	//Err0 and Err1
	always @ (sample) begin 
		if(rst) begin
			if (state) begin 
				#1 Err0 = sample;
				if (~sample) begin
					counter_error = counter_error + 1;
					if(counter_error > 1) begin
					 	state = 'b0 ;
					 	counter_error = 0;
					end
				end
			end else begin
				#1 Err1 = sample;
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
