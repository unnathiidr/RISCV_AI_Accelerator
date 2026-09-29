`timescale 1ns/1ps

module tb_ai_compute_engine;

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

    wire signed [31:0] c00;
    wire signed [31:0] c01;
    wire signed [31:0] c02;
    wire signed [31:0] c03;

    wire signed [31:0] c10;
    wire signed [31:0] c11;
    wire signed [31:0] c12;
    wire signed [31:0] c13;

    wire signed [31:0] c20;
    wire signed [31:0] c21;
    wire signed [31:0] c22;
    wire signed [31:0] c23;

    wire signed [31:0] c30;
    wire signed [31:0] c31;
    wire signed [31:0] c32;
    wire signed [31:0] c33;


    // =========================================================
    // DUT
    // =========================================================

    ai_compute_engine DUT (

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

        .c00(c00),
        .c01(c01),
        .c02(c02),
        .c03(c03),

        .c10(c10),
        .c11(c11),
        .c12(c12),
        .c13(c13),

        .c20(c20),
        .c21(c21),
        .c22(c22),
        .c23(c23),

        .c30(c30),
        .c31(c31),
        .c32(c32),
        .c33(c33)

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

        matrix_a0 = {8'd4,8'd3,8'd2,8'd1};

        matrix_a1 = {8'd8,8'd7,8'd6,8'd5};

        matrix_a2 = {8'd12,8'd11,8'd10,8'd9};

        matrix_a3 = {8'd16,8'd15,8'd14,8'd13};


        // =====================================================
        // MATRIX B
        //
        //  1   2   1   0
        //  0   1   2   1
        //  1   0   1   2
        //  2   1   0   1
        //
        // Remember:
        //
        // matrix_b0 = ROW 0
        // matrix_b1 = ROW 1
        // matrix_b2 = ROW 2
        // matrix_b3 = ROW 3
        // =====================================================

        matrix_b0 = {8'd0,8'd1,8'd2,8'd1};

        matrix_b1 = {8'd1,8'd2,8'd1,8'd0};

        matrix_b2 = {8'd2,8'd1,8'd0,8'd1};

        matrix_b3 = {8'd1,8'd0,8'd1,8'd2};


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
        // WAIT FOR DONE
        // =====================================================

        wait(done);

        #2;


        // =====================================================
        // DISPLAY
        // =====================================================

        $display("");
        $display("========================================");
        $display("AI COMPUTE ENGINE TEST");
        $display("========================================");

        $display("");

        $display("BUSY = %b", busy);

        $display("DONE = %b", done);


        $display("");

        $display("RESULT:");

        $display("%d  %d  %d  %d",
                 c00,c01,c02,c03);

        $display("%d  %d  %d  %d",
                 c10,c11,c12,c13);

        $display("%d  %d  %d  %d",
                 c20,c21,c22,c23);

        $display("%d  %d  %d  %d",
                 c30,c31,c32,c33);


        // =====================================================
        // EXPECTED
        // =====================================================

        $display("");

        $display("EXPECTED:");

        $display("12   8   8  12");

        $display("28  24  24  28");

        $display("44  40  40  44");

        $display("60  56  56  60");


        // =====================================================
        // CHECK
        // =====================================================

        if ((c00 == 12) &&
            (c01 == 8)  &&
            (c02 == 8)  &&
            (c03 == 12) &&

            (c10 == 28) &&
            (c11 == 24) &&
            (c12 == 24) &&
            (c13 == 28) &&

            (c20 == 44) &&
            (c21 == 40) &&
            (c22 == 40) &&
            (c23 == 44) &&

            (c30 == 60) &&
            (c31 == 56) &&
            (c32 == 56) &&
            (c33 == 60)) begin

            $display("");

            $display("========================================");

            $display("AI COMPUTE ENGINE TEST PASSED");

            $display("========================================");

        end

        else begin

            $display("");

            $display("========================================");

            $display("AI COMPUTE ENGINE TEST FAILED");

            $display("========================================");

        end


        #20;

        $finish;

    end


    // =========================================================
    // WAVEFORM
    // =========================================================

    initial begin

        $dumpfile("ai_compute_engine.vcd");

        $dumpvars(0,tb_ai_compute_engine);

    end

endmodule