`timescale 1ns / 1ps

module baud_rate_generator #(
    parameter CLK_FREQ = 100_000_000
)(
    input  wire       clock,
    input  wire       reset,
    input  wire [2:0] baud_sel,
    output reg        enb_tx,
    output reg        enb_rx
);

    localparam W_TX = $clog2((CLK_FREQ + 4800) / 9600);
    localparam W_RX = $clog2((CLK_FREQ + 8 * 9600) / (16 * 9600));

    function [W_TX-1:0] tx_last(input integer baud);
        /* verilator lint_off UNUSEDSIGNAL */
        integer d;
        /* verilator lint_on UNUSEDSIGNAL */
        begin
            d       = (CLK_FREQ + baud / 2) / baud - 1;
            tx_last = d[W_TX-1:0];
        end
    endfunction

    function [W_RX-1:0] rx_last(input integer baud);
        /* verilator lint_off UNUSEDSIGNAL */
        integer d;
        /* verilator lint_on UNUSEDSIGNAL */
        begin
            d       = (CLK_FREQ + 8 * baud) / (16 * baud) - 1;
            rx_last = d[W_RX-1:0];
        end
    endfunction

    reg [W_TX-1:0] last_tx;
    reg [W_RX-1:0] last_rx;

    always @(*) begin
        case (baud_sel)
            3'd1:    begin last_tx = tx_last(19200);  last_rx = rx_last(19200);  end
            3'd2:    begin last_tx = tx_last(38400);  last_rx = rx_last(38400);  end
            3'd3:    begin last_tx = tx_last(57600);  last_rx = rx_last(57600);  end
            3'd4:    begin last_tx = tx_last(115200); last_rx = rx_last(115200); end
            default: begin last_tx = tx_last(9600);   last_rx = rx_last(9600);   end
        endcase
    end

    reg [2:0]      sel_q;
    reg [W_TX-1:0] counter_tx;
    reg [W_RX-1:0] counter_rx;

    wire restart = reset | (baud_sel != sel_q);

    always @(posedge clock)
        sel_q <= baud_sel;

    always @(posedge clock) begin
        if (restart) begin
            counter_tx <= {W_TX{1'b0}};
            enb_tx     <= 1'b0;
        end else begin
            enb_tx     <= (counter_tx == last_tx);
            counter_tx <= (counter_tx == last_tx) ? {W_TX{1'b0}} : counter_tx + 1'b1;
        end
    end

    always @(posedge clock) begin
        if (restart) begin
            counter_rx <= {W_RX{1'b0}};
            enb_rx     <= 1'b0;
        end else begin
            enb_rx     <= (counter_rx == last_rx);
            counter_rx <= (counter_rx == last_rx) ? {W_RX{1'b0}} : counter_rx + 1'b1;
        end
    end

endmodule
