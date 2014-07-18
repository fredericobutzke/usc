
module pipeline();

parameter hs_delay 	= 5;
parameter stages 	= 4;


wire   Rreq_01,	 	Rreq_12,   Rreq_20;
wire  REreq_01,	   REreq_12,  REreq_20;
wire  REack_01,	   REack_12,  REack_20;
wire   Rack_01,	 	Rack_12,   Rack_20;
wire     clk_0,	 	  clk_1,     clk_2;
wire  sample_0,	   sample_1,  sample_2;
reg     Err1_0,	 	 Err1_1,    Err1_2;
wire    Err0_0,	 	 Err0_1,    Err0_2;
reg 	rst;

initial begin
	$dumpfile("pipeline.vcd");
   	$dumpvars(0, pipeline);

  	rst = 'b0;
	{Err1_0, Err1_1, Err1_2} = 'b0;

  	#25

  	rst = 'b1;

  	#500

  	$finish;

end

	controller_token
	ctl0 (
	  .Lack(Rack_20_o),
	  .Rreq(Rreq_01_o),
	  .LEreq(REreq_20_o),
	  .REack(REack_01_o),
	  .clk(clk_0),
	  .sample(sample_0),
	  .Lreq(Rreq_20),
	  .Rack(Rack_01),
	  .LEack(REack_20),
	  .REreq(REreq_01),
	  .Err1(Err1_0),
	  .Err0(Err0_0),
	  .rst(rst)
	);

	assign #(hs_delay) Rack_20 = Rack_20_o;
	assign #(hs_delay) REreq_20 = REreq_20_o;
	assign #(hs_delay) REack_01 = REack_01_o;
	assign #(hs_delay) Rreq_01 = Rreq_01_o;

	controller 
	ctl1 (
	  .Lack(Rack_01_o),
	  .Rreq(Rreq_12_o),
	  .LEreq(REreq_01_o),
	  .REack(REack_12_o),
	  .clk(clk_1),
	  .sample(sample_1),
	  .Lreq(Rreq_01),
	  .Rack(Rack_12),
	  .LEack(REack_01),
	  .REreq(REreq_12),
	  .Err1(Err1_1),
	  .Err0(Err0_1),
	  .rst(rst)
	);

	assign #(hs_delay) Rack_01 = Rack_01_o;
	assign #(hs_delay) REreq_01 = REreq_01_o;
	assign #(hs_delay) REack_12 = REack_12_o;
	assign #(hs_delay) Rreq_12 = Rreq_12_o;

	controller 
	ctl2 (
	  .Lack(Rack_12_o),
	  .Rreq(Rreq_20_o),
	  .LEreq(REreq_12_o),
	  .REack(REack_20_o),
	  .clk(clk_2),
	  .sample(sample_2),
	  .Lreq(Rreq_12),
	  .Rack(Rack_20),
	  .LEack(REack_12),
	  .REreq(REreq_20),
	  .Err1(Err1_2),
	  .Err0(Err0_2),
	  .rst(rst)
	);

	assign #(hs_delay) Rack_12 = Rack_12_o;
	assign #(hs_delay) REreq_12 = REreq_12_o;
	assign #(hs_delay) REack_20 = REack_20_o;
	assign #(hs_delay) Rreq_20 = Rreq_20_o;

	assign #1 Err0_0 = sample_0 ; 
	assign #1 Err0_1 = sample_1 ; 
	assign #1 Err0_2 = sample_2 ; 

endmodule