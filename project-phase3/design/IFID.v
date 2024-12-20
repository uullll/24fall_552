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
    wire [15:0]pc_in, instr_in;
    assign pc_in = flush ? 16'b0 : IF_pc;
    assign instr_in = flush ? 16'h4000 : IF_instr;
    pldff #(.WIDTH(16)) pc_pldff(
        .clk(clk),
        .rst(rst),
        .wen(write_en),
        .d(pc_in),
        .q(ID_pc)
    );

    pldff #(.WIDTH(16)) instr_pldff(
        .clk(clk),
        .rst(rst),
        .wen(write_en),
        .d(instr_in),
        .q(ID_instr)
    );
    
endmodule