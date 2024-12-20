module cache(
    input clk,
    input rst,
    
    input DataEnable, 
    input TagEnable,
    input way0,
    input way1,     // write way selection
    input [7:0] word_select,
    input [7:0] tag_in,
    input [15:0] data_in,
    input [63:0] SetEnable,

    output [7:0] tag_out0,
    output [7:0] tag_out1,
    output [15:0] data_out0,
    output [15:0] data_out1
);
    data_way_array way_0(
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .wen(DataEnable & way0),
        .set_enable(SetEnable),
        .word_enable(word_select),
        .data_out(data_out0)
    );

    data_way_array way_1(
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .wen(DataEnable & way1),
        .set_enable(SetEnable),
        .word_enable(word_select),
        .data_out(data_out1)
    );

    metadata_way_array way0_meta(
        .clk(clk),
        .rst(rst),
        .data_in(tag_in),
        .wen(TagEnable & way0),
        .set_enable(SetEnable),
        .tag_out(tag_out0)
    );

    metadata_way_array way1_meta(
        .clk(clk),
        .rst(rst),
        .data_in(tag_in),
        .wen(TagEnable & way1),
        .set_enable(SetEnable),
        .tag_out(tag_out1)
    );


endmodule