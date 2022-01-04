`timescale 1ns/100ps

module test_top;

localparam END_CYCLES = 50000; // you can enlarge the cycle count limit for longer simulation
real CYCLE = 10;
integer i, j, k;
integer error;
integer start_row, start_col;
integer ans_start_row, ans_start_col;

reg clk, rst_n;
reg [8*70-1:0] pixel_in;
wire valid;
// wire [2*8*9-1:0] block_out_0, block_out_1, block_out_2, block_out_3;
wire [8*9-1:0] block_out_0, block_out_1, block_out_2, block_out_3;
reg [8*9-1:0] ans_block_out_0, ans_block_out_1, ans_block_out_2, ans_block_out_3;

reg [8-1:0] block_out_0_2D [0:9-1];
reg [8-1:0] block_out_1_2D [0:9-1];
reg [8-1:0] block_out_2_2D [0:9-1];
reg [8-1:0] block_out_3_2D [0:9-1];

// reg [2*8-1:0] block_out_0_2D [0:9-1];
// reg [2*8-1:0] block_out_1_2D [0:9-1];
// reg [2*8-1:0] block_out_2_2D [0:9-1];
// reg [2*8-1:0] block_out_3_2D [0:9-1];
always @* begin
    for (k = 8; k >= 0; k = k - 1) begin
        block_out_0_2D[k] = block_out_0[8*(k+1)-1-:8];
        block_out_1_2D[k] = block_out_1[8*(k+1)-1-:8];
        block_out_2_2D[k] = block_out_2[8*(k+1)-1-:8];
        block_out_3_2D[k] = block_out_3[8*(k+1)-1-:8];
    end
end

reg [638*8-1:0] picture [0:482-1];


`define SDFFILE "../syn/netlist/top_syn.sdf"
`ifdef SDF
    initial $sdf_annotate(`SDFFILE, mytop);
    top mytop(
        .clk(clk), 
        .rst_n(rst_n), 
        .pixel_in(pixel_in), 
        .valid(valid), 
        .block_out_0(block_out_0), 
        .block_out_1(block_out_1), 
        .block_out_2(block_out_2), 
        .block_out_3(block_out_3)
    );

`else
    top mytop(
        .clk(clk), 
        .rst_n(rst_n), 
        .pixel_in(pixel_in), 
        .valid(valid), 
        .block_out_0(block_out_0), 
        .block_out_1(block_out_1), 
        .block_out_2(block_out_2), 
        .block_out_3(block_out_3)
    );
`endif


initial begin
    clk = 0;
    rst_n = 1;
    pixel_in = 0;
    #(CYCLE) rst_n = 0;
    #(CYCLE) rst_n = 1;
end

always #(CYCLE/2) clk = ~clk;

initial begin
    $readmemh("pix/noise_638_482.txt", picture);
    wait(rst_n == 0);
    wait(rst_n == 1);

    // $display("%d ", picture[1][638*8-1:638*8-8]);
    // $display("%d ", picture[1][638*8-9:638*8-16]);
    // $display("%d ", picture[1][638*8-17:638*8-24]);
    // $display("%d ", picture[1][638*8-25:638*8-32]);
    // $display("%d ", picture[481][638*8-1:638*8-8]);
    // $display("%d ", picture[481][638*8-9:638*8-16]);
    // $display("%d ", picture[481][638*8-17:638*8-24]);
    // $display("%d ", picture[481][638*8-25:638*8-32]);

    for (start_row = 0; start_row <= 477; start_row = start_row + 3) begin
        for (start_col = 637; start_col >= 13; start_col = start_col - 12) begin
            @(negedge clk)
                pixel_in = {picture[start_row][8*(start_col+1)-1-:14*8], 
                            picture[start_row+1][8*(start_col+1)-1-:14*8], 
                            picture[start_row+2][8*(start_col+1)-1-:14*8], 
                            picture[start_row+3][8*(start_col+1)-1-:14*8], 
                            picture[start_row+4][8*(start_col+1)-1-:14*8]};
        end
    end

end


reg [636*8-1:0] golden [0:480-1];

// answer check
initial begin
    $readmemh("golden/med_of_med_636_480.txt", golden);
    error = 0;
    wait(valid == 1);
    // #(CYCLE);
    for (ans_start_row = 0; ans_start_row <= 477; ans_start_row = ans_start_row + 3) begin
        for (ans_start_col = 635; ans_start_col >= 11; ans_start_col = ans_start_col - 12) begin
            @(negedge clk);
            ans_block_out_0 = {golden[ans_start_row][(ans_start_col+1)*8-1-:24], 
                               golden[ans_start_row+1][(ans_start_col+1)*8-1-:24], 
                               golden[ans_start_row+2][(ans_start_col+1)*8-1-:24]};
            ans_block_out_1 = {golden[ans_start_row][(ans_start_col-3+1)*8-1-:24], 
                               golden[ans_start_row+1][(ans_start_col-3+1)*8-1-:24], 
                               golden[ans_start_row+2][(ans_start_col-3+1)*8-1-:24]};
            ans_block_out_2 = {golden[ans_start_row][(ans_start_col-6+1)*8-1-:24], 
                               golden[ans_start_row+1][(ans_start_col-6+1)*8-1-:24], 
                               golden[ans_start_row+2][(ans_start_col-6+1)*8-1-:24]};
            ans_block_out_3 = {golden[ans_start_row][(ans_start_col-9+1)*8-1-:24], 
                               golden[ans_start_row+1][(ans_start_col-9+1)*8-1-:24], 
                               golden[ans_start_row+2][(ans_start_col-9+1)*8-1-:24]};
            if (block_out_0 == ans_block_out_0 && block_out_1 == ans_block_out_1 && block_out_2 == ans_block_out_2 && block_out_3 == ans_block_out_3) begin
                $display("Position at (%3d, %3d) correct!", ans_start_row, ans_start_col);
            end
            else begin
                $display("Position at (%3d, %3d) WRONG! golden = %h, result = %h", ans_start_row, ans_start_col, ans_block_out_0, block_out_0);
                error = error + 1;
            end
        end
    end
    if (error == 0) begin
        $display("Congratulations! All results are correct!");
        $finish;
    end
    else begin
        $display("total error = %d", error);
        $finish;
    end
end

initial begin
    #(CYCLE*END_CYCLES);
    $display("\n========================================================");
    $display("Time limit exceeded!");
    $display("\n========================================================");
    $finish;
end

initial begin
    $fsdbDumpfile("final.fsdb");
    $fsdbDumpvars("+mda");
end

endmodule
