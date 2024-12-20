module register(
  input clk,
  input rst,
  input [15:0] d,
  input write_reg,
  input rden1,
  input rden2,
  inout [15:0] bitline1,
  inout [15:0] bitline2
  );

    reg [15:0] data_out;
      always@(posedge clk)
	begin
		if(!rst)
			data_out<=16'b0;
		else if(write_reg)
			data_out<=d;
	end
	
	assign bitline1 = rden1 ? data_out : 16'bz;
        assign bitline2 = rden2 ? data_out : 16'bz;
    

endmodule
