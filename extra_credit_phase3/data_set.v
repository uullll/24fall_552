module data_set (
    input clk,
    input rst,
    input [15:0] data_in,
    input wen,
    input enable,
    input [7:0] word_enable,
    output [15:0] data_out
);
  wire [7:0] set_and_word_enable = {8{enable}} & word_enable;

  cache_word #(
      .WIDTH(16)
  ) words[7:0] (
      .clk(clk),
      .rst(rst),
      .data_in(data_in),
      .wen(wen),
      .enable(set_and_word_enable),
      .data_out(data_out)
  );
  /*
  reg [15:0] words[7:0];
  
  always@(posedge clk)
	begin
		if(!enable)
			data_out<=16'bz;
		else
			if(!rst)
				data_out<=16'b0;
			else if(wen)
				data_out<=data_in;
	end
	*/
endmodule
