module cache_word #(
    parameter WIDTH = 16
) (
    input clk,
    input rst,
    input [WIDTH-1:0] data_in,
    input wen,
    input enable,
    output reg [WIDTH-1:0] data_out
);


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

endmodule  // cache_word
