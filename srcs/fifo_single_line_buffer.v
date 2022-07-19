module fifo_single_line_buffer(
    input clk,
    input rst,

    input we_i,
    input [7:0] data_i,

    output [7:0] data_o,
    output done_o
);
    //parameter DEPTH = 640;
    parameter DEPTH = 512;

    reg [7:0] mem [0 : DEPTH - 1];

    reg [9:0] wr_pointer; // 640 --> 10 Bit
    reg [9:0] rd_pointer; 

    reg [9:0] iCounter;

    assign done_o = (iCounter == DEPTH) ? 1 : 0;
    assign data_o = mem[rd_pointer];

    //-----------handle with iCounter-----------------------------
    always @(posedge clk) begin
        if (rst) begin
            iCounter <= 0;
        end else begin
            if (we_i == 1) begin
                iCounter <= (iCounter == DEPTH) ? iCounter : iCounter + 1;
            end
        end
    end

    //-----------handle with write process-----------------------------
    always @(posedge clk) begin
        if (rst) begin
            wr_pointer <= 0;
        end else begin
            if (we_i == 1) begin
                mem[wr_pointer] <= data_i;
                wr_pointer <= (wr_pointer == DEPTH - 1) ? 0 : wr_pointer + 1;
            end
        end
    end

    //-----------handle with read process-----------------------------
    always @(posedge clk) begin
        if (rst) begin
            rd_pointer <= 0;
        end else begin
            if (we_i == 1) begin
                if (iCounter == DEPTH) begin
                    rd_pointer <= (rd_pointer == DEPTH - 1) ? 0 : rd_pointer + 1;
                end
            end
        end
    end

endmodule