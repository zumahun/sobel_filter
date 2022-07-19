module cam_data(
    input sys_clk_i,
    input sys_rst_i,

    input vsync_i,
    input href_i,
    input pclk_i,
    input cam_data_i,

    output [7:0] cam_red_o,
    output [7:0] cam_green_o,
    output [7:0] cam_blue_o,

    output cam_done_o
);


endmodule