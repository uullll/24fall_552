module IFID(
    input clk,
    input rst,
    input flush,
    input stall,

    input [15:0] IF_pc,
    input [15:0] IF_instr,

    output [15:0] ID_pc,
    output [15:0] ID_instr
);
    wire write_en = ~stall;
    pldff #(.WIDTH(16)) pc_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(IF_pc),
        .q(ID_pc)
    );

    pldff #(.WIDTH(16)) instr_pldff(
        .clk(clk),
        .rst(rst|flush),
        .wen(write_en),
        .d(IF_instr),
        .q(ID_instr)
    );
    
endmodule