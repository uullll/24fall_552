module Forwarding_Unit (
    input [3:0]EX_rs,
    input [3:0]EX_rt,
    input [3:0]EX_rd,
    input [3:0]EX_opcode,

    input [3:0]MEM_opcode,
    input [3:0]MEM_rd,
    input MEM_RegWrite,
    input MEM_MemWrite,

    input [3:0]WB_rd,
    input WB_RegWrite,

    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB,
    output mem_to_mem
);
    wire MEM_rd_isnotzero = (MEM_rd != 0) ? 1'b1 : 1'b0;
    wire WB_rd_isnotzero = (WB_rd != 0) ? 1'b1 : 1'b0;
    wire EX_isLB = (EX_opcode == 4'b1010) | (EX_opcode == 4'b1011);
    wire EX_isSave = (EX_opcode == 4'b1001) ? 1'b1 : 1'b0;
    
    assign mem_to_mem =(MEM_MemWrite) & (WB_RegWrite) & (WB_rd != 4'b0000) & (WB_rd == MEM_rd);

    wire is_ForwardA;
    assign is_ForwardA = WB_RegWrite & WB_rd_isnotzero & (WB_rd==EX_rs);
    always @(*)begin //ForwardA
        case({MEM_RegWrite, MEM_rd_isnotzero, (MEM_rd==EX_rs)})
            3'b111: ForwardA = 2'b10; 
            default
                ForwardA = is_ForwardA ? 2'b01 : 2'b00;
        endcase
    end

    wire is_ForwardB, is_LBorSave;
    assign is_ForwardB = WB_RegWrite & WB_rd_isnotzero & (WB_rd==EX_rt);
    assign is_LBorSave = EX_isLB | EX_isSave;
    
    always @(*)begin //ForwardB
        case({MEM_RegWrite, MEM_rd_isnotzero, (MEM_rd==EX_rt),EX_isLB, EX_isSave})
            5'b11100: ForwardB = 2'b10; 
            default ForwardB = is_ForwardB ? 
                              (is_LBorSave ? 2'b00 : 2'b01) : 2'b00;
        endcase
    end

endmodule 
