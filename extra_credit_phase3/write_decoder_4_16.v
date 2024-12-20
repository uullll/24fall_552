module write_decoder_4_16(
  input [3:0] reg_id,
  input write_reg,
  output [15:0] wordline
);
  
  wire [15:0] wordline_temp;
  assign wordline_temp[0]  = ~reg_id[3] & ~reg_id[2] & ~reg_id[1] & ~reg_id[0];
  assign wordline_temp[1]  = ~reg_id[3] & ~reg_id[2] & ~reg_id[1] &  reg_id[0];
  assign wordline_temp[2]  = ~reg_id[3] & ~reg_id[2] &  reg_id[1] & ~reg_id[0];
  assign wordline_temp[3]  = ~reg_id[3] & ~reg_id[2] &  reg_id[1] &  reg_id[0];
  assign wordline_temp[4]  = ~reg_id[3] &  reg_id[2] & ~reg_id[1] & ~reg_id[0];
  assign wordline_temp[5]  = ~reg_id[3] &  reg_id[2] & ~reg_id[1] &  reg_id[0];
  assign wordline_temp[6]  = ~reg_id[3] &  reg_id[2] &  reg_id[1] & ~reg_id[0];
  assign wordline_temp[7]  = ~reg_id[3] &  reg_id[2] &  reg_id[1] &  reg_id[0];
  assign wordline_temp[8]  =  reg_id[3] & ~reg_id[2] & ~reg_id[1] & ~reg_id[0];
  assign wordline_temp[9]  =  reg_id[3] & ~reg_id[2] & ~reg_id[1] &  reg_id[0];
  assign wordline_temp[10] =  reg_id[3] & ~reg_id[2] &  reg_id[1] & ~reg_id[0];
  assign wordline_temp[11] =  reg_id[3] & ~reg_id[2] &  reg_id[1] &  reg_id[0];
  assign wordline_temp[12] =  reg_id[3] &  reg_id[2] & ~reg_id[1] & ~reg_id[0];
  assign wordline_temp[13] =  reg_id[3] &  reg_id[2] & ~reg_id[1] &  reg_id[0];
  assign wordline_temp[14] =  reg_id[3] &  reg_id[2] &  reg_id[1] & ~reg_id[0];
  assign wordline_temp[15] =  reg_id[3] &  reg_id[2] &  reg_id[1] &  reg_id[0];

  assign wordline = write_reg ? wordline_temp : 16'b0;

endmodule