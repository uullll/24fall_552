 module Hazard_Detection_Unit(
    input [3:0] ID_rs,
    input [3:0] ID_rt,
    input [3:0] EX_rd,
    input [3:0] MEM_rd,

    input [15:0]ID_instr,
    input [15:0]EX_instr,
    input [15:0]MEM_instr,
    input EX_RegWrite,
    input MEM_RegWrite,
    input EX_MemRead,
    input Branch_taken,

    output  stall,
    output  flush,
    output reg LoadToUse
);

    wire ID_isBranch = ((ID_instr[15:12] == 4'b1100) ||(ID_instr[15:12] == 4'b1101)) ? 1'b1 : 1'b0;
    wire ID_isStore = (ID_instr[15:12] == 4'b1001) ? 1'b1 : 1'b0;
    wire EX_isLoad = (EX_instr[15:12] == 4'b1000) ? 1'b1 : 1'b0;
    
    wire LoadToUse_rt = (EX_isLoad && (EX_rd != 4'b0) && (ID_rt == EX_rd) && (ID_isStore)) ? 1'b1: 1'b0;                   
    
    wire MEM_isLoad = (MEM_instr[15:12] == 4'b1000) ? 1'b1: 1'b0;

    reg Branch;    

// Stall for branch
    wire branch_data_hazard = 
        (ID_isBranch && 
         ((EX_RegWrite && (EX_rd != 4'b0) && (EX_rd == ID_rs)) || 
          (MEM_RegWrite && (MEM_rd != 4'b0) && (MEM_rd == ID_rs)))); 
          
    always @(*) begin
        case((LoadToUse_rt) && ~MEM_isLoad)
            1'b0:LoadToUse = 1'b0;
            1'b1:LoadToUse = 1'b1;
        endcase
    end
    
    always @(*) begin
        case(ID_isBranch & Branch_taken)
            1'b0:Branch = 1'b0;
            1'b1:Branch = 1'b1;
        endcase
    end
    
    assign stall = (ID_isBranch & MEM_isLoad & ID_rs == MEM_rd) ? 1'b1 : 1'b0;
    assign flush = Branch;
endmodule 