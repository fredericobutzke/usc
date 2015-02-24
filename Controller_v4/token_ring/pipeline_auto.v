
module pipeline_auto();

	parameter 	reset_delay				=	70		;
	parameter 	hs_delay				=	1		;
	parameter	run_time				=	1000	;
	parameter 	step_time            	= 	1		;

	parameter	stages 					=	5	;



   // input cycle time calculations
   real cycle_time      = 0.0;
   real last_la_up_time = 0.0;

	wire [stages-1 : 0] Rreq ;
	wire [stages-1 : 0] Rreq_o ;
	wire [stages-1 : 0] REreq;
	wire [stages-1 : 0] REreq_o;
	wire [stages-1 : 0] REack;
	wire [stages-1 : 0] REack_o;
	wire [stages-1 : 0] Rack ;
	wire [stages-1 : 0] Rack_o ;

	wire Err0 [stages-1 : 0];
	wire Err1 [stages-1 : 0];
	wire [stages-1 : 0] sample;
	wire [stages-1 : 0] clk;

	reg rst ;

	initial begin
		$dumpfile("pipeline_auto.vcd");
   		$dumpvars(0, pipeline_auto);

		rst = 'b0;
		#(reset_delay)
		rst = 'b1;
	end

	   // multiple syntax for reset:
   initial begin
      // evaluate termination conditions
      forever begin
         #step_time

         if ($realtime >= run_time) begin
      	    $display("Terminating simulation due to run time limit\n");
      	    $display("Max Cycle Time:           %.3f", cycle_time);
      	    $finish;
      	end
      
      end
   end // initial begin

	genvar i ;
	generate
		//For each stage
		for (i = 0; i < stages; i=i+1) begin : controller

			//Assign the Error signals to the controllers
			assign #1 Err0[i] = sample[i] ; 
			assign Err1[i] = 'b0 ; 

			//If the stage is even then its the normal controller.
			if (i%2 == 0) begin

				//	If it's the first stage then assign the right channels of the last
				//stage to the left channels of the first stage.
				if (i == 0) begin
				   controller 
					ctl (
						//outputs
				  		.Lack(Rack_o[stages-1]),
				  		.Rreq(Rreq_o[i]),
				  		.LEreq(REreq_o[stages-1]),
				  		.REack(REack_o[i]),
				  		.clk(clk[i]),
				  		.sample(sample[i]),
				  		//inputs
				  		.Lreq(Rreq[stages-1]),
				  		.Rack(Rack[i]),
				  		.LEack(REack[stages-1]),
				  		.REreq(REreq[i]),
				  		.Err1(Err1[i]),
				  		.Err0(Err0[i]),
				  		.rst(rst)
					);

					//Ensure the handshake signals have annoted delays on 
					//them
					assign #(hs_delay) Rack[stages-1] = Rack_o[stages-1] ;
					assign #(hs_delay) Rreq[i] = Rreq_o[i] ;
					assign #(hs_delay) REreq[stages-1] = REreq_o[stages-1] ;
					assign #(hs_delay) REack[i] = REack_o[i] ;

				//Otherwise, if its in the middle of the pipeline assing
				//the wires nomrally.
				end else begin
				   controller 
					ctl (
						//outputs
				  		.Lack(Rack_o[i-1]),
				  		.Rreq(Rreq_o[i]),
				  		.LEreq(REreq_o[i-1]),
				  		.REack(REack_o[i]),
				  		.clk(clk[i]),
				  		.sample(sample[i]),
				  		//inputs
				  		.Lreq(Rreq[i-1]),
				  		.Rack(Rack[i]),
				  		.LEack(REack[i-1]),
				  		.REreq(REreq[i]),
				  		.Err1(Err1[i]),
				  		.Err0(Err0[i]),
				  		.rst(rst)
					);

					assign #(hs_delay) Rack[i-1] = Rack_o[i-1] ;
					assign #(hs_delay) Rreq[i] = Rreq_o[i] ;
					assign #(hs_delay) REreq[i-1] = REreq_o[i-1] ;
					assign #(hs_delay) REack[i] = REack_o[i] ;

				end

			//If its odd then its a token controller
			end else begin
	
				   token_controller 
					ctl_token (
						//outputs
				  		.Lack(Rack_o[i-1]),
				  		.Rreq(Rreq_o[i]),
				  		.LEreq(REreq_o[i-1]),
				  		.REack(REack_o[i]),
				  		.clk(clk[i]),
				  		.sample(sample[i]),
				  		//inputs
				  		.Lreq(Rreq[i-1]),
				  		.Rack(Rack[i]),
				  		.LEack(REack[i-1]),
				  		.REreq(REreq[i]),
				  		.Err1(Err1[i]),
				  		.Err0(Err0[i]),
				  		.rst(rst)
					);

					assign #(hs_delay) Rack[i-1] = Rack_o[i-1] ;
					assign #(hs_delay) Rreq[i] = Rreq_o[i] ;
					assign #(hs_delay) REreq[i-1] = REreq_o[i-1] ;
					assign #(hs_delay) REack[i] = REack_o[i] ;

			end
		end
	endgenerate

	always @ (posedge Rack_o[stages-1], posedge rst) begin
      if (last_la_up_time > 0) begin
	        cycle_time = $realtime - last_la_up_time;
      end
      if (rst == 1'b1) begin
	        last_la_up_time = $realtime;
      end
   end

endmodule