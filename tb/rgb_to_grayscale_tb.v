`define clk_period 10

// reference
//https://en.wikipedia.org/wiki/BMP_file_format#:~:text=The%20BMP%20file%20format%2C%20also,and%20OS%2F2%20operating%20systems.

module rgb_to_grayscale_tb();
    
reg clk, rst;

reg [7:0] red_i, green_i, blue_i;
reg done_i;

wire [7:0] grayscale_o;
wire done_o;

rgb_to_grayscale RGB_TO_GRAYSCALE(
    .clk(clk),
    .rst(rst),

    .red_i(red_i),
    .green_i(green_i),
    .blue_i(blue_i),

    .done_i(done_i),

    .grayscale_o(grayscale_o),
    .done_o(done_o)
);

initial begin
    clk = 1'b1;
    $dumpfile("rgb_to_grayscale.vcd");
    $dumpvars(0, rgb_to_grayscale_tb);
end

always #(`clk_period/2) clk = ~clk;

//--------------------------------------------------------------------------------------------
integer i, j;
localparam RESULT_ARRAY_LEN = 1000*1024; //500 * 1024
reg [7:0] result[0:RESULT_ARRAY_LEN-1];

always @(posedge clk) begin
    if (rst) begin
        j <= 8'd0;
    end else begin
        if (done_o) begin
            result[j]   <= grayscale_o;
            result[j+1] <= grayscale_o;
            result[j+2] <= grayscale_o;
            j <= j + 3;
        end
    end
end

//--------------------------------------------------------------------------------------------
`define read_fileName "C:\\training\\training_myself\\image_processing\\photo\\lena_std.bmp"
//`define read_fileName "..\\photo\\lena_std.bmp"
localparam BMP_ARRAY_LEN = 1000*1024; //500 * 1024

reg [7:0] bmp_data[0: BMP_ARRAY_LEN-1];
integer bmp_size, bmp_start_pos, bmp_width, bmp_height, biBitCount;

task readBMP;
    integer fileId, i;
    begin
        //fileId = $fopen("C:\\training\\training_myself\\image_processing\\photo\\lena_std.bmp", "rb");
        fileId = $fopen(`read_fileName, "rb");
        if (fileId == 0) begin
            $display("Open BMP error!\n");
            $finish;
        end else begin
            $fread(bmp_data, fileId);
            $fclose(fileId);
            
            bmp_size = {bmp_data[5], bmp_data[4], bmp_data[3], bmp_data[2]};
            $display("bmp_size = %d!\n", bmp_size);

            bmp_start_pos = {bmp_data[13], bmp_data[12], bmp_data[11], bmp_data[10]};
            $display("bmp_start_pos = %d!\n", bmp_start_pos);

            bmp_width = {bmp_data[21], bmp_data[20], bmp_data[19], bmp_data[18]};
            $display("bmp_width = %d!\n", bmp_width);

            bmp_height = {bmp_data[25], bmp_data[24], bmp_data[23], bmp_data[22]};
            $display("bmp_height = %d!\n", bmp_height);

            biBitCount = {bmp_data[29], bmp_data[28]};
            $display("biBitCount = %d!\n", biBitCount);

            if (biBitCount != 24) begin
                $display("biBitCount need to be 24bit!\n");
                $finish;
            end

            if (bmp_width % 4) begin
                $display("bmp_width % 4 need to beg zero.\n");
                $finish;
            end

            //for (i=bmp_start_pos; i<bmp_size; i=i+1) begin
            //    $display("%h\n", bmp_data[i]);
            //end
        end
    end
endtask

`define write_fileName "C:\\training\\training_myself\\image_processing\\photo\\result.bmp"

task writeBMP;
    integer fileId, i;
    begin
        fileId = $fopen(`write_fileName, "wb");

        for (i=0; i<bmp_start_pos; i=i+1) begin
            $fwrite(fileId, "%c", bmp_data[i]);
        end

        for (i=bmp_start_pos; i<bmp_size; i=i+1) begin
            $fwrite(fileId, "%c", result[i-bmp_start_pos]);
        end

        $fclose(fileId);
        $display("$write_BMP: BMP!\n");
    end
endtask

initial begin
    rst = 1'b1;
    done_i = 1'b0;

    red_i       = 8'd0;
    green_i     = 8'd0;
    blue_i      = 8'd0;

    readBMP;

    @(negedge clk);
    rst  = 1'b0;

    for (i = bmp_start_pos; i < bmp_size; i = i + 3) begin
        red_i   = bmp_data[i+2];
        green_i = bmp_data[i+1];
        blue_i  = bmp_data[i];

        @(negedge clk);
        done_i = 1'b1;
    end


    @(negedge clk);
    done_i      = 1'b0;

    @(negedge clk);
    writeBMP;

    @(negedge clk);
    $finish;
end
endmodule