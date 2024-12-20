module Forwarding_Unit1(
    // Input signals from EX stage
    input [3:0] EX_rs,          // rs field
    input [3:0] EX_rt,          // rt field
    input [3:0] EX_rd,          // rd field
    
    // Input signals from MEM stage
    input [3:0] MEM_rd,         // Destination register
    input MEM_RegWrite,
    input MEM_MemWrite,         // Register write control signal
    
    // Input signals from WB stage
    input [3:0] WB_rd,          // Destination register
    input WB_RegWrite,          // Register write control signal

    input [3:0] EX_opcode,     // opcode signal
    input [3:0] MEM_opcode,
    input [3:0] WB_opcode,     
    
    // Output forwarding control signals
    output [1:0] ForwardA,     // Forward control for first ALU operand
    output [1:0] ForwardB,      // Forward control for second ALU operand

    // Output mem-to-mem forwarding signal
    output mem_to_mem
);
    parameter ADD = 4'b0000;
    parameter SUB = 4'b0001;
    parameter XOR = 4'b0010;
    parameter RED = 4'b0011;
    parameter SLL = 4'b0100;
    parameter SRA = 4'b0101;
    parameter ROR = 4'b0110;
    parameter PADDSB = 4'b0111;
    parameter LW = 4'b1000;
    parameter SW = 4'b1001;
    parameter LLB = 4'b1010;
    parameter LHB = 4'b1011;
    parameter B = 4'b1100;
    parameter BR = 4'b1101;
    parameter PCS = 4'b1110;
    parameter HLT = 4'b1111;

    // Generate comparison signals for rs
    wire rs_match_mem, rs_match_wb, rd_match_mem, rd_match_wb;
    assign rs_match_mem =  (MEM_rd[3] == EX_rs[3]) & 
                           (MEM_rd[2] == EX_rs[2]) & 
                           (MEM_rd[1] == EX_rs[1]) &
                           (MEM_rd[0] == EX_rs[0]) && MEM_RegWrite; 
    // specific for LLB and LHB

    wire llblhb;
    assign llblhb = ((EX_opcode == LHB) & (MEM_opcode == LLB)) ||
                    ((EX_opcode == LHB) & (WB_opcode == LLB)) ||
                    ((EX_opcode == LLB) & (MEM_opcode == LHB)) ||
                    ((EX_opcode == LLB) & (WB_opcode == LHB)); // Check if both are LLB or LHB
    
    wire rs_valid, rt_valid;

    assign rs_valid = (EX_opcode == ADD) || 
                      (EX_opcode == SUB) ||
                      (EX_opcode == XOR) ||
                      (EX_opcode == RED) ||
                      (EX_opcode == SLL) ||
                      (EX_opcode == SRA) ||
                      (EX_opcode == ROR) ||
                      (EX_opcode == PADDSB) ||
                      (EX_opcode == LW) ||
                      (EX_opcode == BR);
    assign rt_valid = (EX_opcode == ADD) ||
                      (EX_opcode == SUB) ||
                      (EX_opcode == XOR) ||
                      (EX_opcode == RED) ||
                      (EX_opcode == PADDSB)||
                      (EX_opcode == LW) ||
                      (EX_opcode == SW);


    assign rd_match_mem =  (MEM_rd[3] == EX_rd[3]) & 
                           (MEM_rd[2] == EX_rd[2]) & 
                           (MEM_rd[1] == EX_rd[1]) &
                           (MEM_rd[0] == EX_rd[0]) && MEM_RegWrite 
                           && llblhb;

    assign rd_match_wb = (WB_rd[3] == EX_rd[3] & 
                            WB_rd[2] == EX_rd[2] & 
                            WB_rd[1] == EX_rd[1] & 
                            WB_rd[0] == EX_rd[0]) && WB_RegWrite 
                            && llblhb;
    

    assign rs_match_wb = (WB_rd[3] == EX_rs[3] & WB_rd[2] == EX_rs[2] & WB_rd[1] == EX_rs[1] & WB_rd[0] == EX_rs[0]) && WB_RegWrite && rs_valid;
    
    // Generate valid signals for mem_rd and wb_rd incase of $zero register
    wire mem_rd_valid, wb_rd_valid;
    assign mem_rd_valid = |MEM_rd[3:0];  // Check if mem_rd is not 0    
    assign wb_rd_valid = |WB_rd[3:0];    // Check if wb_rd is not 0

    // Generate comparison signals for rt
    wire rt_match_mem, rt_match_wb;
    assign rt_match_mem =  ((MEM_rd[3] == EX_rd[3])) & 
                           ((MEM_rd[2] == EX_rd[2])) & 
                           ((MEM_rd[1] == EX_rd[1])) & 
                           ((MEM_rd[0] == EX_rd[0])) && MEM_RegWrite && (EX_opcode != LLB) && (EX_opcode != LHB) && rt_valid;
    assign rt_match_wb = ((WB_rd[3] == EX_rt[3] & WB_rd[2] == EX_rt[2] & WB_rd[1] == EX_rt[1] & WB_rd[0] == EX_rt[0]) 
                         && WB_RegWrite && (EX_opcode != LLB) && (EX_opcode != LHB)&& rt_valid);

    // Forward control logic using case statements
    wire [1:0] fwd_A_reg, fwd_B_reg;

    wire mem_match, wb_match;

    assign fwd_A_reg = {WB_RegWrite & wb_rd_valid & (rs_match_wb | rd_match_wb),
                        MEM_RegWrite & mem_rd_valid & (rs_match_mem | rd_match_mem)};
    assign fwd_B_reg = {WB_RegWrite & wb_rd_valid & rt_match_wb,
                        MEM_RegWrite & mem_rd_valid & rt_match_mem};

    // Assign outputs
    assign ForwardA = (fwd_A_reg == 2'b11) ? 2'b01 : fwd_A_reg;
    assign ForwardB = (fwd_B_reg == 2'b11) ? 2'b01 : fwd_B_reg;


    /* Mem-to-Mem forwading */
    assign mem_to_mem = (MEM_rd[3] == WB_rd[3] & MEM_rd[2] == WB_rd[2] & MEM_rd[1] == WB_rd[1] & MEM_rd[0] == WB_rd[0]) 
                            && WB_RegWrite && (MEM_opcode == SW);

endmodule