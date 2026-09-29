`timescale 1ns/1ps

module tb_ai_pe;

    reg clk;
    reg rst;

    reg enable;

    reg signed [7:0] a_in;
    reg signed [7:0] b_in;

    wire signed [7:0] a_out;
    wire signed [7:0] b_out;

    wire signed [31:0] accumulator;


    // =========================================================
    // DUT
    // =========================================================

    ai_pe DUT (

        .clk(clk),
        .rst(rst),

        .enable(enable),

        .a_in(a_in),
        .b_in(b_in),

        .a_out(a_out),
        .b_out(b_out),

        .accumulator(accumulator)

    );


    // =========================================================
    // Clock
    // =========================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    // =========================================================
    // Test
    // =========================================================

    initial begin

        rst = 1'b1;

        enable = 1'b0;

        a_in = 8'sd0;
        b_in = 8'sd0;

        #20;

        rst = 1'b0;


        // =====================================================
        // TEST 1
        //
        // 5 × 3 = 15
        // =====================================================

        @(negedge clk);

        enable = 1'b1;

        a_in = 8'sd5;
        b_in = 8'sd3;

        @(negedge clk);

        $display("TEST 1");
        $display("A = %d", a_in);
        $display("B = %d", b_in);
        $display("ACC = %d", accumulator);

        if (accumulator == 32'sd15)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 2
        //
        // 4 × 6 = 24
        //
        // Accumulator = 15 + 24 = 39
        // =====================================================

        a_in = 8'sd4;
        b_in = 8'sd6;

        @(negedge clk);

        $display("");
        $display("TEST 2");
        $display("ACC = %d", accumulator);

        if (accumulator == 32'sd39)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 3
        //
        // -5 × 4 = -20
        //
        // 39 - 20 = 19
        // =====================================================

        a_in = -8'sd5;
        b_in = 8'sd4;

        @(negedge clk);

        $display("");
        $display("TEST 3 - SIGNED");
        $display("ACC = %d", accumulator);

        if (accumulator == 32'sd19)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 4
        //
        // Check operand propagation
        // =====================================================

        a_in = 8'sd11;
        b_in = -8'sd2;

        @(negedge clk);

        #1;

        $display("");
        $display("TEST 4 - OPERAND PROPAGATION");
        $display("A OUT = %d", a_out);
        $display("B OUT = %d", b_out);

        if ((a_out == 8'sd11) &&
            (b_out == -8'sd2))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
// TEST 5
//
// Disable PE
//
// Accumulator must not change
// =====================================================

enable = 1'b0;

a_in = 8'sd100;
b_in = 8'sd100;

@(negedge clk);

$display("");
$display("TEST 5 - DISABLE");
$display("ACC = %d", accumulator);

if (accumulator == -32'sd3)
    $display("PASS");
else
    $display("FAIL");


        // =====================================================
        // COMPLETE
        // =====================================================

        $display("");
        $display("========================================");
        $display("AI PE TEST COMPLETE");
        $display("========================================");

        #20;

        $finish;

    end


    // =========================================================
    // Waveform
    // =========================================================

    initial begin

        $dumpfile("ai_pe.vcd");

        $dumpvars(0,tb_ai_pe);

    end

endmodule