`timescale 1ns / 1ps

module uart_top_tb;

    reg        clk      = 1'b0;
    reg        rst      = 1'b0;
    reg  [7:0] data_in  = 8'h00;
    reg        wr_en    = 1'b0;
    reg        rdy_clr  = 1'b0;
    reg  [2:0] baud_sel = 3'd0;
    wire       rdy;
    wire       busy;
    wire [7:0] dout;

    integer errors  = 0;
    integer exp_tx  = 10417;
    integer exp_rx  = 651;
    integer cyc     = 0;
    integer last_tx_tick = -1;
    integer last_rx_tick = -1;
    integer last_edge    = -1;
    reg     last_line    = 1'b1;
    reg     mon_en       = 1'b0;
    integer s;

    uart_top dut (
        .rst      (rst),
        .data_in  (data_in),
        .wr_en    (wr_en),
        .clk      (clk),
        .rdy_clr  (rdy_clr),
        .baud_sel (baud_sel),
        .rdy      (rdy),
        .busy     (busy),
        .data_out (dout)
    );

    always #5 clk = ~clk;

    function integer tx_div(input [2:0] sel);
        case (sel)
            3'd1:    tx_div = 5208;
            3'd2:    tx_div = 2604;
            3'd3:    tx_div = 1736;
            3'd4:    tx_div = 868;
            default: tx_div = 10417;
        endcase
    endfunction

    function integer rx_div(input [2:0] sel);
        case (sel)
            3'd1:    rx_div = 326;
            3'd2:    rx_div = 163;
            3'd3:    rx_div = 109;
            3'd4:    rx_div = 54;
            default: rx_div = 651;
        endcase
    endfunction

    function integer baud_of(input [2:0] sel);
        case (sel)
            3'd1:    baud_of = 19200;
            3'd2:    baud_of = 38400;
            3'd3:    baud_of = 57600;
            3'd4:    baud_of = 115200;
            default: baud_of = 9600;
        endcase
    endfunction

    always @(posedge clk) begin
        cyc = cyc + 1;
        if (!rst && mon_en) begin
            if (dut.tx_clk_en) begin
                if (last_tx_tick >= 0 && (cyc - last_tx_tick) != exp_tx) begin
                    errors = errors + 1;
                    $display("FAIL: enb_tx period %0d, expected %0d", cyc - last_tx_tick, exp_tx);
                end
                last_tx_tick = cyc;
            end
            if (dut.rx_clk_en) begin
                if (last_rx_tick >= 0 && (cyc - last_rx_tick) != exp_rx) begin
                    errors = errors + 1;
                    $display("FAIL: enb_rx period %0d, expected %0d", cyc - last_rx_tick, exp_rx);
                end
                last_rx_tick = cyc;
            end
            if (dut.tx_line !== last_line) begin
                if (last_edge >= 0 && ((cyc - last_edge) % exp_tx) != 0) begin
                    errors = errors + 1;
                    $display("FAIL: tx edge spacing %0d not a multiple of %0d", cyc - last_edge, exp_tx);
                end
                last_edge = cyc;
                last_line = dut.tx_line;
            end
        end
    end

    task set_baud(input [2:0] sel);
        begin
            @(negedge clk);
            mon_en   = 1'b0;
            baud_sel = sel;
            exp_tx   = tx_div(sel);
            exp_rx   = rx_div(sel);
            repeat (4) @(negedge clk);
            last_tx_tick = -1;
            last_rx_tick = -1;
            last_edge    = -1;
            last_line    = dut.tx_line;
            mon_en       = 1'b1;
        end
    endtask

    task send_byte(input [7:0] din);
        begin
            @(negedge clk);
            data_in = din;
            wr_en   = 1'b1;
            @(negedge clk);
            wr_en   = 1'b0;
        end
    endtask

    task clear_ready;
        begin
            @(negedge clk);
            rdy_clr = 1'b1;
            @(negedge clk);
            rdy_clr = 1'b0;
        end
    endtask

    task check_byte(input [7:0] din);
        begin
            send_byte(din);
            wait (rdy);
            if (dout === din)
                $display("PASS: baud_sel=%0d (%0d baud) sent %h, received %h", baud_sel, baud_of(baud_sel), din, dout);
            else begin
                errors = errors + 1;
                $display("FAIL: baud_sel=%0d (%0d baud) sent %h, received %h", baud_sel, baud_of(baud_sel), din, dout);
            end
            clear_ready;
        end
    endtask

    initial begin
        $dumpfile("uart_top_tb.vcd");
        $dumpvars(0, uart_top_tb);

        repeat (2) @(negedge clk);
        rst = 1'b1;
        repeat (2) @(negedge clk);
        rst = 1'b0;

        for (s = 0; s < 5; s = s + 1) begin
            set_baud(s[2:0]);
            check_byte(8'h41);
            check_byte(8'h55);
            check_byte(8'hA3);
        end

        set_baud(3'd7);
        check_byte(8'hC3);

        set_baud(3'd0);
        check_byte(8'hFF);
        #100_000;

        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end

    initial begin
        #100_000_000;
        $display("TIMEOUT");
        $finish;
    end

endmodule
