.inputs Lreq Rack LEack REreq Err1 Err0
.outputs Lack Rreq LEreq REack clk sample
.internal c d e
.dummy a b
.graph
Lreq LEreq
LEreq LEack
LEack clk+
clk+ Rreq Lack
Rreq Rack
Lack Rack
Rack c
c Lreq
clk+ d
d clk- sample+
clk- c
p1 sample+
sample+ p0
p0 Err1+ Err0+
Err1+ a p4
p4 Err1-
Err0+ b p5
p5 Err0-
Err1- p1
Err0- p1
REreq p3
p3 a b
a e
b p6
e p6
p6 REack
REack REreq sample-
sample- p2 c
p2 Err1- Err0-
.marking{<c,Lreq> <REack,REreq> p1}
.end
