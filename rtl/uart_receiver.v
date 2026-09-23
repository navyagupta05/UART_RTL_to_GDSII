`timescale 1ns / 1ps

module uart_receiver (
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,
    input  wire       rdy_clr,
    input  wire       clken,
    output reg        rdy,
    output reg  [7:0] data_out
);

    localparam [1:0] RX_STATE_START = 2'b00;
    localparam [1:0] RX_STATE_DATA  = 2'b01;
    localparam [1:0] RX_STATE_STOP  = 2'b10;

    reg [1:0] state;
    reg [3:0] sample;
    reg [3:0] index;
    reg [7:0] temp;
    reg [1:0] rx_sync;

    wire rx_s = rx_sync[1];

    always @(posedge clk) begin
        if (rst) begin
            rx_sync  <= 2'b11;
            state    <= RX_STATE_START;
            sample   <= 4'd0;
            index    <= 4'd0;
            temp     <= 8'h00;
            rdy      <= 1'b0;
            data_out <= 8'h00;
        end else begin
            rx_sync <= {rx_sync[0], rx};

            if (rdy_clr)
                rdy <= 1'b0;

            if (clken) begin
                case (state)
                    RX_STATE_START: begin
                        if (sample == 4'd15) begin
                            state  <= RX_STATE_DATA;
                            sample <= 4'd0;
                            index  <= 4'd0;
                        end else if (!rx_s || sample != 4'd0) begin
                            sample <= sample + 4'd1;
                        end
                    end

                    RX_STATE_DATA: begin
                        sample <= sample + 4'd1;
                        if (sample == 4'd8) begin
                            temp  <= {rx_s, temp[7:1]};
                            index <= index + 4'd1;
                        end
                        if (sample == 4'd15 && index == 4'd8)
                            state <= RX_STATE_STOP;
                    end

                    RX_STATE_STOP: begin
                        if (sample == 4'd8) begin
                            state    <= RX_STATE_START;
                            sample   <= 4'd0;
                            data_out <= temp;
                            rdy      <= 1'b1;
                        end else begin
                            sample <= sample + 4'd1;
                        end
                    end

                    default: begin
                        state  <= RX_STATE_START;
                        sample <= 4'd0;
                    end
                endcase
            end
        end
    end

endmodule
