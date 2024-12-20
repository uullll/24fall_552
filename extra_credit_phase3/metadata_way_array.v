// ECE/CS 552 Metadata (aka Tag) Array Design File
// Tag Array with 64 sets
// Each set stores 8 bits for tag, valid, and LRU bit.
// set_enable is one-hot
// wen is 1 on writes and 0 on reads

module metadata_way_array (
    input clk,
    input rst,
    input [7:0] data_in,    
    input wen,
    input [63:0] set_enable,
    output [7:0] tag_out
);
    wire LRU, Valid;
    wire [7:0]metadata;

    assign LRU = data_in[0];
    assign Valid = wen;
    assign metadata = {data_in[7:2], Valid, LRU};


  cache_word #(
      .WIDTH(8)
  ) sets[63:0] (
      .clk(clk),
      .rst(rst),
      .data_in(metadata),
      .wen(wen),
      .enable(set_enable),
      .data_out(tag_out)
  );
endmodule
