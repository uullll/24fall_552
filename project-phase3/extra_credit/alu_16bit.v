module alu_16bit(
	input [15:0] alu_in1,
	input [15:0] alu_in2,
	input [3:0] opcode,
	output [15:0] alu_out,
	output zero,
	output reg err
);
	wire [15:0] temp_addsub_result, addsub_result, xor_result, paddsb_result, red_result, shift_result, pcs_result;
	wire [1:0]mode;
	wire ovfl1,ovfl2,ovfl3;
	wire add_is_positive, sub_is_positive, add_is_negative, sub_is_negative;
	wire positive_ovfl1, positive_ovfl2;
	wire negative_ovfl1, negative_ovfl2;
	wire [15:0]	llb_result, lhb_result;	
    //
    adder_sub_16bit addsub(.a(alu_in1), .b(alu_in2), .is_sub(opcode[0]), .sum(temp_addsub_result), .ovfl(ovfl1));
	assign positive_ovfl1 = (~alu_in1[15]) & (~alu_in2[15]) & temp_addsub_result[15] ;
	assign negative_ovfl1 = alu_in1[15] & alu_in2[15] & (~temp_addsub_result[15]);
	assign addsub_result = positive_ovfl1 ? 16'b0111111111111111 :
	                    negative_ovfl1 ? 16'b1000000000000000 :
	                    temp_add_result;
    //
	assign xor_result = alu_in1^alu_in2;
	//
	psa_16bit psa(.a(alu_in1), .b(alu_in2), .sum(paddsb_result));
	RED red1(.rs(alu_in1), .rt(alu_in2), .rd(red_result), .ovfl(ovfl3));
	assign mode = (opcode == 4'b0100) ? 2'b00: //sll   
	              (opcode == 4'b0101) ? 2'b01: //sra
	              2'b10;                       //ror
	           
	shifter shift(.shift_in(alu_in1), .shift_val(alu_in2), .mode(mode), .shift_out(shift_result));           

	assign	llb_result = (opcode == 4'b1010) ? ((alu_in1 & 16'hff00)| alu_in2): 16'b0;//llb
    assign  lhb_result = (opcode == 4'b1011) ? ((alu_in1 & 16'h00ff)| alu_in2): 16'b0;//lhb

	assign alu_out = (opcode == 4'b0000) ? addsub_result:
	         (opcode == 4'b1110) ? addsub_result: //PCS
			 (opcode == 4'b0001) ? addsub_result:
			 (opcode == 4'b0010) ? xor_result:
			 (opcode == 4'b0011) ? red_result:
			 (opcode == 4'b0111) ? paddsb_result:
			 (opcode == 4'b1000) ? addsub_result:
			 (opcode == 4'b1001) ? addsub_result:
			 (opcode == 4'b1010) ? llb_result:   // LLB - pass through the calculated value
             (opcode == 4'b1011) ? lhb_result:   // LHB - pass through the calculated value
			 shift_result;
    assign zero = (alu_out == 16'b0) ? 1'b1 : 1'b0;
	always@(*)
		begin
			err=0;
			case(ovfl1|ovfl2|ovfl3)
				1'b1:err=1;
				1'b0:err=0;
			endcase

		end
	
endmodule