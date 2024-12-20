module register_file(
    input clk,
    input rst,
    input [3:0] src_reg1,
    input [3:0] src_reg2,
    input [3:0] dst_reg,
    input write_reg,
    input [15:0] dst_data,
    inout [15:0] src_data1,
    inout [15:0] src_data2
);
    wire [15:0] read_wordline1;
	wire [15:0] read_wordline2;
	wire [15:0] write_wordline;
    wire [15:0] bitline1_0,bitline1_1,bitline1_2,bitline1_3,bitline1_4,bitline1_5,bitline1_6,bitline1_7,bitline1_8,bitline1_9,bitline1_10,bitline1_11,bitline1_12,bitline1_13,bitline1_14,bitline1_15;
	wire [15:0] bitline2_0,bitline2_1,bitline2_2,bitline2_3,bitline2_4,bitline2_5,bitline2_6,bitline2_7,bitline2_8,bitline2_9,bitline2_10,bitline2_11,bitline2_12,bitline2_13,bitline2_14,bitline2_15;
    
    read_decoder_4_16 r1(.reg_id(src_reg1), .wordline(read_wordline1));
    read_decoder_4_16 r2(.reg_id(src_reg2), .wordline(read_wordline2));
    write_decoder_4_16 w1(.reg_id(dst_reg), .write_reg(write_reg), .wordline(write_wordline));

    register reg0(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[0]),
        .rden1(read_wordline1[0]),
        .rden2(read_wordline2[0]),
        .bitline1(bitline1_0),
        .bitline2(bitline2_0)
      );

    register reg1(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[1]),
        .rden1(read_wordline1[1]),
        .rden2(read_wordline2[1]),
        .bitline1(bitline1_1),
        .bitline2(bitline2_1)
      );
      
    register reg2(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[2]),
        .rden1(read_wordline1[2]),
        .rden2(read_wordline2[2]),
        .bitline1(bitline1_2),
        .bitline2(bitline2_2)
      );
      
    register reg3(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[3]),
        .rden1(read_wordline1[3]),
        .rden2(read_wordline2[3]),
        .bitline1(bitline1_3),
        .bitline2(bitline2_3)
      );
      
    register reg4(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[4]),
        .rden1(read_wordline1[4]),
        .rden2(read_wordline2[4]),
        .bitline1(bitline1_4),
        .bitline2(bitline2_4)
      );
      
    register reg5(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[5]),
        .rden1(read_wordline1[5]),
        .rden2(read_wordline2[5]),
        .bitline1(bitline1_5),
        .bitline2(bitline2_5)
      );
      
    register reg6(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[6]),
        .rden1(read_wordline1[6]),
        .rden2(read_wordline2[6]),
        .bitline1(bitline1_6),
        .bitline2(bitline2_6)
      );
      
    register reg7(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[7]),
        .rden1(read_wordline1[7]),
        .rden2(read_wordline2[7]),
        .bitline1(bitline1_7),
        .bitline2(bitline2_7)
      );
      
    register reg8(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[8]),
        .rden1(read_wordline1[8]),
        .rden2(read_wordline2[8]),
        .bitline1(bitline1_8),
        .bitline2(bitline2_8)
      );
      
    register reg9(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[9]),
        .rden1(read_wordline1[9]),
        .rden2(read_wordline2[9]),
        .bitline1(bitline1_9),
        .bitline2(bitline2_9)
      );
      
    register reg10(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[10]),
        .rden1(read_wordline1[10]),
        .rden2(read_wordline2[10]),
        .bitline1(bitline1_10),
        .bitline2(bitline2_10)
      );
      
    register reg11(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[11]),
        .rden1(read_wordline1[11]),
        .rden2(read_wordline2[11]),
        .bitline1(bitline1_11),
        .bitline2(bitline2_11)
      );
      
     register reg12(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[12]),
        .rden1(read_wordline1[12]),
        .rden2(read_wordline2[12]),
        .bitline1(bitline1_12),
        .bitline2(bitline2_12)
      );
      
    register reg13(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[13]),
        .rden1(read_wordline1[13]),
        .rden2(read_wordline2[13]),
        .bitline1(bitline1_13),
        .bitline2(bitline2_13)
      );
      
    register reg14(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[14]),
        .rden1(read_wordline1[14]),
        .rden2(read_wordline2[14]),
        .bitline1(bitline1_14),
        .bitline2(bitline2_14)
      );
      
    register reg15(
        .clk(clk),
        .rst(rst),
        .d(dst_data),
        .write_reg(write_wordline[15]),
        .rden1(read_wordline1[15]),
        .rden2(read_wordline2[15]),
        .bitline1(bitline1_15),
        .bitline2(bitline2_15)
      );

    assign src_data1 =  (write_reg && (dst_reg == src_reg1)) ? dst_data :
                        (read_wordline1[0]) ? 16'b0:
						(read_wordline1[1]) ? bitline1_1:
						(read_wordline1[2]) ? bitline1_2:
						(read_wordline1[3]) ? bitline1_3:
						(read_wordline1[4]) ? bitline1_4:
						(read_wordline1[5]) ? bitline1_5:
						(read_wordline1[6]) ? bitline1_6:
						(read_wordline1[7]) ? bitline1_7:
						(read_wordline1[8]) ? bitline1_8:
						(read_wordline1[9]) ? bitline1_9:
						(read_wordline1[10]) ? bitline1_10:
						(read_wordline1[11]) ? bitline1_11:
						(read_wordline1[12]) ? bitline1_12:
						(read_wordline1[13]) ? bitline1_13:
						(read_wordline1[14]) ? bitline1_14:
						(read_wordline1[15]) ? bitline1_15: 16'bz;
						
	assign src_data2 =  (write_reg && (dst_reg == src_reg2)) ? dst_data :
	                    (read_wordline2[0]) ? 16'b0:
						(read_wordline2[1]) ? bitline2_1:
						(read_wordline2[2]) ? bitline2_2:
						(read_wordline2[3]) ? bitline2_3:
						(read_wordline2[4]) ? bitline2_4:
						(read_wordline2[5]) ? bitline2_5:
						(read_wordline2[6]) ? bitline2_6:
						(read_wordline2[7]) ? bitline2_7:
						(read_wordline2[8]) ? bitline2_8:
						(read_wordline2[9]) ? bitline2_9:
						(read_wordline2[10]) ? bitline2_10:
						(read_wordline2[11]) ? bitline2_11:
						(read_wordline2[12]) ? bitline2_12:
						(read_wordline2[13]) ? bitline2_13:
						(read_wordline2[14]) ? bitline2_14:
						(read_wordline2[15]) ? bitline2_15: 16'bz;
endmodule