`timescale 1ns/1ps

module tb_riscv_pipeline;

    reg clk;
    reg rst;

    // =========================================================
    // Instruction memory interface
    // =========================================================

    wire [31:0] imem_addr;
    reg  [31:0] imem_rdata;


    // =========================================================
    // Data memory interface
    // =========================================================

    wire        dmem_we;
    wire        dmem_re;

    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;

    reg  [31:0] dmem_rdata;


    // =========================================================
    // Simple memories
    // =========================================================

    reg [31:0] instruction_memory [0:63];

    reg [31:0] data_memory [0:63];

    integer i;


    // =========================================================
    // DUT
    // =========================================================

    riscv_pipeline DUT (

        .clk(clk),
        .rst(rst),

        .imem_addr(imem_addr),
        .imem_rdata(imem_rdata),

        .dmem_we(dmem_we),
        .dmem_re(dmem_re),

        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),

        .dmem_rdata(dmem_rdata)

    );


    // =========================================================
    // Clock
    // 100 MHz
    // =========================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    // =========================================================
    // Instruction memory
    //
    // Word addressed:
    // imem_addr >> 2
    // =========================================================

    always @(*) begin

        if (imem_addr[31:2] < 64)
            imem_rdata =
                instruction_memory[imem_addr[7:2]];

        else
            imem_rdata = 32'h00000013;

    end


    // =========================================================
    // Data memory read
    // =========================================================

    always @(*) begin

        if (dmem_addr[31:2] < 64)
            dmem_rdata =
                data_memory[dmem_addr[7:2]];

        else
            dmem_rdata = 32'd0;

    end


    // =========================================================
    // Data memory write
    // =========================================================

    always @(posedge clk) begin

        if (dmem_we) begin

            if (dmem_addr[31:2] < 64)
                data_memory[dmem_addr[7:2]]
                    <= dmem_wdata;

        end

    end


    // =========================================================
    // Test program
    // =========================================================

    initial begin

        // Clear memories

        for (i = 0; i < 64; i = i + 1) begin

            instruction_memory[i] = 32'h00000013;

            data_memory[i] = 32'd0;

        end


        // =====================================================
        // Program
        // =====================================================

        /*
         * ADDI x1,x0,10
         *
         * x1 = 10
         */

        instruction_memory[0] =
            {12'd10,
             5'd0,
             3'b000,
             5'd1,
             7'b0010011};


        /*
         * ADDI x2,x0,20
         *
         * x2 = 20
         */

        instruction_memory[1] =
            {12'd20,
             5'd0,
             3'b000,
             5'd2,
             7'b0010011};


        /*
         * ADD x3,x1,x2
         *
         * x3 = 10 + 20
         *
         * This exercises forwarding.
         */

        instruction_memory[2] =
            {7'b0000000,
             5'd2,
             5'd1,
             3'b000,
             5'd3,
             7'b0110011};


        /*
         * SUB x4,x3,x1
         *
         * x4 = 30 - 10
         *
         * More forwarding.
         */

        instruction_memory[3] =
            {7'b0100000,
             5'd1,
             5'd3,
             3'b000,
             5'd4,
             7'b0110011};


        /*
         * AI_DOT4 x5,x3,x4
         *
         * Custom AI instruction.
         *
         * The operands currently contain:
         *
         * x3 = 30
         * x4 = 20
         *
         * Since the AI unit treats each register as
         * four packed INT8 values, this is primarily
         * an integration test.
         */

        instruction_memory[4] =
            {7'b0000001,
             5'd4,
             5'd3,
             3'b000,
             5'd5,
             7'b0001011};


        /*
         * NOP
         */

        instruction_memory[5] =
            32'h00000013;

        instruction_memory[6] =
            32'h00000013;

        instruction_memory[7] =
            32'h00000013;

    end


    // =========================================================
    // Reset and simulation
    // =========================================================

    initial begin

        rst = 1'b1;

        #30;

        rst = 1'b0;

        $display("");
        $display("========================================");
        $display("5-STAGE RISC-V PIPELINE TEST");
        $display("========================================");

        /*
         * Run enough cycles for the instructions
         * to travel through the pipeline.
         */

        #200;

        $display("");
        $display("========================================");
        $display("REGISTER VALUES");
        $display("========================================");

        $display("x1 = %d", DUT.REGFILE.regs[1]);
        $display("x2 = %d", DUT.REGFILE.regs[2]);
        $display("x3 = %d", DUT.REGFILE.regs[3]);
        $display("x4 = %d", DUT.REGFILE.regs[4]);
        $display("x5 = %d", DUT.REGFILE.regs[5]);

        $display("");
        $display("PIPELINE TEST COMPLETE");
        $display("========================================");

        $finish;

    end


    // =========================================================
    // Waveform
    // =========================================================

    initial begin

        $dumpfile("riscv_pipeline.vcd");

        $dumpvars(0, tb_riscv_pipeline);

    end

endmodule