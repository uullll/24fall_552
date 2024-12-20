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

    pldff #(.WIDTH(16)) pc_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(ID_pc),
        .q(EX_pc)
    );

    pldff #(.WIDTH(16)) instr_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(ID_instr),
        .q(EX_instr)
    );

    pldff #(.WIDTH(16)) ReadData1_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(ID_ReadData1),
        .q(EX_ReadData1)
    );

    pldff #(.WIDTH(16)) ReadData2_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(ID_ReadData2),
        .q(EX_ReadData2)
    );

    pldff #(.WIDTH(16)) Imm_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(ID_Imm),
        .q(EX_Imm)
    );

    pldff #(.WIDTH(4)) rd_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(ID_rd),
        .q(EX_rd)
    );

    pldff #(.WIDTH(4)) rs_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(ID_rs),
        .q(EX_rs)
    );

    pldff #(.WIDTH(4)) rt_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(ID_rt),
        .q(EX_rt)
    );

    pldff #(.WIDTH(13)) control_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d({ID_RegDst,ID_Branch,ID_MemRead,ID_MemtoReg,ID_MemWrite,ID_ALUSrc,ID_RegWrite,ID_BranchReg,ID_MemEnable,ID_LoadUpper,ID_PCSave,ID_Halt,ID_FLAG_Enable}),
        .q({EX_RegDst,EX_Branch,EX_MemRead,EX_MemtoReg,EX_MemWrite,EX_ALUSrc,EX_RegWrite,EX_BranchReg,EX_MemEnable,EX_LoadUpper,EX_PCSave,EX_Halt,EX_FLAG_Enable})
    );


endmodule