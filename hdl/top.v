module top(
    input clk, 
    input rst_n, 
    input [8*70-1:0] pixel_in,
    output valid,
    output [8*9-1:0] block_out_0, 
    output [8*9-1:0] block_out_1, 
    output [8*9-1:0] block_out_2, 
    output [8*9-1:0] block_out_3
    // output [2*8*9-1:0] block_out_0, 
    // output [2*8*9-1:0] block_out_1, 
    // output [2*8*9-1:0] block_out_2, 
    // output [2*8*9-1:0] block_out_3
);


reg [8*70-1:0] pixel_in_r;

wire denoise_valid;

wire [8-1:0] cnt_row; 
wire [6-1:0] cnt_col;
wire [8*9-1:0] denoise_block_out_0, denoise_block_out_1, denoise_block_out_2, denoise_block_out_3;

assign valid = denoise_valid;


denoise #(
    .BIT_WIDTH(8)
) U0
(
    .clk(clk),
    .rst_n(rst_n),
    .pix_in(pixel_in_r),
    .block_out_0(block_out_0),
    .block_out_1(block_out_1),
    .block_out_2(block_out_2),
    .block_out_3(block_out_3),
    // .block_out_0(denoise_block_out_0),
    // .block_out_1(denoise_block_out_1),
    // .block_out_2(denoise_block_out_2),
    // .block_out_3(denoise_block_out_3),
    .valid(denoise_valid)
);


// HOG #(
// 	.BITWIDTH(8)
// ) U1
// (	
// 	.clk(clk),
// 	.rst_n(rst_n),
// 	.cnt_row(cnt_row), // 0 - 159
// 	.cnt_col(cnt_col), // 0 - 52
// 	.block0(denoise_block_out_0), 
// 	.block1(denoise_block_out_1), 
// 	.block2(denoise_block_out_2), 
// 	.block3(denoise_block_out_3), // 3*3*BITWIDTH // 71:0
// 	.HOG_out0(block_out_0), 
// 	.HOG_out1(block_out_1), 
// 	.HOG_out2(block_out_2), 
// 	.HOG_out3(block_out_3)
// );


hog_counter U2 (
    .clk(clk),
    .rst_n(rst_n), 
    .start(denoise_valid),
    .cnt_row(cnt_row), 
    .cnt_col(cnt_col)
);

always @(posedge clk) begin
    if (~rst_n)
        pixel_in_r <= 0;
    else 
        pixel_in_r <= pixel_in;
end

endmodule