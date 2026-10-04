`timescale 1ns/1ps

module tb_riscv_regfile;

    reg clk;
    reg rst;

    reg [4:0] rs1_addr;
    reg [4:0] rs2_addr;

    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    reg rd_we;
    reg [4:0] rd_addr;
    reg [31:0] rd_data;


    // =========================================================
    // Instantiate Register File
    // =========================================================

    riscv_regfile DUT (

        .clk(clk),
        .rst(rst),

        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data),

        .rd_we(rd_we),
        .rd_addr(rd_addr),
        .rd_data(rd_data)

    );


    // =========================================================
    // Clock generation
    // 10 ns period = 100 MHz
    // =========================================================

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end


    // =========================================================
    // Test sequence
    // =========================================================

    initial begin

        // Initial values
        rst      = 1'b1;

        rs1_addr = 5'd0;
        rs2_addr = 5'd0;

        rd_we    = 1'b0;
        rd_addr  = 5'd0;
        rd_data  = 32'd0;


        // -----------------------------------------------------
        // RESET
        // -----------------------------------------------------

        #20;

        rst = 1'b0;

        $display("----------------------------------------");
        $display("RESET COMPLETE");
        $display("----------------------------------------");


        // =====================================================
        // TEST 1
        // Write 100 into x5
        // =====================================================

        @(negedge clk);

        rd_we   = 1'b1;
        rd_addr = 5'd5;
        rd_data = 32'd100;

        @(negedge clk);

        rd_we = 1'b0;


        // Read x5
        rs1_addr = 5'd5;

        #2;

        $display("TEST 1:");
        $display("x5 = %d", rs1_data);

        if (rs1_data == 32'd100)
            $display("PASS: x5 contains 100");
        else
            $display("FAIL: x5 does not contain 100");


        // =====================================================
        // TEST 2
        // Write 200 into x10
        // =====================================================

        @(negedge clk);

        rd_we   = 1'b1;
        rd_addr = 5'd10;
        rd_data = 32'd200;

        @(negedge clk);

        rd_we = 1'b0;


        // Read x10
        rs1_addr = 5'd10;

        #2;

        $display("");
        $display("TEST 2:");
        $display("x10 = %d", rs1_data);

        if (rs1_data == 32'd200)
            $display("PASS: x10 contains 200");
        else
            $display("FAIL: x10 does not contain 200");


        // =====================================================
        // TEST 3
        // Test TWO read ports simultaneously
        // =====================================================

        rs1_addr = 5'd5;
        rs2_addr = 5'd10;

        #2;

        $display("");
        $display("TEST 3:");
        $display("rs1 = x5  = %d", rs1_data);
        $display("rs2 = x10 = %d", rs2_data);

        if ((rs1_data == 32'd100) &&
            (rs2_data == 32'd200))
            $display("PASS: dual read ports working");
        else
            $display("FAIL: dual read ports");


        // =====================================================
        // TEST 4
        // Verify x0 is ALWAYS zero
        // =====================================================

        rs1_addr = 5'd0;

        #2;

        $display("");
        $display("TEST 4:");
        $display("x0 = %d", rs1_data);

        if (rs1_data == 32'd0)
            $display("PASS: x0 is zero");
        else
            $display("FAIL: x0 is not zero");


        // =====================================================
        // TEST 5
        // Attempt to write x0
        // =====================================================

        @(negedge clk);

        rd_we   = 1'b1;
        rd_addr = 5'd0;
        rd_data = 32'hFFFFFFFF;

        @(negedge clk);

        rd_we = 1'b0;

        rs1_addr = 5'd0;

        #2;

        $display("");
        $display("TEST 5:");
        $display("Attempted x0 = FFFFFFFF");
        $display("Actual x0    = %h", rs1_data);

        if (rs1_data == 32'd0)
            $display("PASS: x0 cannot be modified");
        else
            $display("FAIL: x0 was modified");


        // =====================================================
        // END
        // =====================================================

        $display("");
        $display("========================================");
        $display("REGISTER FILE TEST COMPLETE");
        $display("========================================");

        #20;

        $finish;

    end


    // =========================================================
    // Waveform dump
    // =========================================================

    initial begin

        $dumpfile("riscv_regfile.vcd");

        $dumpvars(0, tb_riscv_regfile);

    end

endmodule