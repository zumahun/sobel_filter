module cam_mod(
    input sys_clk_i,
    input sys_rst_i,

    output xvclk_o,
    output sio_c_o,
    inout  sio_d_io,
    output cam_rst_o,
    output cam_pwd_o,

    input vsync_i,
    input href_i,
    input pclk_i,
    input [7:0] cam_data_i,

    output [7:0] cam_red_o,
    output [7:0] cam_green_o,
    output [7:0] cam_blue_o,

    output cam_done_o
);

    cam_ctrl CAM_CTRL(
        .sys_clk_i(sys_clk_i),
        .sys_rst_i(sys_rst_i),

        .xvclk_o(xvclk_o),
        .sio_c_o(sio_c_o),
        .sio_d_io(sio_d_io),

        .cam_rst_o(cam_rst_o),
        .cam_pwd_o(cam_pwd_o)
    );

    cam_data CAM_DATA(
        .sys_clk_i(sys_clk_i),
        .sys_rst_i(sys_rst_i),

        .vsync_i(vsync_i),
        .href_i(href_i),
        .pclk_i(pclk_i),
        .cam_data_i(cam_data_i),

        .cam_red_o(cam_red_o),
        .cam_green_o(cam_green_o),
        .cam_blue_o(cam_blue_o),

        .cam_done_o(cam_done_o)
    );
endmodule