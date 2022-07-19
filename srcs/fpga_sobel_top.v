module fpga_sobel_top(
    input sys_clk_i,
    input sys_rst_i,

    output xvclk_o,
    output sio_c_o,
    inout sio_d_io,
    output cam_rst_o,
    output cam_pwd_o,

    input vsync_i,
    input href_i,
    input pclk_i,
    input [7:0] cam_data_i,

    output scl_o,
    inout sda_io,

    output clk_n_o,
    output clk_p_o,

    output [2:0] hdmi_data_o
);

    wire [7:0] cam_red_o;
    wire [7:0] cam_green_o;
    wire [7:0] cam_blue_o;

    wire cam_done_o;

    wire [7:0] sobel_red_o;
    wire [7:0] sobel_green_o;
    wire [7:0] sobel_blue_o;

    wire sobel_done;
    wire [2:0] hdmi_data_o;

cam_mod CAM_MOD(
    .sys_clk_i(sys_clk_i),
    .sys_rst_i(sys_rst_i),

    .xvclk_o(xvclk_o),
    .sio_c_o(sio_c_o),
    .sio_d_io(sio_d_io),
    .cam_rst_o(cam_rst_o),
    .cam_pwd_o(cam_pwd_o),

    .vsync_i(vsync_i),
    .href_i(href_i),
    .pclk_i(pclk_i),
    .cam_data_i(cam_data_i),

    .cam_red_o(cam_red_o),
    .cam_green_o(cam_green_o),
    .cam_blue_o(cam_blue_o),

    .cam_done_o(cam_done_o)  
);

sobel_mod SOBEL_MOD(
    .sys_clk_i(sys_clk_i),
    .sys_rst_i(sys_rst_i),

    .cam_red_i(cam_red_o),
    .cam_green_i(cam_green_o),
    .cam_blue_i(cam_blue_o),

    .cam_done_i(cam_done_o),

    .sobel_red_o(sobel_red_o),
    .sobel_green_o(sobel_green_o),
    .sobel_blue_o(sobel_blue_o),

    .sobel_done_o(sobel_done_o)
);

endmodule