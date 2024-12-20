
`timescale 1ns / 1ps
module cpu (
    input clk,rst,
    output hlt,
    output [15:0]pc
);

//IF stage signals
wire [15:0]IF_pc, IF_pc_next, IF_instr, Cache_instr, IF_instr_next;
wire Icache_stall, Dcache_stall, Icache_Hit, Dcache_Hit;
wire stall_cache, nop;

//ID stage signals
wire [15:0]ID_pc, ID_instr, ID_ReadData1, ID_ReadData2, ID_ReadData2_rf, ID_Imm;
wire [3:0]ID_rd, ID_rs, ID_rt;
wire ID_RegDst, ID_Branch, ID_MemRead, ID_MemtoReg, ID_MemWrite, ID_ALUSrc;
wire ID_RegWrite, ID_BranchReg, ID_MemEnable,ID_LoadUpper, ID_PCSave, ID_Halt, ID_FLAG_Enable;

//EX stage signals
wire [15:0]EX_pc, EX_instr, EX_ReadData1, EX_ReadData2, EX_Imm, EX_AluResult, EX_aluB;
wire [3:0]EX_rd, EX_rs, EX_rt;
wire EX_RegDst, EX_Branch, EX_MemRead, EX_MemtoReg, EX_MemWrite, EX_ALUSrc;
wire EX_RegWrite, EX_BranchReg, EX_MemEnable, EX_LoadUpper, EX_PCSave, EX_Halt, EX_FLAG_Enable;
wire [2:0]EX_flags;
wire EX_alu_overflow, EX_alu_zero;
wire [15:0]alu_in1, alu_in2;

//MEM stage signals
wire [15:0]MEM_instr, MEM_ReadData2, MEM_AluResult, MEM_pc, MEM_DataOut, MEM_DataIn;
wire [3:0]MEM_rd;
wire  MEM_Halt, MEM_MemRead, MEM_MemWrite, MEM_MemtoReg, MEM_RegWrite, MEM_PCSave;

//WB stage signals
wire [15:0]WB_instr,WB_ReadData2, WB_AluResult, WB_WriteData, WB_pc, WB_MemDataOut;
wire [3:0]WB_rd;
wire WB_Halt, WB_MemtoReg, WB_RegWrite, WB_PCSave;

//Forwarding and Hazard Detection signals
wire [1:0]ForwardA, ForwardB;
wire stall, flush, LoadToUse;
wire Branch_taken, mem_to_mem;
wire LoadToUse_rt, LoadToUse_rs, LoadToSave;



//IF stage
//PC_Register
pc_register pcReg(
	.clk(clk), 
	.rst(rst),  
	.WriteEnable(~stall & ~ID_Halt & ~stall_cache), 
    .d(IF_pc_next),
    .q(IF_pc)
);

//Cache Control
//pipelined_cache_control cache_ctrl(
pipelined_cache_control cache_ctrl(
    .clk(clk),
    .rst(rst),
    .Icache_write(1'b0),
    .Icache_read(~rst & ~stall),
    //.Icache_read(1'b1),
    //.Icache_read(~rst & ~stall_cache),
    .Dcache_write(MEM_MemWrite),
    .Dcache_read(MEM_MemRead),
    .Icache_addr(IF_pc),
    .Dcache_addr(MEM_AluResult),
    .memory_data_in(MEM_DataIn),
    //.Icache_instr_out(IF_instr),
    .Icache_instr_out(IF_instr),
    .Dcache_data_out(MEM_DataOut),
    .Icache_stall(Icache_stall),
    .Dcache_stall(Dcache_stall),
    .Icache_Hit(Icache_Hit),
    .Dcache_Hit(Dcache_Hit)
);
//IF/ID Register
IFID if_id(
    .clk(clk),
    .rst(rst),
    .flush(flush),
    .stall(stall | Dcache_stall),
    //.stall(stall | stall_cache),
    .IF_pc(IF_pc),
    .IF_instr(IF_instr),
    .ID_pc(ID_pc),
    .ID_instr(ID_instr)
);

//ID stage
//Register file
register_file rf(
    .clk(clk),
    .rst(rst),
    .src_reg1(ID_rs),
    .src_reg2(ID_rt),
    .dst_reg(WB_rd),
    .write_reg(WB_RegWrite),
    .dst_data(WB_WriteData),
    .src_data1(ID_ReadData1),
    .src_data2(ID_ReadData2_rf)
);

//Control unit
Control_Unit cu(
    .instr(ID_instr),
    .opcode(ID_instr[15:12]),
    .rst(rst),
    .RegDst(ID_RegDst),
    .Branch(ID_Branch),
    .MemRead(ID_MemRead),
    .MemtoReg(ID_MemtoReg),
    .MemWrite(ID_MemWrite),
    .ALUSrc(ID_ALUSrc),
    .RegWrite(ID_RegWrite),
    .BranchReg(ID_BranchReg),
    .MemEnable(ID_MemEnable),
    .LoadUpper(ID_LoadUpper),
    .PCSave(ID_PCSave),
    .Halt(ID_Halt),
    .FLAG_Enable(ID_FLAG_Enable)
);
//ID/EX Register
IDEX id_ex(
    .clk(clk),
    .rst(rst),
    .flush(flush),
    .stall(Dcache_stall),
    .ID_pc(ID_pc),
    .ID_instr(ID_instr),
    .ID_ReadData1(ID_ReadData1),
    .ID_ReadData2(ID_ReadData2),
    .ID_Imm(ID_Imm),
    .ID_rd(ID_rd),
    .ID_rs(ID_rs),
    .ID_rt(ID_rt),
    .ID_RegDst(ID_RegDst),
    .ID_Branch(ID_Branch),
    .ID_MemRead(ID_MemRead),
    .ID_MemtoReg(ID_MemtoReg),
    .ID_MemWrite(ID_MemWrite),
    .ID_ALUSrc(ID_ALUSrc),
    .ID_RegWrite(ID_RegWrite),
    .ID_BranchReg(ID_BranchReg),
    .ID_MemEnable(ID_MemEnable),
    .ID_LoadUpper(ID_LoadUpper),
    .ID_PCSave(ID_PCSave),
    .ID_Halt(ID_Halt),
    .ID_FLAG_Enable(ID_FLAG_Enable),
    .EX_pc(EX_pc),
    .EX_instr(EX_instr),
    .EX_ReadData1(EX_ReadData1),
    .EX_ReadData2(EX_ReadData2),
    .EX_Imm(EX_Imm),
    .EX_rd(EX_rd),
    .EX_rs(EX_rs),
    .EX_rt(EX_rt),
    .EX_RegDst(EX_RegDst),
    .EX_Branch(EX_Branch),
    .EX_MemRead(EX_MemRead),
    .EX_MemtoReg(EX_MemtoReg),
    .EX_MemWrite(EX_MemWrite),
    .EX_ALUSrc(EX_ALUSrc),
    .EX_RegWrite(EX_RegWrite),
    .EX_BranchReg(EX_BranchReg),
    .EX_MemEnable(EX_MemEnable),
    .EX_LoadUpper(EX_LoadUpper),
    .EX_PCSave(EX_PCSave),
    .EX_Halt(EX_Halt),
    .EX_FLAG_Enable(EX_FLAG_Enable)
);

//EX stage
//ALU
alu_16bit ALU(
    .alu_in1(alu_in1),
    .alu_in2(alu_in2),
    .opcode(EX_instr[15:12]),
    .alu_out(EX_AluResult),
    .zero(EX_alu_zero),
    .err(EX_alu_overflow)
);
//FLAG_Register
FLAG_Register fr(
    .clk(clk),
    .rst(rst),
    .alu_result(EX_AluResult),
    .EX_instr(EX_instr),
    .opcode(EX_instr[15:12]),
    .FLAG_Enable(EX_FLAG_Enable),
    .alu_overflow(EX_alu_overflow),
    .f(EX_flags)
);
//EX/MEM Register
EXMEM ex_mem(
    .clk(clk),
    .rst(rst),
    .stall(Dcache_stall),
    .EX_MemRead(EX_MemRead),
    .EX_MemtoReg(EX_MemtoReg),
    .EX_MemWrite(EX_MemWrite),
    .EX_RegWrite(EX_RegWrite),
    .EX_Halt(EX_Halt),
    .EX_rd(EX_rd),
    .EX_AluResult(EX_AluResult),
    .EX_ReadData2(EX_ReadData2),
    .EX_instr(EX_instr),
    .EX_PCSave(EX_PCSave),
    .EX_pc(EX_pc),
    .MEM_Halt(MEM_Halt),
    .MEM_MemRead(MEM_MemRead),
    .MEM_MemWrite(MEM_MemWrite),
    .MEM_MemtoReg(MEM_MemtoReg),
    .MEM_RegWrite(MEM_RegWrite),
    .MEM_rd(MEM_rd),
    .MEM_AluResult(MEM_AluResult),
    .MEM_ReadData2(MEM_ReadData2),
    .MEM_instr(MEM_instr),
    .MEM_PCSave(MEM_PCSave),
    .MEM_pc(MEM_pc)
);

//MEM stage
//MEM/WB Register
MEMWB mem_wb(
    .clk(clk),
    .rst(rst),
    .stall(Dcache_stall),
    .MEM_DataOut(MEM_DataOut),
    .MEM_RegWrite(MEM_RegWrite),
    .MEM_MemtoReg(MEM_MemtoReg),
    .MEM_Halt(MEM_Halt),
    .MEM_rd(MEM_rd),
    .MEM_AluResult(MEM_AluResult),
    .MEM_ReadData2(MEM_DataIn),
    .MEM_instr(MEM_instr),
    .MEM_PCSave(MEM_PCSave),
    .MEM_pc(MEM_pc),
    .WB_MemDataOut(WB_MemDataOut),
    .WB_RegWrite(WB_RegWrite),
    .WB_MemtoReg(WB_MemtoReg),
    .WB_Halt(WB_Halt),
    .WB_rd(WB_rd),
    .WB_AluResult(WB_AluResult),
    .WB_ReadData2(WB_ReadData2),
    .WB_instr(WB_instr),
    .WB_PCSave(WB_PCSave),
    .WB_pc(WB_pc)
);

//PC_control
pc_control pc_ctrl(
    .c(ID_instr[11:9]),
    .i(ID_instr[8:0]),
    .f(EX_flags),
    .Branch(ID_Branch),
    .BranchReg(ID_BranchReg),
    .Halt(ID_Halt),
    .Rs_data(ID_ReadData1),
    //.pc_in(ID_pc),
    .pc_in(IF_pc),
    .pc_out(IF_pc_next),
    .Branch_taken(Branch_taken)
);

//Forwarding Unit
Forwarding_Unit forwarding(
    .EX_rs(EX_rs),
    .EX_rt(EX_rt),
    .EX_rd(EX_rd),
    .EX_opcode(EX_instr[15:12]),
    .MEM_opcode(MEM_instr[15:12]),
    .MEM_rd(MEM_rd),
    .MEM_RegWrite(MEM_RegWrite),
    .MEM_MemWrite(MEM_MemWrite),
    .WB_rd(WB_rd),
    .WB_RegWrite(WB_RegWrite),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB),
    .mem_to_mem(mem_to_mem)
);

//Hazard Detection Unit
Hazard_Detection_Unit hazard(
    .ID_rs(ID_rs),
    .ID_rt(ID_rt),
    .EX_rd(EX_rd),
    .EX_rs(EX_rs),
    .MEM_rd(MEM_rd),
    .ID_instr(ID_instr),
    .EX_instr(EX_instr),
    .MEM_instr(MEM_instr),
    .EX_RegWrite(EX_RegWrite),
    .MEM_RegWrite(MEM_RegWrite),
    .ID_MemRead(ID_MemRead),
    .EX_MemRead(EX_MemRead),
    .Branch_taken(Branch_taken),
    .stall(stall),
    .flush(flush),
    .LoadToUse(LoadToUse),
    .LoadToUse_rs(LoadToUse_rs),
    .LoadToSave(LoadToSave)
    //.LoadToUse_rt(LoadToUse_rt),
    //.LoadToUse_rs(LoadToUse_rs)
);

//ID stage
assign ID_rs = (ID_instr[15:12] == 4'b1010) ? ID_rd :    //llb
	           (ID_instr[15:12] == 4'b1011) ? ID_rd :    //lhb
	   		    ID_instr[7:4]; 

assign ID_rt = ID_MemEnable ? ID_instr[11:8]:
              (ID_instr[15:12]==4'b0100)? ID_rd:    //sll
              (ID_instr[15:12]==4'b0101)? ID_rd:    //sra
              (ID_instr[15:12]==4'b0110)? ID_rd:    //ror
			   ID_instr[3:0];

assign ID_rd = ID_instr[11:8];

assign ID_Imm = (ID_instr[15:12] == 4'b1000) ? ({{12'b1{ID_instr[3]}},ID_instr[3:0]} << 1'b1) : //lw
                (ID_instr[15:12] == 4'b1001) ? ({{12'b1{ID_instr[3]}},ID_instr[3:0]} << 1'b1) : //sw
                (ID_instr[15:12] == 4'b1010) ? {8'b0,ID_instr[7:0]}: //llb
                (ID_instr[15:12] == 4'b1011) ? {ID_instr[7:0], 8'b0}: //lhb
                {{5'd12{1'b0}},ID_instr[3:0]};
                   
assign EX_aluB =(EX_ALUSrc) ? EX_Imm : EX_ReadData2;

//Forwarding Muxes

assign alu_in1 =(LoadToUse_rs) ? MEM_DataOut : 
                // (ForwardA == 2'b10) ? ((MEM_instr[15:12] == 4'b1000) ?  MEM_DataOut: MEM_AluResult) : 
                // (ForwardB == 2'b10) ? MEM_AluResult :
                (ForwardA == 2'b10) ? MEM_AluResult :
                (ForwardA == 2'b01) ?  WB_WriteData: 
                (EX_instr[15:12] == 4'b1110) ? EX_pc:
                EX_ReadData1;

assign alu_in2 =//(LoadToUse_rt) ? MEM_DataOut :
                (ForwardB == 2'b10) ? MEM_AluResult :
                (ForwardB == 2'b01) ? WB_WriteData :
                (EX_instr[15:12] == 4'b1110) ? 16'd2 :
                EX_aluB;
assign ID_ReadData2= LoadToSave ? MEM_DataOut : ID_ReadData2_rf;
            
assign WB_WriteData = (WB_MemtoReg) ? WB_MemDataOut : 
                       WB_AluResult;
assign MEM_DataIn = mem_to_mem ? WB_MemDataOut :
                    MEM_ReadData2;

assign stall_cache = Dcache_stall | Icache_stall;
//assign IF_instr = Icache_stall ? 16'h4000 : Cache_instr;
assign nop = (IF_instr === 16'h4000);
assign ID_Halt = (ID_instr[15:12] === 4'b1111);
                       
assign hlt = WB_Halt;
assign pc = IF_pc;
endmodule 
