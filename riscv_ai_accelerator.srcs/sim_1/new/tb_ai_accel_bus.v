`timescale 1ns/1ps

module tb_ai_accel_bus;

    reg clk;
    reg rst;

    // =========================================================
    // BUS WRITE
    // =========================================================

    reg        bus_write_enable;
    reg [6:0]  bus_write_addr;
    reg [31:0] bus_write_data;

    // =========================================================
    // BUS READ
    // =========================================================

    reg        bus_read_enable;
    reg [6:0]  bus_read_addr;

    wire [31:0] bus_read_data;

    // =========================================================
    // STATUS
    // =========================================================

    wire busy;
    wire done;


    // =========================================================
    // DUT
    // =========================================================

    ai_accel_bus DUT (

        .clk(clk),
        .rst(rst),

        .bus_write_enable(bus_write_enable),
        .bus_write_addr(bus_write_addr),
        .bus_write_data(bus_write_data),

        .bus_read_enable(bus_read_enable),
        .bus_read_addr(bus_read_addr),

        .bus_read_data(bus_read_data),

        .busy(busy),
        .done(done)

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

        input [6:0] addr;
        input [31:0] data;

        begin

            @(negedge clk);

            bus_write_addr   = addr;
            bus_write_data   = data;
            bus_write_enable = 1'b1;

            @(negedge clk);

            bus_write_enable = 1'b0;

            bus_write_addr = 7'd0;
            bus_write_data = 32'd0;

        end

    endtask


    // =========================================================
    // CPU READ TASK
    // =========================================================

    task cpu_read;

        input [6:0] addr;

        begin

            bus_read_addr   = addr;
            bus_read_enable = 1'b1;

            #2;

            $display(
                "READ 0x%02h = %d",
                addr,
                $signed(bus_read_data)
            );

            bus_read_enable = 1'b0;

        end

    endtask


    // =========================================================
    // MAIN TEST
    // =========================================================

    initial begin

        // -----------------------------------------------------
        // INITIALIZATION
        // -----------------------------------------------------

        rst = 1'b1;

        bus_write_enable = 1'b0;
        bus_write_addr = 7'd0;
        bus_write_data = 32'd0;

        bus_read_enable = 1'b0;
        bus_read_addr = 7'd0;


        // -----------------------------------------------------
        // RESET
        // -----------------------------------------------------

        #20;

        rst = 1'b0;


        $display("");
        $display("========================================");
        $display("RISC-V / AI ACCELERATOR BUS TEST");
        $display("========================================");


        // =====================================================
        // WRITE MATRIX A
        // =====================================================

        $display("");
        $display("CPU WRITING MATRIX A...");


        cpu_write(
            7'h00,
            {8'd4,8'd3,8'd2,8'd1}
        );


        cpu_write(
            7'h04,
            {8'd8,8'd7,8'd6,8'd5}
        );


        cpu_write(
            7'h08,
            {8'd12,8'd11,8'd10,8'd9}
        );


        cpu_write(
            7'h0C,
            {8'd16,8'd15,8'd14,8'd13}
        );


        // =====================================================
        // WRITE MATRIX B
        // =====================================================

        $display("");
        $display("CPU WRITING MATRIX B...");


        cpu_write(
            7'h10,
            {8'd0,8'd1,8'd2,8'd1}
        );


        cpu_write(
            7'h14,
            {8'd1,8'd2,8'd1,8'd0}
        );


        cpu_write(
            7'h18,
            {8'd2,8'd1,8'd0,8'd1}
        );


        cpu_write(
            7'h1C,
            {8'd1,8'd0,8'd1,8'd2}
        );


        // =====================================================
        // START ACCELERATOR
        // =====================================================

        $display("");
        $display("CPU STARTING ACCELERATOR...");


        cpu_write(
            7'h20,
            32'h00000001
        );


        // =====================================================
        // POLL STATUS
        // =====================================================

        $display("");
        $display("POLLING STATUS...");


        wait(done);


        $display("");
        $display("ACCELERATOR DONE");
        $display("BUSY = %b", busy);
        $display("DONE = %b", done);


        // =====================================================
        // READ STATUS REGISTER
        // =====================================================

        $display("");

        cpu_read(7'h24);


        // =====================================================
        // READ RESULT MATRIX
        // =====================================================

        $display("");
        $display("========================================");
        $display("RESULT MATRIX");
        $display("========================================");


        $display("");
        $display("ROW 0");

        cpu_read(7'h28);
        cpu_read(7'h2C);
        cpu_read(7'h30);
        cpu_read(7'h34);


        $display("");
        $display("ROW 1");

        cpu_read(7'h38);
        cpu_read(7'h3C);
        cpu_read(7'h40);
        cpu_read(7'h44);


        $display("");
        $display("ROW 2");

        cpu_read(7'h48);
        cpu_read(7'h4C);
        cpu_read(7'h50);
        cpu_read(7'h54);


        $display("");
        $display("ROW 3");

        cpu_read(7'h58);
        cpu_read(7'h5C);
        cpu_read(7'h60);
        cpu_read(7'h64);


        // =====================================================
        // FINAL
        // =====================================================

        $display("");
        $display("========================================");
        $display("RISC-V / AI BUS TEST COMPLETE");
        $display("========================================");


        #20;

        $finish;

    end


    // =========================================================
    // WAVEFORM
    // =========================================================

    initial begin

        $dumpfile("ai_accel_bus.vcd");

        $dumpvars(0,tb_ai_accel_bus);

    end

endmodule