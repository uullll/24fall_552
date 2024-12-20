
`timescale 1ns / 1ps
module bit_cell(
  input clk,
  input rst,
  input d,
  input wren,
  input rden1,
  input rden2,
  inout bitline1,
  inout bitline2
  );
    wire q;
    dff dff1(.q(q), .d(d), .wen(wren), .clk(clk), .rst(rst));
    
        assign bitline1 = rden1 ? q : 1'bz;
        assign bitline2 = rden2 ? q : 1'bz;
    
endmodule