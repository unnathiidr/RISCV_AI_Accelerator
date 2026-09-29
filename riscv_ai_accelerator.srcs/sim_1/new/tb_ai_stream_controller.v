`timescale 1ns/1ps

module tb_ai_stream_controller;

    reg clk;
    reg rst;
    reg start;

    reg [31:0] matrix_a0;
    reg [31:0] matrix_a1;
    reg [31:0] matrix_a2;
    reg [31:0] matrix_a3;

    reg [31:0] matrix_b0;
    reg [31:0] matrix_b1;
    reg [31:0] matrix_b2;
    reg [31:0] matrix_b3;

    wire busy;
    wire done;

    wire signed [7:0] a0;
    wire signed [7:0] a1;
    wire signed [7:0] a2;
    wire signed [7:0] a3;

    wire signed [7:0] b0;
    wire signed [7:0] b1;
    wire signed [7:0] b2;
    wire signed [7:0] b3;

    wire compute_enable;


    // =========================================================
    // DUT
    // =========================================================

    ai_stream_controller DUT (

        .clk(clk),
        .rst(rst),

        .start(start),

        .busy(busy),
        .done(done),

        .matrix_a0(matrix_a0),
        .matrix_a1(matrix_a1),
        .matrix_a2(matrix_a2),
        .matrix_a3(matrix_a3),

        .matrix_b0(matrix_b0),
        .matrix_b1(matrix_b1),
        .matrix_b2(matrix_b2),
        .matrix_b3(matrix_b3),

        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),

        .b0(b0),
        .b1(b1),
        .b2(b2),
        .b3(b3),

        .compute_enable(compute_enable)

    );


    // =========================================================
    // CLOCK
    // =========================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    // =========================================================
    // TEST
    // =========================================================

    initial begin

        rst = 1'b1;
        start = 1'b0;


        // =====================================================
        // MATRIX A
        //
        //  1   2   3   4
        //  5   6   7   8
        //  9  10  11  12
        // 13  14  15  16
        // =====================================================

        matrix_a0 = {8'd4,  8'd3,  8'd2,  8'd1};
        matrix_a1 = {8'd8,  8'd7,  8'd6,  8'd5};
        matrix_a2 = {8'd12, 8'd11, 8'd10, 8'd9};
        matrix_a3 = {8'd16, 8'd15, 8'd14, 8'd13};


        // =====================================================
        // MATRIX B
        //
        //  1   2   1   0
        //  0   1   2   1
        //  1   0   1   2
        //  2   1   0   1
        //
        // Rows are packed into 32-bit words.
        // =====================================================

        matrix_b0 = {8'd0, 8'd1, 8'd2, 8'd1};

        matrix_b1 = {8'd1, 8'd2, 8'd1, 8'd0};

        matrix_b2 = {8'd2, 8'd1, 8'd0, 8'd1};

        matrix_b3 = {8'd1, 8'd0, 8'd1, 8'd2};


        // =====================================================
        // RESET
        // =====================================================

        #20;

        rst = 1'b0;


        // =====================================================
        // START
        // =====================================================

        @(negedge clk);

        start = 1'b1;

        @(negedge clk);

        start = 1'b0;


        // =====================================================
        // MONITOR EVERY STREAM CYCLE
        // =====================================================

        repeat (12) begin

            @(negedge clk);

            $display(
                "cycle=%d | busy=%b | compute=%b | A=(%d,%d,%d,%d) | B=(%d,%d,%d,%d)",
                DUT.cycle,
                busy,
                compute_enable,
                a0,a1,a2,a3,
                b0,b1,b2,b3
            );

        end


        // =====================================================
        // WAIT FOR DONE
        // =====================================================

        wait(done);

        #1;


        $display("");
        $display("========================================");
        $display("AI STREAM CONTROLLER TEST COMPLETE");
        $display("========================================");

        if (done)
            $display("DONE = PASS");
        else
            $display("DONE = FAIL");


        #20;

        $finish;

    end


    // =========================================================
    // WAVEFORM
    // =========================================================

    initial begin

        $dumpfile("ai_stream_controller.vcd");

        $dumpvars(0,tb_ai_stream_controller);

    end

endmodule