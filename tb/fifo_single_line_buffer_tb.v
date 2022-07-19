`define clk_period 10

module fifo_single_line_buffer_tb();

reg clk;
reg rst;

reg we_i;
reg [7:0] data_i;

wire [7:0] data_o;
wire done_o;


fifo_single_line_buffer FIFO_SINGLE_LINE_BUFFER(
    .clk(clk),
    .rst(rst),

    .we_i(we_i),
    .data_i(data_i),

    .data_o(data_o),
    .done_o(done_o)
);

initial clk = 1'b1;
always #(`clk_period/2) clk = ~clk;

integer i;
initial begin
    rst = 1'b1;
    data_i = 8'b0;
    we_i   = 1'b0;

    @(negedge clk);
    rst = 1'b0;
    we_i = 1'b1;

    for (i = 0; i < 10; i = i + 1) begin
        data_i = i;
        @(negedge clk);
    end

    we_i = 1'b0;
    @(negedge clk);

    $stop;

end

endmodule