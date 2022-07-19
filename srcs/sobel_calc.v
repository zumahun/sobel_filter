module sobel_calc(
    input clk,
    input rst,

    input [7:0] d0_i,
    input [7:0] d1_i,
    input [7:0] d2_i,
    input [7:0] d3_i,
    input [7:0] d4_i,
    input [7:0] d5_i,
    input [7:0] d6_i,
    input [7:0] d7_i,
    input [7:0] d8_i,

    input done_i,

    output reg [7:0] grayscale_o,
    output done_o
);

reg [9:0] gx_p; // x positive value;
reg [9:0] gx_n; // x negative value;
reg [9:0] gx_d; // x data;

reg [9:0] gy_p; // y positive value;
reg [9:0] gy_n; // y negative value;
reg [9:0] gy_d; // y data;

// Why is it 10 bit?
// 0xff + 0xff + 0xff + 0xff = 0xff * 4;
// the 8 bit data need to left shift 2 bit, so it is 10 bit;

reg [9:0] g_sum; // gsum = |gx_d| + |gx_d|;

reg [3:0] done_shift;

always @(posedge clk) begin
    if (rst) begin
        gx_p <= 0;      // x positive value;
        gx_n <= 0;      // x negative value;
    end else begin
        gx_p <= d6_i + (d3_i << 1) + d0_i;      // x positive value;
        gx_n <= d8_i + (d5_i << 1) + d2_i;      // x negative value;
    end
end

always @(posedge clk) begin
    if (rst) begin
        gy_p <= 0;      // y positive value;
        gy_n <= 0;      // y negative value;
    end else begin
        gy_p <= d0_i + (d1_i << 1) + d2_i;      // y positive value;
        gy_n <= d6_i + (d7_i << 1) + d8_i;      // y negative value;
    end
end

always @(posedge clk) begin
    if (rst) begin
        gx_d <= 0;      // x data;
    end else begin
        gx_d <= (gx_p >= gx_n) ? (gx_p - gx_n) : (gx_n - gx_p);     // x data;
    end
end

always @(posedge clk) begin
    if (rst) begin
        gy_d <= 0;      // y data;
    end else begin
        gy_d <= (gy_p >= gy_n) ? (gy_p - gy_n) : (gy_n - gy_p);     // y data;
    end
end

always @(posedge clk) begin
    if (rst) begin
        g_sum <= 0;
    end else begin
        g_sum <= gx_d + gy_d;
    end
end

always @(posedge clk) begin
    if (rst) begin
        grayscale_o <= 0;
    end else begin
        grayscale_o <= (g_sum >= 8'd60) ? 8'd255 : g_sum[7:0];
    end
end

always @(posedge clk) begin
    if (rst) begin
        done_shift <= 0;
    end else begin
        done_shift <= {done_shift[2:0], done_i};
    end
end

assign done_o = done_shift[3];

endmodule