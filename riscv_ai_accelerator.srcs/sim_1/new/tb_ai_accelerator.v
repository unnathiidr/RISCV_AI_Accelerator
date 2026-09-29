`timescale 1ns/1ps

module tb_ai_accelerator;

    reg clk;
    reg rst;
    reg start;

    reg signed [7:0] a0;
    reg signed [7:0] a1;
    reg signed [7:0] a2;
    reg signed [7:0] a3;

    reg signed [7:0] b0;
    reg signed [7:0] b1;
    reg signed [7:0] b2;
    reg signed [7:0] b3;

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

    ai_accelerator DUT (

        .clk(clk),
        .rst(rst),

        .start(start),

        .busy(busy),
        .done(done),

        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),

        .b0(b0),
        .b1(b1),
        .b2(b2),
        .b3(b3),

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
    // DRIVE ONE CYCLE
    // =========================================================

    task drive_cycle;

        input signed [7:0] va0;
        input signed [7:0] va1;
        input signed [7:0] va2;
        input signed [7:0] va3;

        input signed [7:0] vb0;
        input signed [7:0] vb1;
        input signed [7:0] vb2;
        input signed [7:0] vb3;

        begin

            @(negedge clk);

            a0 = va0;
            a1 = va1;
            a2 = va2;
            a3 = va3;

            b0 = vb0;
            b1 = vb1;
            b2 = vb2;
            b3 = vb3;

        end

    endtask


    // =========================================================
    // TEST
    // =========================================================

    initial begin

        rst = 1'b1;
        start = 1'b0;

        a0 = 0;
        a1 = 0;
        a2 = 0;
        a3 = 0;

        b0 = 0;
        b1 = 0;
        b2 = 0;
        b3 = 0;


        // =====================================================
        // RESET
        // =====================================================

        #20;

        rst = 1'b0;

        #10;


        // =====================================================
        // START ACCELERATOR
        // =====================================================

        @(negedge clk);

        start = 1'b1;

        @(negedge clk);

        start = 1'b0;


        // =====================================================
        // MATRIX A
        //
        //  1   2   3   4
        //  5   6   7   8
        //  9  10  11  12
        // 13  14  15  16
        //
        // B = Identity
        //
        // 1 0 0 0
        // 0 1 0 0
        // 0 0 1 0
        // 0 0 0 1
        // =====================================================


        // t0

        drive_cycle(
            1, 0, 0, 0,
            1, 0, 0, 0
        );


        // t1

        drive_cycle(
            2, 5, 0, 0,
            0, 0, 0, 0
        );


        // t2

        drive_cycle(
            3, 6, 9, 0,
            0, 1, 0, 0
        );


        // t3

        drive_cycle(
            4, 7, 10, 13,
            0, 0, 0, 0
        );


        // t4

        drive_cycle(
            0, 8, 11, 14,
            0, 0, 1, 0
        );


        // t5

        drive_cycle(
            0, 0, 12, 15,
            0, 0, 0, 0
        );


        // t6

        drive_cycle(
            0, 0, 0, 16,
            0, 0, 0, 1
        );


        // Flush

        drive_cycle(
            0, 0, 0, 0,
            0, 0, 0, 0
        );

        drive_cycle(
            0, 0, 0, 0,
            0, 0, 0, 0
        );

        drive_cycle(
            0, 0, 0, 0,
            0, 0, 0, 0
        );


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
        $display("AI ACCELERATOR TEST");
        $display("========================================");

        $display("");
        $display("BUSY = %b", busy);
        $display("DONE = %b", done);

        $display("");
        $display("RESULT MATRIX:");

        $display("%d  %d  %d  %d",
                 c00, c01, c02, c03);

        $display("%d  %d  %d  %d",
                 c10, c11, c12, c13);

        $display("%d  %d  %d  %d",
                 c20, c21, c22, c23);

        $display("%d  %d  %d  %d",
                 c30, c31, c32, c33);


        // =====================================================
        // CHECK
        // =====================================================

        if ((c00 == 1)  &&
            (c01 == 2)  &&
            (c02 == 3)  &&
            (c03 == 4)  &&

            (c10 == 5)  &&
            (c11 == 6)  &&
            (c12 == 7)  &&
            (c13 == 8)  &&

            (c20 == 9)  &&
            (c21 == 10) &&
            (c22 == 11) &&
            (c23 == 12) &&

            (c30 == 13) &&
            (c31 == 14) &&
            (c32 == 15) &&
            (c33 == 16)) begin

            $display("");
            $display("========================================");
            $display("AI ACCELERATOR TEST PASSED");
            $display("========================================");

        end

        else begin

            $display("");
            $display("========================================");
            $display("AI ACCELERATOR TEST FAILED");
            $display("========================================");

        end


        #20;

        $finish;

    end


    // =========================================================
    // WAVEFORM
    // =========================================================

    initial begin

        $dumpfile("ai_accelerator.vcd");

        $dumpvars(0,tb_ai_accelerator);

    end

endmodule