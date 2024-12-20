module pc_control(
    input [2:0] c,
    input [8:0] i, 
    input [2:0] f,
    input Branch,
    input BranchReg,
    input Halt, 
    input [15:0] Rs_data,
    input [15:0] pc_in, 
    output [15:0] pc_out,
    output reg Branch_taken
);
    wire [15:0] offset;
    wire [15:0] target;
    wire [15:0] pc_next;
    wire FLAG_Z, FLAG_V, FLAG_N;
    reg [15:0] next_pc;

    assign {FLAG_Z,FLAG_V,FLAG_N} = f;
    assign offset = {{7{i[8]}}, i} << 1;
    
    // Calculate PC+2
    adder_sub_16bit pc_add(.a(pc_in), .b(16'd2), .is_sub(1'b0), .sum(pc_next), .ovfl());
    // Calculate branch target
    adder_sub_16bit target_add(.a(pc_in), .b(offset), .is_sub(1'b0), .sum(target), .ovfl());

    // Branch taken logic
    reg Branch_cond;
    always @(*) begin
            case(c)
                    3'b000: Branch_cond = ~FLAG_Z;
                    3'b001: Branch_cond = FLAG_Z;
                    3'b010: Branch_cond = ~FLAG_Z & ~FLAG_N;
                    3'b011: Branch_cond = FLAG_N;
                    3'b100: Branch_cond = FLAG_N | (~FLAG_Z & ~FLAG_N);
                    3'b101: Branch_cond = FLAG_N | FLAG_Z;
                    3'b110: Branch_cond = FLAG_V;
                    3'b111: Branch_cond = 1'b1;
                    default: Branch_cond = 1'b0;
            endcase
            end

    always @(*) begin
        case ({Branch, BranchReg})
            2'b10: Branch_taken = Branch_cond;
            2'b01: Branch_taken = Branch_cond;
            default: Branch_taken = 1'b0;
        endcase
    end

    // Next PC selection
    always @(*) begin
                case({BranchReg, Branch, Branch_taken})
                    3'b000: next_pc = pc_next;
                    3'b001: next_pc = pc_next;
                    3'b010: next_pc = pc_next;
                    3'b011: next_pc = target;
                    3'b100: next_pc = pc_next;
                    3'b101: next_pc = Rs_data;
                    3'b110: next_pc = pc_next;
                    3'b111: next_pc = pc_next;
                    default: next_pc = pc_next;
                endcase
    end

    wire [15:0]pc_target;
    assign pc_target = Halt ? pc_in : next_pc;
  
    assign pc_out = pc_target;

endmodule 