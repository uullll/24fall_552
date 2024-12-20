module Control_Unit(
	input [3:0] opcode,
	input rst,
	output  RegDst,
	output  Branch,
	output  MemRead,
	output  MemtoReg,
	output  MemWrite,
	output  ALUSrc,
	output  RegWrite,
	output  BranchReg,
	output  MemEnable,
	output  LoadUpper,
	output  PCSave,
	output  Halt,
	output  FLAG_Enable
);
         reg r_RegDst;
         reg r_Branch;
         reg r_MemRead;
         reg r_MemtoReg;
         reg r_MemWrite;
         reg r_ALUSrc;
         reg r_RegWrite;
	     reg r_BranchReg;
	     reg r_MemEnable;
	     reg r_LoadUpper;
	     reg r_PCSave;
	     reg r_Halt;
	     reg r_FLAG_Enable;

	always @(*) begin
        // Default values
          r_RegDst = 1'b0;
          r_Branch = 1'b0;
          r_MemRead = 1'b0;
          r_MemtoReg = 1'b0;
          r_MemWrite = 1'b0;
          r_ALUSrc = 1'b0;
          r_RegWrite = 1'b0;
	      r_BranchReg = 1'b0;
	      r_MemEnable = 1'b0;
	      r_LoadUpper =1'b0;
	      r_PCSave = 1'b0;
	      r_Halt = 1'b0;
	      r_FLAG_Enable = 1'b0;
	
      case(opcode)
        4'b0000: begin  	//add
                r_RegDst = 1'b1;
                r_RegWrite = 1'b1;
		        r_ALUSrc = 1'b0;
		        r_FLAG_Enable = 1'b1 && (~rst);
            end
 	    4'b0001: begin	//sub
                r_RegDst = 1'b1;
                r_RegWrite = 1'b1;
		        r_ALUSrc = 1'b0;
		        r_FLAG_Enable = 1'b1;
            end
	    4'b0010: begin	//xor
                r_RegDst = 1'b1;
                r_RegWrite = 1'b1;
		        r_ALUSrc = 1'b0;
		        r_FLAG_Enable = 1'b1;
            end
	    4'b0011: begin	//red
                r_RegDst = 1'b1;
                r_RegWrite = 1'b1;
		        r_ALUSrc = 1'b0;
				r_FLAG_Enable = 1'b0;
            end
	    4'b0111: begin	//paddsb
                r_RegDst = 1'b1;
                r_RegWrite = 1'b1;
		        r_ALUSrc = 1'b0;
				r_FLAG_Enable = 1'b0;
            end
	    4'b0100: begin	//sll
		        r_ALUSrc = 1'b1;
		        r_RegDst = 1'b1;
		        r_RegWrite = 1'b1;
		        r_FLAG_Enable = 1'b1;
	        end
	    4'b0101: begin	//sra
		        r_ALUSrc = 1'b1;
		        r_RegDst = 1'b1;
		        r_RegWrite = 1'b1;
		        r_FLAG_Enable = 1'b1;
	        end
	    4'b0110: begin	//ror
		        r_ALUSrc = 1'b1;
		        r_RegDst = 1'b1;
		        r_RegWrite = 1'b1;
		        r_FLAG_Enable = 1'b1;
	        end
	    4'b1000: begin	//lw
		        r_ALUSrc = 1'b1;
		        r_MemRead = 1'b1;
		        r_MemtoReg = 1'b1;
		        r_RegWrite = 1'b1;
		        r_MemEnable = 1'b1;
		        r_RegDst = 1'b1;
				r_FLAG_Enable = 1'b0;
	        end
	    4'b1001: begin	//sw
		        r_ALUSrc = 1'b1;
		        r_MemWrite = 1'b1;
		        r_MemEnable = 1'b1;
				r_FLAG_Enable = 1'b0;
	        end
	    4'b1010: begin 	//LLB
		        r_RegDst = 1'b1;
		        r_RegWrite = 1'b1;
		        r_ALUSrc = 1'b1;
				r_FLAG_Enable = 1'b0;
	        end
	    4'b1011: begin 	//LHB
		        r_RegDst = 1'b1;
		        r_RegWrite = 1'b1;
		        r_ALUSrc = 1'b1;
				r_FLAG_Enable = 1'b0;
	        end
	    4'b1100: begin 	//B
		        r_Branch = 1'b1;
		        r_BranchReg =1'b0;
				r_FLAG_Enable = 1'b0;
	        end	
	    4'b1101: begin	//BR
		        r_Branch = 1'b0;
		        r_BranchReg = 1'b1;
				r_FLAG_Enable = 1'b0;
	        end
	    4'b1110: begin	//PCS
		        r_RegWrite = 1'b1;
		        r_PCSave = 1'b1;
		        r_RegDst = 1'b1;
				r_FLAG_Enable = 1'b0;
	        end
	    4'b1111: begin	//HLT
		        r_Halt = 1'b1;
				r_RegDst = 1'b1;
				r_FLAG_Enable = 1'b0;
	        end
      endcase
    end
    assign  RegDst = r_RegDst;
	assign  Branch = r_Branch;
	assign  MemRead = r_MemRead;
	assign  MemtoReg = r_MemtoReg;
	assign  MemWrite = r_MemWrite;
	assign  ALUSrc = r_ALUSrc;
	assign  RegWrite = r_RegWrite;
	assign  BranchReg = r_BranchReg;
	assign  MemEnable = r_MemEnable;
	assign  LoadUpper = r_LoadUpper;
	assign  PCSave = r_PCSave;
	assign  Halt = r_Halt;
	assign FLAG_Enable = r_FLAG_Enable;
endmodule
