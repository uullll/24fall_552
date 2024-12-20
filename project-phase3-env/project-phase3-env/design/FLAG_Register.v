module FLAG_Register(
    input clk,
    input rst,
    input [15:0] alu_result,
    input [15:0] EX_instr,
    input [3:0] opcode,
    input FLAG_Enable,
    input alu_overflow,
    output [2:0] f //Z=f[2], V=f[1], N=f[0] 
    );
    wire First_instr;
    wire nop;

    assign First_instr = EX_instr == 16'b0;
    assign nop = EX_instr == 16'h4000;

    wire Z_enable = ~nop & ~First_instr & FLAG_Enable & (rst == 1'b0) ;
    wire V_enable = ~nop & ~First_instr & FLAG_Enable & (rst == 1'b0) & (opcode[3:0] == 4'b0000 | opcode[3:0] == 4'b0001);
    wire N_enable = ~nop & ~First_instr & FLAG_Enable & (rst == 1'b0) & (opcode[3:0] == 4'b0000 | opcode[3:0] == 4'b0001);

    reg Z_out;
    reg V_out;
    reg N_out;

    always @* case(Z_enable)
        1'b1: Z_out = (alu_result == 16'b0);
        1'b0: Z_out = (rst) ? 1'b0 : Z_out;
        default: Z_out = 1'b0;
    endcase

    always @* case(V_enable)
        1'b1: V_out = alu_overflow;
        1'b0: V_out = (rst) ? 1'b0 : V_out;
        default: V_out = 1'b0;
    endcase

    always @* case(N_enable)
        1'b1: N_out = alu_result[15];
        1'b0: N_out = (rst) ? 1'b0 : N_out;
        default: N_out = 1'b0;
    endcase

    assign f = {Z_out, V_out, N_out};
       
endmodule
