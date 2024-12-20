module one_hot_8 (
    input [2:0] offset,
    output [7:0] word_select
);
    assign word_select =(offset == 3'b000) ? 8'b00000001 :
                        (offset == 3'b001) ? 8'b00000010 :
                        (offset == 3'b010) ? 8'b00000100 :
                        (offset == 3'b011) ? 8'b00001000 :
                        (offset == 3'b100) ? 8'b00010000 :
                        (offset == 3'b101) ? 8'b00100000 :
                        (offset == 3'b110) ? 8'b01000000 :
                        (offset == 3'b111) ? 8'b10000000 :
                        8'b00000000;
endmodule

module one_hot_64(
    input [5:0] offset,
    output [63:0] set_enable
);
    wire [63:0] shift_source = 64'd1;
    wire [63:0] stage1, stage2, stage3, stage4, stage5, stage6;

    assign stage1 = (offset[0] == 1) ? (shift_source << 1) : shift_source;
    assign stage2 = (offset[1] == 1) ? (stage1 << 2) : stage1;
    assign stage3 = (offset[2] == 1) ? (stage2 << 4) : stage2;
    assign stage4 = (offset[3] == 1) ? (stage3 << 8) : stage3;
    assign stage5 = (offset[4] == 1) ? (stage4 << 16) : stage4;
    assign stage6 = (offset[5] == 1) ? (stage5 << 32) : stage5;

    assign set_enable = stage6;
endmodule