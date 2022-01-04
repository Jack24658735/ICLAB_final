`timescale 1ns/100ps

module test_top;

localparam END_CYCLES = 10000; // you can enlarge the cycle count limit for longer simulation
real CYCLE = 10;
integer i, j;
integer start_row, start_col;

reg clk, rst_n;
reg [8*70-1:0] pixel_in;
wire valid;
wire [8*36-1:0] pixel_out;

reg [638*8-1:0] picture [0:482-1];

top mytop(
    .clk(clk), 
    .rst_n(rst_n), 
    .pixel_in(pixel_in), 
    .valid(valid), 
    .pixel_out(pixel_out)
);

initial begin
    clk = 1;
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
