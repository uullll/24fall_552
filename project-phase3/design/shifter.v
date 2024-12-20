module shifter (
	input [15:0]  shift_in,  // data to be shifted
	input [15:0]   shift_val, // shift amount
	input [1:0]   mode,      // 00==SLL, 01==SRA, 10==ROR
	output [15:0] shift_out  // data result of shift
);
	reg [5:0]cnt;
	wire [15:0]sll_row1, sll_row2, sll_row3;
	wire [15:0]sra_row1, sra_row2, sra_row3;
	wire [15:0]ror_row1, ror_row2, ror_row3;
	always @(*) begin
		case (shift_val[3:0])
			4'b0000:cnt=6'b00_00_00; //0
			4'b0001:cnt=6'b00_00_01; //1
			4'b0010:cnt=6'b00_00_10; //2
			4'b0011:cnt=6'b00_01_00; //3
			4'b0100:cnt=6'b00_01_01; //4
			4'b0101:cnt=6'b00_01_10; //5
			4'b0110:cnt=6'b00_10_00; //6
			4'b0111:cnt=6'b00_10_01; //7
			4'b1000:cnt=6'b00_10_10; //8
			4'b1001:cnt=6'b01_00_00; //9
			4'b1010:cnt=6'b01_00_01; //10
			4'b1011:cnt=6'b01_00_10; //11
			4'b1100:cnt=6'b01_01_00; //12
			4'b1101:cnt=6'b01_01_01; //13
			4'b1110:cnt=6'b01_01_10; //14
			4'b1111:cnt=6'b01_10_00; //15
		endcase
	end

	//sll 1,2
	mux_3_1 sll0 (.in0(shift_in[0]), .in1(1'b0), .in2(1'b0), .sel(cnt[1:0]), .out(sll_row1[0]));
	mux_3_1 sll1 (.in0(shift_in[1]), .in1(shift_in[0]), .in2(1'b0), .sel(cnt[1:0]), .out(sll_row1[1]));
	mux_3_1 sll2 (.in0(shift_in[2]), .in1(shift_in[1]), .in2(shift_in[0]), .sel(cnt[1:0]), .out(sll_row1[2]));
	mux_3_1 sll3 (.in0(shift_in[3]), .in1(shift_in[2]), .in2(shift_in[1]), .sel(cnt[1:0]), .out(sll_row1[3]));
	mux_3_1 sll4 (.in0(shift_in[4]), .in1(shift_in[3]), .in2(shift_in[2]), .sel(cnt[1:0]), .out(sll_row1[4]));
	mux_3_1 sll5 (.in0(shift_in[5]), .in1(shift_in[4]), .in2(shift_in[3]), .sel(cnt[1:0]), .out(sll_row1[5]));
	mux_3_1 sll6 (.in0(shift_in[6]), .in1(shift_in[5]), .in2(shift_in[4]), .sel(cnt[1:0]), .out(sll_row1[6]));
	mux_3_1 sll7 (.in0(shift_in[7]), .in1(shift_in[6]), .in2(shift_in[5]), .sel(cnt[1:0]), .out(sll_row1[7]));
	mux_3_1 sll8 (.in0(shift_in[8]), .in1(shift_in[7]), .in2(shift_in[6]), .sel(cnt[1:0]), .out(sll_row1[8]));
	mux_3_1 sll9 (.in0(shift_in[9]), .in1(shift_in[8]), .in2(shift_in[7]), .sel(cnt[1:0]), .out(sll_row1[9]));
	mux_3_1 sll10 (.in0(shift_in[10]), .in1(shift_in[9]), .in2(shift_in[8]), .sel(cnt[1:0]), .out(sll_row1[10]));
	mux_3_1 sll11 (.in0(shift_in[11]), .in1(shift_in[10]), .in2(shift_in[9]), .sel(cnt[1:0]), .out(sll_row1[11]));
	mux_3_1 sll12 (.in0(shift_in[12]), .in1(shift_in[11]), .in2(shift_in[10]), .sel(cnt[1:0]), .out(sll_row1[12]));
	mux_3_1 sll13 (.in0(shift_in[13]), .in1(shift_in[12]), .in2(shift_in[11]), .sel(cnt[1:0]), .out(sll_row1[13]));
	mux_3_1 sll14 (.in0(shift_in[14]), .in1(shift_in[13]), .in2(shift_in[12]), .sel(cnt[1:0]), .out(sll_row1[14]));
	mux_3_1 sll15 (.in0(shift_in[15]), .in1(shift_in[14]), .in2(shift_in[13]), .sel(cnt[1:0]), .out(sll_row1[15]));

	
	//sll 3,6
	mux_3_1 sll16 (.in0(sll_row1[0]), .in1(1'b0), .in2(1'b0), .sel(cnt[3:2]), .out(sll_row2[0]));
	mux_3_1 sll17 (.in0(sll_row1[1]), .in1(1'b0), .in2(1'b0), .sel(cnt[3:2]), .out(sll_row2[1]));
	mux_3_1 sll18 (.in0(sll_row1[2]), .in1(1'b0), .in2(1'b0), .sel(cnt[3:2]), .out(sll_row2[2]));
	mux_3_1 sll19 (.in0(sll_row1[3]), .in1(sll_row1[0]), .in2(1'b0), .sel(cnt[3:2]), .out(sll_row2[3]));
	mux_3_1 sll20 (.in0(sll_row1[4]), .in1(sll_row1[1]), .in2(1'b0), .sel(cnt[3:2]), .out(sll_row2[4]));
	mux_3_1 sll21 (.in0(sll_row1[5]), .in1(sll_row1[2]), .in2(1'b0), .sel(cnt[3:2]), .out(sll_row2[5]));
	mux_3_1 sll22 (.in0(sll_row1[6]), .in1(sll_row1[3]), .in2(sll_row1[0]), .sel(cnt[3:2]), .out(sll_row2[6]));
	mux_3_1 sll23 (.in0(sll_row1[7]), .in1(sll_row1[4]), .in2(sll_row1[1]), .sel(cnt[3:2]), .out(sll_row2[7]));
	mux_3_1 sll24 (.in0(sll_row1[8]), .in1(sll_row1[5]), .in2(sll_row1[2]), .sel(cnt[3:2]), .out(sll_row2[8]));
	mux_3_1 sll25 (.in0(sll_row1[9]), .in1(sll_row1[6]), .in2(sll_row1[3]), .sel(cnt[3:2]), .out(sll_row2[9]));
	mux_3_1 sll26 (.in0(sll_row1[10]), .in1(sll_row1[7]), .in2(sll_row1[4]), .sel(cnt[3:2]), .out(sll_row2[10]));
	mux_3_1 sll27 (.in0(sll_row1[11]), .in1(sll_row1[8]), .in2(sll_row1[5]), .sel(cnt[3:2]), .out(sll_row2[11]));
	mux_3_1 sll28 (.in0(sll_row1[12]), .in1(sll_row1[9]), .in2(sll_row1[6]), .sel(cnt[3:2]), .out(sll_row2[12]));
	mux_3_1 sll29 (.in0(sll_row1[13]), .in1(sll_row1[10]), .in2(sll_row1[7]), .sel(cnt[3:2]), .out(sll_row2[13]));
	mux_3_1 sll30 (.in0(sll_row1[14]), .in1(sll_row1[11]), .in2(sll_row1[8]), .sel(cnt[3:2]), .out(sll_row2[14]));
	mux_3_1 sll31 (.in0(sll_row1[15]), .in1(sll_row1[12]), .in2(sll_row1[9]), .sel(cnt[3:2]), .out(sll_row2[15]));
	
	//sll 9,18
	mux_3_1 sll32 (.in0(sll_row2[0]), .in1(1'b0), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[0]));
	mux_3_1 sll33 (.in0(sll_row2[1]), .in1(1'b0), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[1]));
	mux_3_1 sll34 (.in0(sll_row2[2]), .in1(1'b0), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[2]));
	mux_3_1 sll35 (.in0(sll_row2[3]), .in1(1'b0), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[3]));
	mux_3_1 sll36 (.in0(sll_row2[4]), .in1(1'b0), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[4]));
	mux_3_1 sll37 (.in0(sll_row2[5]), .in1(1'b0), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[5]));
	mux_3_1 sll38 (.in0(sll_row2[6]), .in1(1'b0), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[6]));
	mux_3_1 sll39 (.in0(sll_row2[7]), .in1(1'b0), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[7]));
	mux_3_1 sll40 (.in0(sll_row2[8]), .in1(1'b0), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[8]));
	mux_3_1 sll41 (.in0(sll_row2[9]), .in1(sll_row2[0]), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[9]));
	mux_3_1 sll42 (.in0(sll_row2[10]), .in1(sll_row2[1]), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[10]));
	mux_3_1 sll43 (.in0(sll_row2[11]), .in1(sll_row2[2]), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[11]));
	mux_3_1 sll44 (.in0(sll_row2[12]), .in1(sll_row2[3]), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[12]));
	mux_3_1 sll45 (.in0(sll_row2[13]), .in1(sll_row2[4]), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[13]));
	mux_3_1 sll46 (.in0(sll_row2[14]), .in1(sll_row2[5]), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[14]));
	mux_3_1 sll47 (.in0(sll_row2[15]), .in1(sll_row2[6]), .in2(1'b0), .sel(cnt[5:4]), .out(sll_row3[15]));

	//sra 1,2
	mux_3_1 sra0 (.in0(shift_in[0]), .in1(shift_in[1]), .in2(shift_in[2]), .sel(cnt[1:0]), .out(sra_row1[0]));
	mux_3_1 sra1 (.in0(shift_in[1]), .in1(shift_in[2]), .in2(shift_in[3]), .sel(cnt[1:0]), .out(sra_row1[1]));
	mux_3_1 sra2 (.in0(shift_in[2]), .in1(shift_in[3]), .in2(shift_in[4]), .sel(cnt[1:0]), .out(sra_row1[2]));
	mux_3_1 sra3 (.in0(shift_in[3]), .in1(shift_in[4]), .in2(shift_in[5]), .sel(cnt[1:0]), .out(sra_row1[3]));
	mux_3_1 sra4 (.in0(shift_in[4]), .in1(shift_in[5]), .in2(shift_in[6]), .sel(cnt[1:0]), .out(sra_row1[4]));
	mux_3_1 sra5 (.in0(shift_in[5]), .in1(shift_in[6]), .in2(shift_in[7]), .sel(cnt[1:0]), .out(sra_row1[5]));
	mux_3_1 sra6 (.in0(shift_in[6]), .in1(shift_in[7]), .in2(shift_in[8]), .sel(cnt[1:0]), .out(sra_row1[6]));
	mux_3_1 sra7 (.in0(shift_in[7]), .in1(shift_in[8]), .in2(shift_in[9]), .sel(cnt[1:0]), .out(sra_row1[7]));
	mux_3_1 sra8 (.in0(shift_in[8]), .in1(shift_in[9]), .in2(shift_in[10]), .sel(cnt[1:0]), .out(sra_row1[8]));
	mux_3_1 sra9 (.in0(shift_in[9]), .in1(shift_in[10]), .in2(shift_in[11]), .sel(cnt[1:0]), .out(sra_row1[9]));
	mux_3_1 sra10 (.in0(shift_in[10]), .in1(shift_in[11]), .in2(shift_in[12]), .sel(cnt[1:0]), .out(sra_row1[10]));
	mux_3_1 sra11 (.in0(shift_in[11]), .in1(shift_in[12]), .in2(shift_in[13]), .sel(cnt[1:0]), .out(sra_row1[11]));
	mux_3_1 sra12 (.in0(shift_in[12]), .in1(shift_in[13]), .in2(shift_in[14]), .sel(cnt[1:0]), .out(sra_row1[12]));
	mux_3_1 sra13 (.in0(shift_in[13]), .in1(shift_in[14]), .in2(shift_in[15]), .sel(cnt[1:0]), .out(sra_row1[13]));
	mux_3_1 sra14 (.in0(shift_in[14]), .in1(shift_in[15]), .in2(shift_in[15]), .sel(cnt[1:0]), .out(sra_row1[14]));
	mux_3_1 sra15 (.in0(shift_in[15]), .in1(shift_in[15]), .in2(shift_in[15]), .sel(cnt[1:0]), .out(sra_row1[15]));

	//sra 3,6
	mux_3_1 sra16 (.in0(sra_row1[0]), .in1(sra_row1[3]), .in2(sra_row1[6]), .sel(cnt[3:2]), .out(sra_row2[0]));
	mux_3_1 sra17 (.in0(sra_row1[1]), .in1(sra_row1[4]), .in2(sra_row1[7]), .sel(cnt[3:2]), .out(sra_row2[1]));
	mux_3_1 sra18 (.in0(sra_row1[2]), .in1(sra_row1[5]), .in2(sra_row1[8]), .sel(cnt[3:2]), .out(sra_row2[2]));
	mux_3_1 sra19 (.in0(sra_row1[3]), .in1(sra_row1[6]), .in2(sra_row1[9]), .sel(cnt[3:2]), .out(sra_row2[3]));
	mux_3_1 sra20 (.in0(sra_row1[4]), .in1(sra_row1[7]), .in2(sra_row1[10]), .sel(cnt[3:2]), .out(sra_row2[4]));
	mux_3_1 sra21 (.in0(sra_row1[5]), .in1(sra_row1[8]), .in2(sra_row1[11]), .sel(cnt[3:2]), .out(sra_row2[5]));
	mux_3_1 sra22 (.in0(sra_row1[6]), .in1(sra_row1[9]), .in2(sra_row1[12]), .sel(cnt[3:2]), .out(sra_row2[6]));
	mux_3_1 sra23 (.in0(sra_row1[7]), .in1(sra_row1[10]), .in2(sra_row1[13]), .sel(cnt[3:2]), .out(sra_row2[7]));
	mux_3_1 sra24 (.in0(sra_row1[8]), .in1(sra_row1[11]), .in2(sra_row1[14]), .sel(cnt[3:2]), .out(sra_row2[8]));
	mux_3_1 sra25 (.in0(sra_row1[9]), .in1(sra_row1[12]), .in2(sra_row1[15]), .sel(cnt[3:2]), .out(sra_row2[9]));
	mux_3_1 sra26 (.in0(sra_row1[10]), .in1(sra_row1[13]), .in2(sra_row1[15]), .sel(cnt[3:2]), .out(sra_row2[10]));
	mux_3_1 sra27 (.in0(sra_row1[11]), .in1(sra_row1[14]), .in2(sra_row1[15]), .sel(cnt[3:2]), .out(sra_row2[11]));
	mux_3_1 sra28 (.in0(sra_row1[12]), .in1(sra_row1[15]), .in2(sra_row1[15]), .sel(cnt[3:2]), .out(sra_row2[12]));
	mux_3_1 sra29 (.in0(sra_row1[13]), .in1(sra_row1[15]), .in2(sra_row1[15]), .sel(cnt[3:2]), .out(sra_row2[13]));
	mux_3_1 sra30 (.in0(sra_row1[14]), .in1(sra_row1[15]), .in2(sra_row1[15]), .sel(cnt[3:2]), .out(sra_row2[14]));
	mux_3_1 sra31 (.in0(sra_row1[15]), .in1(sra_row1[15]), .in2(sra_row1[15]), .sel(cnt[3:2]), .out(sra_row2[15]));

	//sra 9,18
	mux_3_1 sra32 (.in0(sra_row2[0]), .in1(sra_row2[9]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[0]));
	mux_3_1 sra33 (.in0(sra_row2[1]), .in1(sra_row2[10]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[1]));
	mux_3_1 sra34 (.in0(sra_row2[2]), .in1(sra_row2[11]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[2]));
	mux_3_1 sra35 (.in0(sra_row2[3]), .in1(sra_row2[12]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[3]));
	mux_3_1 sra36 (.in0(sra_row2[4]), .in1(sra_row2[13]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[4]));
	mux_3_1 sra37 (.in0(sra_row2[5]), .in1(sra_row2[14]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[5]));
	mux_3_1 sra38 (.in0(sra_row2[6]), .in1(sra_row2[15]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[6]));
	mux_3_1 sra39 (.in0(sra_row2[7]), .in1(sra_row2[15]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[7]));
	mux_3_1 sra40 (.in0(sra_row2[8]), .in1(sra_row2[15]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[8]));
	mux_3_1 sra41 (.in0(sra_row2[9]), .in1(sra_row2[15]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[9]));
	mux_3_1 sra42 (.in0(sra_row2[10]), .in1(sra_row2[15]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[10]));
	mux_3_1 sra43 (.in0(sra_row2[11]), .in1(sra_row2[15]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[11]));
	mux_3_1 sra44 (.in0(sra_row2[12]), .in1(sra_row2[15]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[12]));
	mux_3_1 sra45 (.in0(sra_row2[13]), .in1(sra_row2[15]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[13]));
	mux_3_1 sra46 (.in0(sra_row2[14]), .in1(sra_row2[15]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[14]));
	mux_3_1 sra47 (.in0(sra_row2[15]), .in1(sra_row2[15]), .in2(sra_row2[15]), .sel(cnt[5:4]), .out(sra_row3[15]));
	
	//ror 1,2
	mux_3_1 ror0 (.in0(shift_in[0]), .in1(shift_in[1]), .in2(shift_in[2]), .sel(cnt[1:0]), .out(ror_row1[0]));
	mux_3_1 ror1 (.in0(shift_in[1]), .in1(shift_in[2]), .in2(shift_in[3]), .sel(cnt[1:0]), .out(ror_row1[1]));
	mux_3_1 ror2 (.in0(shift_in[2]), .in1(shift_in[3]), .in2(shift_in[4]), .sel(cnt[1:0]), .out(ror_row1[2]));
	mux_3_1 ror3 (.in0(shift_in[3]), .in1(shift_in[4]), .in2(shift_in[5]), .sel(cnt[1:0]), .out(ror_row1[3]));
	mux_3_1 ror4 (.in0(shift_in[4]), .in1(shift_in[5]), .in2(shift_in[6]), .sel(cnt[1:0]), .out(ror_row1[4]));
	mux_3_1 ror5 (.in0(shift_in[5]), .in1(shift_in[6]), .in2(shift_in[7]), .sel(cnt[1:0]), .out(ror_row1[5]));
	mux_3_1 ror6 (.in0(shift_in[6]), .in1(shift_in[7]), .in2(shift_in[8]), .sel(cnt[1:0]), .out(ror_row1[6]));
	mux_3_1 ror7 (.in0(shift_in[7]), .in1(shift_in[8]), .in2(shift_in[9]), .sel(cnt[1:0]), .out(ror_row1[7]));
	mux_3_1 ror8 (.in0(shift_in[8]), .in1(shift_in[9]), .in2(shift_in[10]), .sel(cnt[1:0]), .out(ror_row1[8]));
	mux_3_1 ror9 (.in0(shift_in[9]), .in1(shift_in[10]), .in2(shift_in[11]), .sel(cnt[1:0]), .out(ror_row1[9]));
	mux_3_1 ror10 (.in0(shift_in[10]), .in1(shift_in[11]), .in2(shift_in[12]), .sel(cnt[1:0]), .out(ror_row1[10]));
	mux_3_1 ror11 (.in0(shift_in[11]), .in1(shift_in[12]), .in2(shift_in[13]), .sel(cnt[1:0]), .out(ror_row1[11]));
	mux_3_1 ror12 (.in0(shift_in[12]), .in1(shift_in[13]), .in2(shift_in[14]), .sel(cnt[1:0]), .out(ror_row1[12]));
	mux_3_1 ror13 (.in0(shift_in[13]), .in1(shift_in[14]), .in2(shift_in[15]), .sel(cnt[1:0]), .out(ror_row1[13]));
	mux_3_1 ror14 (.in0(shift_in[14]), .in1(shift_in[15]), .in2(shift_in[0]), .sel(cnt[1:0]), .out(ror_row1[14]));
	mux_3_1 ror15 (.in0(shift_in[15]), .in1(shift_in[0]), .in2(shift_in[1]), .sel(cnt[1:0]), .out(ror_row1[15]));

	//ror 3,6
	mux_3_1 ror16 (.in0(ror_row1[0]), .in1(ror_row1[3]), .in2(ror_row1[6]), .sel(cnt[3:2]), .out(ror_row2[0]));
	mux_3_1 ror17 (.in0(ror_row1[1]), .in1(ror_row1[4]), .in2(ror_row1[7]), .sel(cnt[3:2]), .out(ror_row2[1]));
	mux_3_1 ror18 (.in0(ror_row1[2]), .in1(ror_row1[5]), .in2(ror_row1[8]), .sel(cnt[3:2]), .out(ror_row2[2]));
	mux_3_1 ror19 (.in0(ror_row1[3]), .in1(ror_row1[6]), .in2(ror_row1[9]), .sel(cnt[3:2]), .out(ror_row2[3]));
	mux_3_1 ror20 (.in0(ror_row1[4]), .in1(ror_row1[7]), .in2(ror_row1[10]), .sel(cnt[3:2]), .out(ror_row2[4]));
	mux_3_1 ror21 (.in0(ror_row1[5]), .in1(ror_row1[8]), .in2(ror_row1[11]), .sel(cnt[3:2]), .out(ror_row2[5]));
	mux_3_1 ror22 (.in0(ror_row1[6]), .in1(ror_row1[9]), .in2(ror_row1[12]), .sel(cnt[3:2]), .out(ror_row2[6]));
	mux_3_1 ror23 (.in0(ror_row1[7]), .in1(ror_row1[10]), .in2(ror_row1[13]), .sel(cnt[3:2]), .out(ror_row2[7]));
	mux_3_1 ror24 (.in0(ror_row1[8]), .in1(ror_row1[11]), .in2(ror_row1[14]), .sel(cnt[3:2]), .out(ror_row2[8]));
	mux_3_1 ror25 (.in0(ror_row1[9]), .in1(ror_row1[12]), .in2(ror_row1[15]), .sel(cnt[3:2]), .out(ror_row2[9]));
	mux_3_1 ror26 (.in0(ror_row1[10]), .in1(ror_row1[13]), .in2(ror_row1[0]), .sel(cnt[3:2]), .out(ror_row2[10]));
	mux_3_1 ror27 (.in0(ror_row1[11]), .in1(ror_row1[14]), .in2(ror_row1[1]), .sel(cnt[3:2]), .out(ror_row2[11]));
	mux_3_1 ror28 (.in0(ror_row1[12]), .in1(ror_row1[15]), .in2(ror_row1[2]), .sel(cnt[3:2]), .out(ror_row2[12]));
	mux_3_1 ror29 (.in0(ror_row1[13]), .in1(ror_row1[0]), .in2(ror_row1[3]), .sel(cnt[3:2]), .out(ror_row2[13]));
	mux_3_1 ror30 (.in0(ror_row1[14]), .in1(ror_row1[1]), .in2(ror_row1[4]), .sel(cnt[3:2]), .out(ror_row2[14]));
	mux_3_1 ror31 (.in0(ror_row1[15]), .in1(ror_row1[2]), .in2(ror_row1[5]), .sel(cnt[3:2]), .out(ror_row2[15]));

	//ror 9,18
	mux_3_1 ror32 (.in0(ror_row2[0]), .in1(ror_row2[9]), .in2(ror_row2[3]), .sel(cnt[5:4]), .out(ror_row3[0]));
	mux_3_1 ror33 (.in0(ror_row2[1]), .in1(ror_row2[10]), .in2(ror_row2[4]), .sel(cnt[5:4]), .out(ror_row3[1]));
	mux_3_1 ror34 (.in0(ror_row2[2]), .in1(ror_row2[11]), .in2(ror_row2[5]), .sel(cnt[5:4]), .out(ror_row3[2]));
	mux_3_1 ror35 (.in0(ror_row2[3]), .in1(ror_row2[12]), .in2(ror_row2[6]), .sel(cnt[5:4]), .out(ror_row3[3]));
	mux_3_1 ror36 (.in0(ror_row2[4]), .in1(ror_row2[13]), .in2(ror_row2[7]), .sel(cnt[5:4]), .out(ror_row3[4]));
	mux_3_1 ror37 (.in0(ror_row2[5]), .in1(ror_row2[14]), .in2(ror_row2[8]), .sel(cnt[5:4]), .out(ror_row3[5]));
	mux_3_1 ror38 (.in0(ror_row2[6]), .in1(ror_row2[15]), .in2(ror_row2[9]), .sel(cnt[5:4]), .out(ror_row3[6]));
	mux_3_1 ror39 (.in0(ror_row2[7]), .in1(ror_row2[0]), .in2(ror_row2[10]), .sel(cnt[5:4]), .out(ror_row3[7]));
	mux_3_1 ror40 (.in0(ror_row2[8]), .in1(ror_row2[1]), .in2(ror_row2[11]), .sel(cnt[5:4]), .out(ror_row3[8]));
	mux_3_1 ror41 (.in0(ror_row2[9]), .in1(ror_row2[2]), .in2(ror_row2[12]), .sel(cnt[5:4]), .out(ror_row3[9]));
	mux_3_1 ror42 (.in0(ror_row2[10]), .in1(ror_row2[3]), .in2(ror_row2[13]), .sel(cnt[5:4]), .out(ror_row3[10]));
	mux_3_1 ror43 (.in0(ror_row2[11]), .in1(ror_row2[4]), .in2(ror_row2[14]), .sel(cnt[5:4]), .out(ror_row3[11]));
	mux_3_1 ror44 (.in0(ror_row2[12]), .in1(ror_row2[5]), .in2(ror_row2[15]), .sel(cnt[5:4]), .out(ror_row3[12]));
	mux_3_1 ror45 (.in0(ror_row2[13]), .in1(ror_row2[6]), .in2(ror_row2[0]), .sel(cnt[5:4]), .out(ror_row3[13]));
	mux_3_1 ror46 (.in0(ror_row2[14]), .in1(ror_row2[7]), .in2(ror_row2[1]), .sel(cnt[5:4]), .out(ror_row3[14]));
	mux_3_1 ror47 (.in0(ror_row2[15]), .in1(ror_row2[8]), .in2(ror_row2[2]), .sel(cnt[5:4]), .out(ror_row3[15]));

	//res mux
	mux_3_1 res0(.in0(sll_row3[0]), .in1(sra_row3[0]), .in2(ror_row3[0]), .sel(mode), .out(shift_out[0]));
	mux_3_1 res1(.in0(sll_row3[1]), .in1(sra_row3[1]), .in2(ror_row3[1]), .sel(mode), .out(shift_out[1]));
	mux_3_1 res2(.in0(sll_row3[2]), .in1(sra_row3[2]), .in2(ror_row3[2]), .sel(mode), .out(shift_out[2]));
	mux_3_1 res3(.in0(sll_row3[3]), .in1(sra_row3[3]), .in2(ror_row3[3]), .sel(mode), .out(shift_out[3]));
	mux_3_1 res4(.in0(sll_row3[4]), .in1(sra_row3[4]), .in2(ror_row3[4]), .sel(mode), .out(shift_out[4]));
	mux_3_1 res5(.in0(sll_row3[5]), .in1(sra_row3[5]), .in2(ror_row3[5]), .sel(mode), .out(shift_out[5]));
	mux_3_1 res6(.in0(sll_row3[6]), .in1(sra_row3[6]), .in2(ror_row3[6]), .sel(mode), .out(shift_out[6]));
	mux_3_1 res7(.in0(sll_row3[7]), .in1(sra_row3[7]), .in2(ror_row3[7]), .sel(mode), .out(shift_out[7]));
	mux_3_1 res8(.in0(sll_row3[8]), .in1(sra_row3[8]), .in2(ror_row3[8]), .sel(mode), .out(shift_out[8]));
	mux_3_1 res9(.in0(sll_row3[9]), .in1(sra_row3[9]), .in2(ror_row3[9]), .sel(mode), .out(shift_out[9]));
	mux_3_1 res10(.in0(sll_row3[10]), .in1(sra_row3[10]), .in2(ror_row3[10]), .sel(mode), .out(shift_out[10]));
	mux_3_1 res11(.in0(sll_row3[11]), .in1(sra_row3[11]), .in2(ror_row3[11]), .sel(mode), .out(shift_out[11]));
	mux_3_1 res12(.in0(sll_row3[12]), .in1(sra_row3[12]), .in2(ror_row3[12]), .sel(mode), .out(shift_out[12]));
	mux_3_1 res13(.in0(sll_row3[13]), .in1(sra_row3[13]), .in2(ror_row3[13]), .sel(mode), .out(shift_out[13]));
	mux_3_1 res14(.in0(sll_row3[14]), .in1(sra_row3[14]), .in2(ror_row3[14]), .sel(mode), .out(shift_out[14]));
	mux_3_1 res15(.in0(sll_row3[15]), .in1(sra_row3[15]), .in2(ror_row3[15]), .sel(mode), .out(shift_out[15]));


endmodule
	