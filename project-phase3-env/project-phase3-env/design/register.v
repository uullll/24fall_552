module register(
  input clk,
  input rst,
  input [15:0] d,
  input write_reg,
  input rden1,
  input rden2,
  inout [15:0] bitline1,
  inout [15:0] bitline2
  );
    bit_cell c0(.clk(clk), .rst(rst), .d(d[0]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[0]), .bitline2(bitline2[0]));
    bit_cell c1(.clk(clk), .rst(rst), .d(d[1]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[1]), .bitline2(bitline2[1]));
    bit_cell c2(.clk(clk), .rst(rst), .d(d[2]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[2]), .bitline2(bitline2[2]));
    bit_cell c3(.clk(clk), .rst(rst), .d(d[3]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[3]), .bitline2(bitline2[3]));
    bit_cell c4(.clk(clk), .rst(rst), .d(d[4]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[4]), .bitline2(bitline2[4]));
    bit_cell c5(.clk(clk), .rst(rst), .d(d[5]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[5]), .bitline2(bitline2[5]));
    bit_cell c6(.clk(clk), .rst(rst), .d(d[6]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[6]), .bitline2(bitline2[6]));
    bit_cell c7(.clk(clk), .rst(rst), .d(d[7]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[7]), .bitline2(bitline2[7]));
    bit_cell c8(.clk(clk), .rst(rst), .d(d[8]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[8]), .bitline2(bitline2[8]));
    bit_cell c9(.clk(clk), .rst(rst), .d(d[9]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[9]), .bitline2(bitline2[9]));
    bit_cell c10(.clk(clk), .rst(rst), .d(d[10]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[10]), .bitline2(bitline2[10]));
    bit_cell c11(.clk(clk), .rst(rst), .d(d[11]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[11]), .bitline2(bitline2[11]));
    bit_cell c12(.clk(clk), .rst(rst), .d(d[12]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[12]), .bitline2(bitline2[12]));
    bit_cell c13(.clk(clk), .rst(rst), .d(d[13]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[13]), .bitline2(bitline2[13]));
    bit_cell c14(.clk(clk), .rst(rst), .d(d[14]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[14]), .bitline2(bitline2[14]));
    bit_cell c15(.clk(clk), .rst(rst), .d(d[15]), .wren(write_reg), .rden1(rden1), .rden2(rden2), .bitline1(bitline1[15]), .bitline2(bitline2[15]));
    

endmodule
