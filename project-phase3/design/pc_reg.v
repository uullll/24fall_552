module pc_register(
	input clk, rst, WriteEnable,
	input [15:0] d,
	inout [15:0] q
);

dff ff0(.q(q[0]), .d(d[0]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff1(.q(q[1]), .d(d[1]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff2(.q(q[2]), .d(d[2]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff3(.q(q[3]), .d(d[3]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff4(.q(q[4]), .d(d[4]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff5(.q(q[5]), .d(d[5]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff6(.q(q[6]), .d(d[6]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff7(.q(q[7]), .d(d[7]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff8(.q(q[8]), .d(d[8]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff9(.q(q[9]), .d(d[9]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff10(.q(q[10]), .d(d[10]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff11(.q(q[11]), .d(d[11]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff12(.q(q[12]), .d(d[12]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff13(.q(q[13]), .d(d[13]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff14(.q(q[14]), .d(d[14]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff15(.q(q[15]), .d(d[15]), .wen(WriteEnable), .clk(clk), .rst(rst));


endmodule
