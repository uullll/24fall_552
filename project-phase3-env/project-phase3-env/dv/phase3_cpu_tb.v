`timescale 1ns / 1ps

// Top-level testbench for ECE 552 cpu.v Phase 2
module phase3_cpu_tb ();
  localparam half_cycle = 50;

  // Signals that interface to the DUT.
  wire [15:0] PC;
  wire Halt;  /* Halt executed and in Memory or writeback stage */
  reg clk;  /* Clock input */
  reg rst;  /* (Active high) Reset input */

  // Instantiate the processor as Design Under Test.
  cpu DUT (
      .clk(clk),
      .rst(rst),
      .pc (PC),
      .hlt(Halt)
  );

  initial begin
    clk <= 1;
    forever #half_cycle clk <= ~clk;
  end

  initial begin
    rst <= 1;  /* Intial reset state */
    repeat (3) @(negedge clk);
    rst <= 0;
  end

  // Assign internal signals - See wisc_trace_p3.v for instructions.
  // Edit the example below. You must change the signal names on the right hand side to match your naming convention.
  wisc_trace_p3 wisc_trace_p3 (
      .clk(clk),
      .rst(rst),
      .PC(PC),
      .Halt(Halt),
      .Inst(DUT.id_instruction),
      .RegWrite(DUT.register_file.write_reg),
      .WriteRegister(DUT.register_file.dst_reg),
      .WriteData(DUT.register_file.dst_data),
      .MemRead(DUT.dmem.enable & ~DUT.dmem.wr),
      .MemWrite(DUT.dmem.enable & DUT.dmem.wr),
      .MemAddress(DUT.dmem.addr),
      .MemDataIn(DUT.dmem.data_in),
      .MemDataOut(DUT.dmem.data_out),
      .icache_req(DUT.icache_req),
      .icache_hit(DUT.icache_hit),
      .dcache_req(DUT.dcache_req),
      .dcache_hit(DUT.dcache_hit)
  );

  /* Add anything else you want here */

endmodule
