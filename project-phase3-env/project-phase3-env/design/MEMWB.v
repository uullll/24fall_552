module MEMWB(
    input clk,
    input rst,
    input stall,

    //Control Signal
    input MEM_RegWrite,
    input MEM_MemtoReg,
    input MEM_Halt,
    input MEM_PCSave,
    
    //DataPath
    input [3:0]MEM_rd,  //Destination Register
    input [15:0]MEM_AluResult,
    input [15:0]MEM_ReadData2,  
    input [15:0]MEM_DataOut,
    input [15:0]MEM_instr,
    input [15:0]MEM_pc,

    //Control Signal Output
    output WB_RegWrite,
    output WB_MemtoReg,
    output WB_Halt,
    output WB_PCSave,

    //DataPath
    output [3:0]WB_rd,  //Destination Register
    output [15:0]WB_AluResult,
    output [15:0]WB_ReadData2,   //MemData
    output [15:0]WB_instr,
    output [15:0]WB_pc,
    output [15:0]WB_MemDataOut
);
    wire write_en=~stall; 

    pldff #(.WIDTH(16)) AluResult_pldff(
        .clk(clk),
        .rst(rst),
        .wen(write_en),
        .d(MEM_AluResult),
        .q(WB_AluResult)
    );

    pldff #(.WIDTH(16)) ReadData2_pldff(
        .clk(clk),
        .rst(rst),
        .wen(write_en),
        .d(MEM_ReadData2),
        .q(WB_ReadData2)
    );
    
     pldff #(.WIDTH(16)) MemData_pldff(
        .clk(clk),
        .rst(rst),
        .wen(write_en),
        .d(MEM_DataOut),
        .q(WB_MemDataOut)
    );

    pldff #(.WIDTH(16)) instr_pldff(
        .clk(clk),
        .rst(rst),
        .wen(write_en),
        .d(MEM_instr),
        .q(WB_instr)
    );

    pldff #(.WIDTH(16)) pc_pldff(
        .clk(clk),
        .rst(rst),
        .wen(write_en),
        .d(MEM_pc),
        .q(WB_pc)
    );

    pldff #(.WIDTH(4)) rd_pldff(
        .clk(clk),
        .rst(rst),
        .wen(write_en),
        .d(MEM_rd),
        .q(WB_rd)
    );

    pldff #(.WIDTH(4)) control_pldff(
        .clk(clk),
        .rst(rst),
        .wen(write_en),
        .d({MEM_RegWrite, MEM_MemtoReg, MEM_Halt, MEM_PCSave}),
        .q({WB_RegWrite, WB_MemtoReg, WB_Halt, WB_PCSave})
    );

endmodule