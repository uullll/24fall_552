`timescale 1ns / 1ps

// Top-level testbench for ECE 552 cpu.v Phase 3
module phase3_cpu_tb ();
  localparam half_cycle = 50;

  // Signals that interface to the DUT
  wire [15:0] PC;
  wire Halt;  /* Halt executed and in Memory or writeback stage */
  reg clk;  /* Clock input */
  reg rst;  /* (Active high) Reset input */

  // Instantiate the processor as Design Under Test
  cpu DUT (
      .clk(clk),
      .rst(rst),
      .pc(PC),
      .hlt(Halt)
  );

  initial begin
    clk <= 1;
    forever #half_cycle clk <= ~clk;
  end

  initial begin
    rst <= 1;  /* Initial reset state */
    repeat (3) @(negedge clk);
    rst <= 0;
  end

  // Map internal signals to wisc_trace_p3
  wisc_trace_p3 wisc_trace_p3 (
      .clk(clk),
      .rst(rst),
      .PC(PC),
      .Halt(Halt),
      // Map instruction from ID stage
      .Inst(DUT.ID_instr),
      // Map register file signals
      .RegWrite(DUT.WB_RegWrite),
      .WriteRegister(DUT.WB_rd),
      .WriteData(DUT.WB_WriteData),
      // Map memory signals
      .MemRead(DUT.MEM_MemRead),
      .MemWrite(DUT.MEM_MemWrite),
      .MemAddress(DUT.MEM_AluResult),
      .MemDataIn(DUT.MEM_DataIn),
      .MemDataOut(DUT.MEM_DataOut),
      // Map cache signals
      .icache_req(~DUT.Icache_stall),
      .icache_hit(DUT.Icache_Hit),
      .dcache_req(DUT.MEM_MemRead | DUT.MEM_MemWrite),
      .dcache_hit(DUT.Dcache_Hit)
  );

endmodule