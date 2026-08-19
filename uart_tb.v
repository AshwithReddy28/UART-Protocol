`timescale 1ns/1ps

module uart_tx_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] data_in;

wire tx;
wire busy;

uart_tx #(
    .CLK_FREQ(10000000),
    .BAUD_RATE(115200)
)
uut (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
    .busy(busy)
);

always #50 clk = ~clk;   // 10 MHz clock

initial
begin
    clk = 0;
    rst = 1;
    tx_start = 0;
    data_in = 8'h00;

    #200;
    rst = 0;

    // Send 'A'
    #200;
    data_in = 8'h41;
    tx_start = 1;

    #100;
    tx_start = 0;

    wait(!busy);

    // Send 'B'
    #1000;
    data_in = 8'h42;
    tx_start = 1;

    #100;
    tx_start = 0;

    wait(!busy);

    #5000;
    $finish;
end

endmodule