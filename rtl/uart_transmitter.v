`timescale 1ns / 1ps

module uart_transmitter (
    input  wire       clk,
    input  wire       wr_en,
    input  wire       enb,
    input  wire       rst,
    input  wire [7:0] data_in,
    output reg        tx,
    output wire       tx_busy
);

    localparam [1:0] STATE_IDLE  = 2'b00;
    localparam [1:0] STATE_START = 2'b01;
    localparam [1:0] STATE_DATA  = 2'b10;
    localparam [1:0] STATE_STOP  = 2'b11;

    reg [7:0] data;
    reg [2:0] bitpos;
    reg [1:0] state;

    always @(posedge clk) begin
        if (rst) begin
            state  <= STATE_IDLE;
            tx     <= 1'b1;
            data   <= 8'h00;
            bitpos <= 3'd0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    if (wr_en) begin
                        data   <= data_in;
                        bitpos <= 3'd0;
                        state  <= STATE_START;
                    end
                end

                STATE_START: begin
                    if (enb) begin
                        tx    <= 1'b0;
                        state <= STATE_DATA;
                    end
                end

                STATE_DATA: begin
                    if (enb) begin
                        tx <= data[bitpos];
                        if (bitpos == 3'd7)
                            state <= STATE_STOP;
                        else
                            bitpos <= bitpos + 3'd1;
                    end
                end

                STATE_STOP: begin
                    if (enb) begin
                        tx    <= 1'b1;
                        state <= STATE_IDLE;
                    end
                end

                default: begin
                    tx    <= 1'b1;
                    state <= STATE_IDLE;
                end
            endcase
        end
    end

    assign tx_busy = (state != STATE_IDLE);

endmodule
