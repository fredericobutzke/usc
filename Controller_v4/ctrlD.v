assign clk = goD & ~delay & ~sample;
assign Lack = ~delay & Lack | delay & ~z0 | Lack & ~z0;
assign sample = delay | goD & sample;
assign z0 = goD & z0 | delay & z0 | goD & ~delay & Lack & ~sample;