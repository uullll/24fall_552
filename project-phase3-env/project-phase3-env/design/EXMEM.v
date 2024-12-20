module EXMEM (
   input clk, 
   input rst,
   input stall,

   //control signal
   input wire EX_MemRead,
   input wire EX_MemtoReg,
   input wire EX_MemWrite,
   input wire EX_RegWrite,
   input wire EX_Halt,
   input wire EX_PCSave,

   //DataPath                           
   input wire [3:0]EX_rd, //Destination Register
   input wire [15:0]EX_AluResult, 
   input wire [15:0]EX_ReadData2,
   input wire [15:0]EX_instr,
   input wire [15:0]EX_pc,


   //Control Signal Output
   output wire MEM_Halt,
   output wire MEM_MemRead,
   output wire MEM_MemWrite,
   output wire MEM_MemtoReg,
   output wire MEM_RegWrite,
   output wire MEM_PCSave,
   
   //DataPath
   output wire [3:0]MEM_rd, //Destination Register
   output wire [15:0]MEM_AluResult,
   output wire [15:0]MEM_ReadData2,  //MemData
   output wire [15:0]MEM_instr,
   output wire [15:0]MEM_pc
);  
wire write_en = ~stall;

pldff #(.WIDTH(16)) AluResult_pldff(
    .clk(clk),
    .rst(rst),
    .wen(write_en),
    .d(EX_AluResult),
    .q(MEM_AluResult)
);

pldff #(.WIDTH(16)) instr_pldff(
    .clk(clk),
    .rst(rst),
    .wen(write_en),
    .d(EX_instr),
    .q(MEM_instr)
);

pldff #(.WIDTH(16)) ReadData2_pldff(
    .clk(clk),
    .rst(rst),
    .wen(write_en),
    .d(EX_ReadData2),
    .q(MEM_ReadData2)
);

pldff #(.WIDTH(4)) rd_pldff(
    .clk(clk),
    .rst(rst),
    .wen(write_en),
    .d(EX_rd),
    .q(MEM_rd)
);

pldff #(.WIDTH(16)) pc_pldff(
    .clk(clk),
    .rst(rst),
    .wen(write_en),
    .d(EX_pc),
    .q(MEM_pc)
);

pldff #(.WIDTH(6)) control_pldff(
      .clk(clk),
      .rst(rst),
      .wen(write_en),
      .d({EX_MemRead, EX_MemWrite, EX_MemtoReg, EX_RegWrite, EX_Halt, EX_PCSave}),
      .q({MEM_MemRead, MEM_MemWrite, MEM_MemtoReg, MEM_RegWrite, MEM_Halt, MEM_PCSave})
);

endmodule