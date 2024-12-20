//////////////////////////////////////
//
// Memory -- single cycle write, multi-cycle read
//
// written for CS/ECE 552, Spring '18
// Gokul Ravi, 9 Apr 2018
//
// Modified for ECE 552, Fall '24 in Verilog 2001
// Boone Severson
//
// This is a byte-addressable,
// 16-bit wide memory
// Note: The last bit of the address is ignored, and must be 0.
//
// On reset, memory loads from file "loadfile_all.img".
// (You may change the name of the file in
// the $readmemh statement below.)
// File format:
//     @0
//     <hex data 0>
//     <hex data 1>
//     ...etc
//
//
//////////////////////////////////////

module memory4c #(
    parameter DWIDTH = 16,
    AWIDTH = 16
) (
    output wire [DWIDTH-1:0] data_out,
    output wire data_valid,
    input [DWIDTH-1:0] data_in,
    input [AWIDTH-1:0] addr,
    input enable,
    input wr,
    input clk,
    input rst
);
  localparam MemSize = 2 ** (AWIDTH - 1);
  localparam CycleDelays = 4;

  reg  [DWIDTH-1:0] data_out_pl            [0:CycleDelays-1];
  reg               data_valid_pl          [0:CycleDelays-1];
  reg  [DWIDTH-1:0] mem                    [    0:MemSize-1];
  reg               loaded;
  wire              is_read = enable & ~wr;
  wire              is_write = enable & wr;
  assign data_out   = data_out_pl[0];
  assign data_valid = data_valid_pl[0];

  initial begin
    loaded = 0;
  end
  always @(posedge clk) begin
    if (rst) begin
      //load loadfile_all.img
      if (!loaded) begin
        $readmemh("loadfile_data.img", mem);
        loaded <= 1;
      end
    end else begin
      if (is_write) mem[addr[AWIDTH-1:1]] <= data_in;  // Overwrite mem[addr[15:1]] with data_in
    end
  end

  integer i;
  always @(posedge clk) begin
    if (rst) begin
      for (i = 0; i < CycleDelays; i = i + 1) begin
        data_out_pl[i]   <= 0;
        data_valid_pl[i] <= 0;
      end
    end else begin
      data_out_pl[CycleDelays-1]   <= is_read ? {mem[addr[AWIDTH-1:1]]} : 0;
      data_valid_pl[CycleDelays-1] <= is_read;
      for (i = 0; i < CycleDelays - 1; i = i + 1) begin
        data_out_pl[i]   <= data_out_pl[i+1];
        data_valid_pl[i] <= data_valid_pl[i+1];
      end
    end
  end


endmodule

