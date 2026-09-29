`timescale 1ns/1ps

module tb_ai_dot4;

    reg [31:0] a;
    reg [31:0] b;

    wire [31:0] result;


    // =========================================================
    // Instantiate AI DOT4
    // =========================================================

    ai_dot4 DUT (

        .a(a),
        .b(b),

        .result(result)

    );


    // =========================================================
    // Test
    // =========================================================

    initial begin

        $display("========================================");
        $display("AI INT8 DOT4 ACCELERATOR TEST");
        $display("========================================");


        // =====================================================
        // TEST 1
        //
        // A = [1,2,3,4]
        // B = [5,6,7,8]
        //
        // 1*5 + 2*6 + 3*7 + 4*8
        // = 70
        // =====================================================

        a = 32'h04030201;
        b = 32'h08070605;

        #10;

        $display("");
        $display("TEST 1");
        $display("A      = %h", a);
        $display("B      = %h", b);
        $display("Result = %d", result);

        if (result == 32'd70)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 2
        //
        // A = [10,20,30,40]
        // B = [1,2,3,4]
        //
        // = 10 + 40 + 90 + 160
        // = 300
        // =====================================================

        a = 32'h281E140A;
        b = 32'h04030201;

        #10;

        $display("");
        $display("TEST 2");
        $display("A      = %h", a);
        $display("B      = %h", b);
        $display("Result = %d", result);

        if (result == 32'd300)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 3
        //
        // Negative INT8 values
        //
        // A = [-1,-2,-3,-4]
        // B = [ 1, 2, 3, 4]
        //
        // = -1 -4 -9 -16
        // = -30
        // =====================================================

        a = 32'hFCFDFEFF;
        b = 32'h04030201;

        #10;

        $display("");
        $display("TEST 3 - SIGNED INT8");
        $display("A      = %h", a);
        $display("B      = %h", b);
        $display("Result = %d", $signed(result));

        if ($signed(result) == -32'sd30)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 4
        //
        // Mixed positive/negative values
        //
        // A = [-5, 10, -15, 20]
        // B = [ 2,-3,  4,-5]
        //
        // = -10 -30 -60 -100
        // = -200
        // =====================================================

        a = 32'h14F10AFB;
        b = 32'hFB04FD02;

        #10;

        $display("");
        $display("TEST 4 - MIXED SIGNED VALUES");
        $display("A      = %h", a);
        $display("B      = %h", b);
        $display("Result = %d", $signed(result));

        if ($signed(result) == -32'sd200)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 5
        //
        // Zero vector
        // =====================================================

        a = 32'h00000000;
        b = 32'h12345678;

        #10;

        $display("");
        $display("TEST 5 - ZERO");
        $display("Result = %d", result);

        if (result == 32'd0)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // COMPLETE
        // =====================================================

        $display("");
        $display("========================================");
        $display("AI DOT4 TEST COMPLETE");
        $display("========================================");

        #10;

        $finish;

    end


    // =========================================================
    // Waveform
    // =========================================================

    initial begin

        $dumpfile("ai_dot4.vcd");

        $dumpvars(0, tb_ai_dot4);

    end

endmodule