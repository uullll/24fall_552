module IDEX(
    input clk,
    input rst,
    input flush,
    input stall,
    //Data Path
    input [15:0]ID_pc,
    input [15:0]ID_instr,
    input [15:0]ID_ReadData1,
    input [15:0]ID_ReadData2,
    input [15:0]ID_Imm,
    input [3:0]ID_rd,
    input [3:0]ID_rs,
    input [3:0]ID_rt,
    //Control Signals from Control_Unit
    input  ID_RegDst,
	input  ID_Branch,
	input  ID_MemRead,
	input  ID_MemtoReg,
	input  ID_MemWrite,
	input  ID_ALUSrc,
	input  ID_RegWrite,
	input  ID_BranchReg,
	input  ID_MemEnable,
	input  ID_LoadUpper,
	input  ID_PCSave,
	input  ID_Halt,
	input  ID_FLAG_Enable,
    //Control Signals Output
    output  EX_RegDst,
	output  EX_Branch,
	output  EX_MemRead,
	output  EX_MemtoReg,
	output  EX_MemWrite,
	output  EX_ALUSrc,
	output  EX_RegWrite,
	output  EX_BranchReg,
	output  EX_MemEnable,
	output  EX_LoadUpper,
	output  EX_PCSave,
	output  EX_Halt,
	output  EX_FLAG_Enable,
    // Data Path
    output [15:0]EX_pc,
    output [15:0]EX_instr,
    output [15:0]EX_ReadData1,
    output [15:0]EX_ReadData2,
    output [15:0]EX_Imm,
    output [3:0]EX_rd,
    output [3:0]EX_rs,
    output [3:0]EX_rt
);
    wire write_en = ~stall;
    wire [15:0]pc_in;
    wire [15:0]instr_in;
    wire [15:0]ReadData1_in;
    wire [15:0]ReadData2_in;
    wire [15:0]Imm_in;
    wire [3:0]rd_in;
    wire [3:0]rs_in;
    wire [3:0]rt_in;
    //Control Signals from Control_Unit
    wire  RegDst_in;
	wire  Branch_in;
	wire  MemRead_in;
	wire  MemtoReg_in;
	wire  MemWrite_in;
	wire  ALUSrc_in;
	wire  RegWrite_in;
	wire  BranchReg_in;
	wire  MemEnable_in;
	wire  LoadUpper_in;
	wire  PCSave_in;
	wire  Halt_in;
	wire  FLAG_Enable_in;

    assign pc_in = flush ? 16'b0 : ID_pc;
    assign instr_in = flush ? 16'h4000 : ID_instr;
    assign ReadData1_in = flush ? 16'b0 : ID_ReadData1;
    assign ReadData2_in = flush ? 16'b0 : ID_ReadData2;
    assign Imm_in = flush ? 16'b0 : ID_Imm;
    assign rd_in = flush ? 4'b0 : ID_rd;
    assign rs_in = flush ? 4'b0 : ID_rs;
    assign rt_in = flush ? 4'b0 : ID_rt;

    assign RegDst_in = flush ? 1'b0 : ID_RegDst;
    assign Branch_in = flush ? 1'b0 : ID_Branch;
    assign MemRead_in = flush ? 1'b0 : ID_MemRead;
    assign MemtoReg_in = flush ? 1'b0 : ID_MemtoReg;
    assign MemWrite_in = flush ? 1'b0 : ID_MemWrite;
    assign ALUSrc_in = flush ? 1'b0 : ID_ALUSrc;
    assign RegWrite_in = flush ? 1'b0 : ID_RegWrite;
    assign BranchReg_in = flush ? 1'b0 : ID_BranchReg;
    assign MemEnable_in = flush ? 1'b0 : ID_MemEnable;
    assign LoadUpper_in = flush ? 1'b0 : ID_LoadUpper;
    assign PCSave_in = flush ? 1'b0 : ID_PCSave;
    assign Halt_in = flush ? 1'b0 : ID_Halt;
    assign FLAG_Enable_in = flush ? 1'b0 : ID_FLAG_Enable;
    

    pldff #(.WIDTH(16)) pc_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(pc_in),
        .q(EX_pc)
    );

    pldff #(.WIDTH(16)) instr_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(instr_in),
        .q(EX_instr)
    );

    pldff #(.WIDTH(16)) ReadData1_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(ReadData1_in),
        .q(EX_ReadData1)
    );

    pldff #(.WIDTH(16)) ReadData2_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(ReadData2_in),
        .q(EX_ReadData2)
    );

    pldff #(.WIDTH(16)) Imm_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(Imm_in),
        .q(EX_Imm)
    );

    pldff #(.WIDTH(4)) rd_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(rd_in),
        .q(EX_rd)
    );

    pldff #(.WIDTH(4)) rs_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(rs_in),
        .q(EX_rs)
    );

    pldff #(.WIDTH(4)) rt_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(rt_in),
        .q(EX_rt)
    );

    pldff #(.WIDTH(13)) control_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d({RegDst_in,Branch_in,MemRead_in,MemtoReg_in,MemWrite_in,ALUSrc_in,RegWrite_in,BranchReg_in,MemEnable_in,LoadUpper_in,PCSave_in,Halt_in,FLAG_Enable_in}),
        .q({EX_RegDst,EX_Branch,EX_MemRead,EX_MemtoReg,EX_MemWrite,EX_ALUSrc,EX_RegWrite,EX_BranchReg,EX_MemEnable,EX_LoadUpper,EX_PCSave,EX_Halt,EX_FLAG_Enable})
    );


endmodule