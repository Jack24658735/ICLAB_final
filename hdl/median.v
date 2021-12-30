module median
#(

)
(
    input clk,
    input [8-1:0] val_0,
    input [8-1:0] val_1,
    input [8-1:0] val_2,
    output reg [8-1:0] med
);

reg [8-1:0] val_0_r;
reg [8-1:0] val_1_r;
reg [8-1:0] val_2_r;
reg [8-1:0] med_n;

always @(*) begin
    // case1: val_0 is maximum
    if (val_0_r >= val_1_r && val_0_r >= val_2_r) begin
        med_n = (val_1_r >= val_2_r) ? val_1_r : val_2_r;
    end
    // case2: val_1 is maximum
    else if (val_1_r >= val_0_r && val_1_r >= val_2_r) begin
        med_n = (val_0_r >= val_2_r) ? val_0_r : val_2_r;
    end
    // case3: val_2 is maximum
    else begin
        med_n = (val_0_r >= val_1_r) ? val_0_r : val_1_r;
    end
end

always @(posedge clk) begin
    val_0_r <= val_0;
    val_1_r <= val_1;
    val_2_r <= val_2;
    med <= med_n;
end
endmodule


