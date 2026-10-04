`timescale 1ns/1ps

module tb_ai_accel_controller;

    reg clk;
    reg rst;

    reg start;

    reg [7:0] compute_cycles;

    wire busy;
    wire done;

    wire load_enable;
    wire compute_enable;

    wire [1:0] state;


    // =========================================================
    // DUT
    // =========================================================

    ai_accel_controller DUT (

        .clk(clk),
        .rst(rst),

        .start(start),

        .compute_cycles(compute_cycles),

        .busy(busy),
        .done(done),

        .load_enable(load_enable),
        .compute_enable(compute_enable),

        .state(state)

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

        compute_cycles = 8'd4;


        // =====================================================
        // RESET
        // =====================================================

        #20;

        rst = 1'b0;

        #10;


        // =====================================================
        // TEST 1
        //
        // Controller should be IDLE
        // =====================================================

        $display("");
        $display("========================================");
        $display("TEST 1 - IDLE");
        $display("========================================");

        $display("BUSY = %b", busy);
        $display("DONE = %b", done);

        if ((busy == 1'b0) &&
            (done == 1'b0))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 2
        //
        // START
        // =====================================================

        @(negedge clk);

        start = 1'b1;

        @(negedge clk);

        start = 1'b0;

        #1;

        $display("");
        $display("========================================");
        $display("TEST 2 - LOAD");
        $display("========================================");

        $display("BUSY        = %b", busy);
        $display("LOAD_ENABLE = %b", load_enable);
        $display("DONE        = %b", done);

        if ((busy == 1'b1) &&
            (load_enable == 1'b1) &&
            (done == 1'b0))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 3
        //
        // COMPUTE
        // =====================================================

        @(negedge clk);

        #1;

        $display("");
        $display("========================================");
        $display("TEST 3 - COMPUTE");
        $display("========================================");

        $display("BUSY           = %b", busy);
        $display("COMPUTE_ENABLE = %b", compute_enable);

        if ((busy == 1'b1) &&
            (compute_enable == 1'b1))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 4
        //
        // Wait for computation to finish
        // =====================================================

        repeat (4)
            @(negedge clk);

        #1;

        $display("");
        $display("========================================");
        $display("TEST 4 - DONE");
        $display("========================================");

        $display("BUSY = %b", busy);
        $display("DONE = %b", done);

        if ((busy == 1'b0) &&
            (done == 1'b1))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 5
        //
        // DONE should return to IDLE
        // =====================================================

        @(negedge clk);

        #1;

        $display("");
        $display("========================================");
        $display("TEST 5 - RETURN TO IDLE");
        $display("========================================");

        $display("BUSY = %b", busy);
        $display("DONE = %b", done);

        if ((busy == 1'b0) &&
            (done == 1'b0))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // COMPLETE
        // =====================================================

        $display("");
        $display("========================================");
        $display("AI ACCELERATOR CONTROLLER TEST COMPLETE");
        $display("========================================");

        #20;

        $finish;

    end


    // =========================================================
    // WAVEFORM
    // =========================================================

    initial begin

        $dumpfile("ai_accel_controller.vcd");

        $dumpvars(0, tb_ai_accel_controller);

    end

endmodule