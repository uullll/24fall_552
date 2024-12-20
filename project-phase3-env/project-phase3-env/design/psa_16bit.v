module psa_16bit (
	input  [15:0] a, // input A
  	input  [15:0] b, // input B
  	output [15:0] sum // sum output 
);
	wire ovfl1, ovfl2, ovfl3, ovfl4;
	wire[15:0] temp_sum;
	wire[3:0] is_positive;
	wire[3:0] is_negative;
	wire positive_ovfl1, negative_ovfl1,positive_ovfl2, negative_ovfl2, positive_ovfl3, negative_ovfl3, positive_ovfl4, negative_ovfl4;
	
	assign is_negative[0] = a[3] & b[3];
	assign is_positive[0] = ~(a[3]|b[3]);
	assign is_negative[1] = a[7] & b[7];
	assign is_positive[1] = ~(a[7]|b[7]);
	assign is_negative[2] = a[11] & b[11];
	assign is_positive[2] = ~(a[11]|b[11]);
	assign is_negative[3] = a[15] & b[15];
	assign is_positive[3] = ~(a[15]|b[15]);

	
	CLA4 add1(.a(a[3:0]), .b(b[3:0]), .cin(1'b0), .sum(temp_sum[3:0]), .cout(), .ovfl(ovfl1), .tg(), .tp());
	assign positive_ovfl1 = is_positive[0] & ovfl1;
	assign negative_ovfl1 = is_negative[0] & ovfl1;
	assign sum[3:0] = positive_ovfl1 ? 4'b0111 :
	                  negative_ovfl1 ? 4'b1111 :
	                  temp_sum[3:0];
	                  
	CLA4 add2(.a(a[7:4]), .b(b[7:4]), .cin(1'b0), .sum(temp_sum[7:4]), .cout(), .ovfl(ovfl2), .tg(), .tp());
	assign positive_ovfl2 = is_positive[1] & ovfl2;
	assign negative_ovfl2 = is_negative[1] & ovfl2;
	assign sum[7:4] = positive_ovfl2 ? 4'b0111 :
	                  negative_ovfl2 ? 4'b1111 :
	                  temp_sum[7:4];
	                  
	CLA4 add3(.a(a[11:8]), .b(b[11:8]), .cin(1'b0), .sum(temp_sum[11:8]), .cout(), .ovfl(ovfl3), .tg(), .tp());
	assign positive_ovfl3 = is_positive[2] & ovfl3;
	assign negative_ovfl3 = is_negative[2] & ovfl3;
	assign sum[11:8] = positive_ovfl3 ? 4'b0111 :
	                   negative_ovfl3 ? 4'b1111 :
	                   temp_sum[11:8];
	                  
	CLA4 add4(.a(a[15:12]), .b(b[15:12]), .cin(1'b0), .sum(temp_sum[15:12]), .cout(), .ovfl(ovfl4), .tg(), .tp());
	assign positive_ovfl4 = is_positive[3] & ovfl4;
	assign negative_ovfl4 = is_negative[3] & ovfl4;
	assign sum[15:12] = positive_ovfl4 ? 4'b0111 :
	                    negative_ovfl4 ? 4'b1111 :
	                    temp_sum[15:12];

	

endmodule // psa_16bit
