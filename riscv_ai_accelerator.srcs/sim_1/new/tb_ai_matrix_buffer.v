`timescale 1ns/1ps

module tb_ai_matrix_buffer;

    reg clk;
    reg rst;


    // =========================================================
    // Matrix A interface
    // =========================================================

    reg        a_write_enable;
    reg [1:0]  a_write_addr;
    reg [31:0] a_write_data;

    reg [1:0]  a_read_addr;
    wire [31:0] a_read_data;


    // =========================================================
    // Matrix B interface
    // =========================================================

    reg        b_write_enable;
    reg [1:0]  b_write_addr;
    reg [31:0] b_write_data;

    reg [1:0]  b_read_addr;
    wire [31:0] b_read_data;


    // =========================================================
    // DUT
    // =========================================================

    ai_matrix_buffer DUT (

        .clk(clk),
        .rst(rst),

        .a_write_enable(a_write_enable),
        .a_write_addr(a_write_addr),
        .a_write_data(a_write_data),

        .b_write_enable(b_write_enable),
        .b_write_addr(b_write_addr),
        .b_write_data(b_write_data),

        .a_read_addr(a_read_addr),
        .a_read_data(a_read_data),

        .b_read_addr(b_read_addr),
        .b_read_data(b_read_data)

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

        a_write_enable = 1'b0;
        b_write_enable = 1'b0;

        a_write_addr = 2'd0;
        b_write_addr = 2'd0;

        a_write_data = 32'd0;
        b_write_data = 32'd0;

        a_read_addr = 2'd0;
        b_read_addr = 2'd0;


        // =====================================================
        // RESET
        // =====================================================

        #20;

        rst = 1'b0;


        // =====================================================
        // WRITE MATRIX A
        //
        // A =
        //
        //  1   2   3   4
        //  5   6   7   8
        //  9  10  11  12
        // 13  14  15  16
        // =====================================================

        @(negedge clk);

        a_write_enable = 1'b1;
        a_write_addr = 2'd0;

        a_write_data = {
            8'd4,
            8'd3,
            8'd2,
            8'd1
        };


        @(negedge clk);

        a_write_addr = 2'd1;

        a_write_data = {
            8'd8,
            8'd7,
            8'd6,
            8'd5
        };


        @(negedge clk);

        a_write_addr = 2'd2;

        a_write_data = {
            8'd12,
            8'd11,
            8'd10,
            8'd9
        };


        @(negedge clk);

        a_write_addr = 2'd3;

        a_write_data = {
            8'd16,
            8'd15,
            8'd14,
            8'd13
        };


        @(negedge clk);

        a_write_enable = 1'b0;


        // =====================================================
        // WRITE MATRIX B
        //
        // Identity matrix
        //
        // 1 0 0 0
        // 0 1 0 0
        // 0 0 1 0
        // 0 0 0 1
        // =====================================================

        b_write_enable = 1'b1;

        b_write_addr = 2'd0;

        b_write_data = {
            8'd0,
            8'd0,
            8'd0,
            8'd1
        };


        @(negedge clk);

        b_write_addr = 2'd1;

        b_write_data = {
            8'd0,
            8'd0,
            8'd1,
            8'd0
        };


        @(negedge clk);

        b_write_addr = 2'd2;

        b_write_data = {
            8'd0,
            8'd1,
            8'd0,
            8'd0
        };


        @(negedge clk);

        b_write_addr = 2'd3;

        b_write_data = {
            8'd1,
            8'd0,
            8'd0,
            8'd0
        };


        @(negedge clk);

        b_write_enable = 1'b0;


        // =====================================================
        // READ BACK MATRIX A
        // =====================================================

        a_read_addr = 2'd0;

        #2;

        $display("");
        $display("========================================");
        $display("MATRIX BUFFER TEST");
        $display("========================================");

        $display("");
        $display("A ROW 0 = %h", a_read_data);


        if (a_read_data ==
            {8'd4,8'd3,8'd2,8'd1})

            $display("A ROW 0 PASS");

        else

            $display("A ROW 0 FAIL");


        a_read_addr = 2'd1;

        #2;

        $display("A ROW 1 = %h", a_read_data);

        if (a_read_data ==
            {8'd8,8'd7,8'd6,8'd5})

            $display("A ROW 1 PASS");

        else

            $display("A ROW 1 FAIL");


        // =====================================================
        // READ MATRIX B
        // =====================================================

        b_read_addr = 2'd0;

        #2;

        $display("");
        $display("B ROW 0 = %h", b_read_data);

        if (b_read_data ==
            {8'd0,8'd0,8'd0,8'd1})

            $display("B ROW 0 PASS");

        else

            $display("B ROW 0 FAIL");


        b_read_addr = 2'd3;

        #2;

        $display("B ROW 3 = %h", b_read_data);

        if (b_read_data ==
            {8'd1,8'd0,8'd0,8'd0})

            $display("B ROW 3 PASS");

        else

            $display("B ROW 3 FAIL");


        // =====================================================
        // COMPLETE
        // =====================================================

        $display("");
        $display("========================================");
        $display("MATRIX BUFFER TEST COMPLETE");
        $display("========================================");

        #20;

        $finish;

    end


    // =========================================================
    // WAVEFORM
    // =========================================================

    initial begin

        $dumpfile("ai_matrix_buffer.vcd");

        $dumpvars(0, tb_ai_matrix_buffer);

    end

endmodule