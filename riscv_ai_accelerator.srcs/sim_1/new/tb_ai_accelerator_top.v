`timescale 1ns/1ps

module tb_ai_accelerator_top;

    reg clk;
    reg rst;

    // =========================================================
    // WRITE INTERFACE
    // =========================================================

    reg        write_enable;
    reg [5:0]  write_addr;
    reg [31:0] write_data;

    // =========================================================
    // CONTROL
    // =========================================================

    reg start;

    // =========================================================
    // STATUS
    // =========================================================

    wire busy;
    wire done;

    // =========================================================
    // READ INTERFACE
    // =========================================================

    reg [6:0] read_addr;
    wire [31:0] read_data;


    // =========================================================
    // DUT
    // =========================================================

    ai_accelerator_top DUT (

        .clk(clk),
        .rst(rst),

        .write_enable(write_enable),
        .write_addr(write_addr),
        .write_data(write_data),

        .start(start),

        .busy(busy),
        .done(done),

        .read_addr(read_addr),
        .read_data(read_data)

    );


    // =========================================================
    // CLOCK
    // =========================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    // =========================================================
    // CPU WRITE TASK
    // =========================================================

    task cpu_write;

        input [5:0] addr;
        input [31:0] data;

        begin

            @(negedge clk);

            write_addr   = addr;
            write_data   = data;
            write_enable = 1'b1;

            @(negedge clk);

            write_enable = 1'b0;

            write_addr = 6'd0;
            write_data = 32'd0;

        end

    endtask


    // =========================================================
    // CPU READ FUNCTION
    // =========================================================

    task cpu_read_check;

        input [6:0] addr;
        input signed [31:0] expected;

        begin

            read_addr = addr;

            #2;

            $display(
                "READ 0x%02h = %d | EXPECTED = %d",
                addr,
                $signed(read_data),
                expected
            );

            if ($signed(read_data) == expected)

                $display("PASS");

            else

                $display("FAIL");

        end

    endtask


    // =========================================================
    // MAIN TEST
    // =========================================================

    initial begin

        rst = 1'b1;

        write_enable = 1'b0;
        write_addr = 6'd0;
        write_data = 32'd0;

        start = 1'b0;

        read_addr = 7'd0;


        // =====================================================
        // RESET
        // =====================================================

        #20;

        rst = 1'b0;


        $display("");
        $display("========================================");
        $display("FULL AI ACCELERATOR TOP TEST");
        $display("========================================");


        // =====================================================
        // MATRIX A
        // =====================================================

        $display("");
        $display("WRITING MATRIX A...");

        cpu_write(
            6'h00,
            {8'd4,8'd3,8'd2,8'd1}
        );

        cpu_write(
            6'h04,
            {8'd8,8'd7,8'd6,8'd5}
        );

        cpu_write(
            6'h08,
            {8'd12,8'd11,8'd10,8'd9}
        );

        cpu_write(
            6'h0C,
            {8'd16,8'd15,8'd14,8'd13}
        );


        // =====================================================
        // MATRIX B
        // =====================================================

        $display("");
        $display("WRITING MATRIX B...");

        cpu_write(
            6'h10,
            {8'd0,8'd1,8'd2,8'd1}
        );

        cpu_write(
            6'h14,
            {8'd1,8'd2,8'd1,8'd0}
        );

        cpu_write(
            6'h18,
            {8'd2,8'd1,8'd0,8'd1}
        );

        cpu_write(
            6'h1C,
            {8'd1,8'd0,8'd1,8'd2}
        );


        // =====================================================
        // START
        // =====================================================

        $display("");
        $display("STARTING ACCELERATOR...");

        @(negedge clk);

        start = 1'b1;

        @(negedge clk);

        start = 1'b0;


        // =====================================================
        // WAIT FOR DONE
        // =====================================================

        wait(done);

        #2;


        $display("");
        $display("ACCELERATOR FINISHED");

        $display("BUSY = %b", busy);
        $display("DONE = %b", done);


        // =====================================================
        // STATUS REGISTER
        // =====================================================

        $display("");
        $display("STATUS REGISTER:");

        read_addr = 7'h24;

        #2;

        $display(
            "STATUS = %b",
            read_data[1:0]
        );


        // =====================================================
        // READ COMPLETE MATRIX
        // =====================================================

        $display("");
        $display("========================================");
        $display("RESULT MATRIX");
        $display("========================================");


        $display("");
        $display("ROW 0:");

        cpu_read_check(7'h28, 12);
        cpu_read_check(7'h2C, 8);
        cpu_read_check(7'h30, 8);
        cpu_read_check(7'h34, 12);


        $display("");
        $display("ROW 1:");

        cpu_read_check(7'h38, 28);
        cpu_read_check(7'h3C, 24);
        cpu_read_check(7'h40, 24);
        cpu_read_check(7'h44, 28);


        $display("");
        $display("ROW 2:");

        cpu_read_check(7'h48, 44);
        cpu_read_check(7'h4C, 40);
        cpu_read_check(7'h50, 40);
        cpu_read_check(7'h54, 44);


        $display("");
        $display("ROW 3:");

        cpu_read_check(7'h58, 60);
        cpu_read_check(7'h5C, 56);
        cpu_read_check(7'h60, 56);
        cpu_read_check(7'h64, 60);


        // =====================================================
        // FINAL STATUS
        // =====================================================

        $display("");
        $display("========================================");
        $display("FULL AI ACCELERATOR TEST COMPLETE");
        $display("========================================");


        #20;

        $finish;

    end


    // =========================================================
    // WAVEFORM
    // =========================================================

    initial begin

        $dumpfile("ai_accelerator_top.vcd");

        $dumpvars(0,tb_ai_accelerator_top);

    end

endmodule