module top(
    input clk, 
    input rst_n, 
    input [8*70-1:0] pixel_in,
    output valid,
    output [8*36-1:0] pixel_out
);

wire [72-1:0] temp0, temp1, temp2, temp3;
// reg [8-1:0] pixel_2D [0:70-1];
// integer i;
// always begin
//     for (i = 0; i < 70; i = i + 1) begin
//         pixel_2D[i] = pixel_in[i*8+:8];
//     end 
// end
wire [8-1:0] test0;
assign test0 = pixel_in[559:559-7];

denoise #(
    .BIT_WIDTH(8)
) U0
(
    .clk(clk),
    .rst_n(rst_n),
    .pix_in(pixel_in),
    .block_out_0(temp0),
    .block_out_1(temp1),
    .block_out_2(temp2),
    .block_out_3(temp3)
);

endmodule