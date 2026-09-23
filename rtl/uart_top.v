`timescale 1ns / 1ps

module uart_top #(
    parameter CLK_FREQ = 100_000_000
)(
    input  wire       rst,
    input  wire [7:0] data_in,
    input  wire       wr_en,
    input  wire       clk,
    input  wire       rdy_clr,
    input  wire [2:0] baud_sel,
    output wire       rdy,
    output wire       busy,
    output wire [7:0] data_out
);

    wire tx_clk_en;
    wire rx_clk_en;
    wire tx_line;

    baud_rate_generator #(
        .CLK_FREQ (CLK_FREQ)
    ) u_baud (
        .clock    (clk),
        .reset    (rst),
        .baud_sel (baud_sel),
        .enb_tx   (tx_clk_en),
        .enb_rx   (rx_clk_en)
    );

    uart_transmitter u_tx (
        .clk     (clk),
        .wr_en   (wr_en),
        .enb     (tx_clk_en),
        .rst     (rst),
        .data_in (data_in),
        .tx      (tx_line),
        .tx_busy (busy)
    );

    uart_receiver u_rx (
        .clk      (clk),
        .rst      (rst),
        .rx       (tx_line),
        .rdy_clr  (rdy_clr),
        .clken    (rx_clk_en),
        .rdy      (rdy),
        .data_out (data_out)
    );

endmodule
