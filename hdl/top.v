module top(
    input clk, 
    input rst_n, 
    input [8*70-1:0] pixel_in,
    output valid,
    output [8*9-1:0] block_out_0, 
    output [8*9-1:0] block_out_1, 
    output [8*9-1:0] block_out_2, 
    output [8*9-1:0] block_out_3
);




wire [8-1:0] test0;
wire denoise_valid;
assign test0 = pixel_in[559:559-7];

assign valid = denoise_valid;


denoise #(
    .BIT_WIDTH(8)
) U0
(
    .clk(clk),
    .rst_n(rst_n),
    .pix_in(pixel_in),
    .block_out_0(block_out_0),
    .block_out_1(block_out_1),
    .block_out_2(block_out_2),
    .block_out_3(block_out_3),
    .valid(denoise_valid)
);

endmodule