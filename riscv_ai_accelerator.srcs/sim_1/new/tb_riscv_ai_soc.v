`timescale 1ns/1ps

module tb_riscv_ai_soc;

    reg clk;
    reg rst;

    // =========================================================
    // INSTRUCTION MEMORY
    // =========================================================

    wire [31:0] imem_addr;
    reg  [31:0] imem_rdata;

    reg [31:0] instruction_memory [0:127];

    integer i;


    // =========================================================
    // DUT
    // =========================================================

    riscv_ai_soc DUT (

        .clk        (clk),
        .rst        (rst),

        .imem_addr  (imem_addr),
        .imem_rdata (imem_rdata)

    );


    // =========================================================
    // CLOCK
    // =========================================================

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end


    // =========================================================
    // INSTRUCTION MEMORY
    // =========================================================

    always @(*) begin

        if (imem_addr[31:2] < 128)
            imem_rdata =
                instruction_memory[imem_addr[8:2]];
        else
            imem_rdata =
                32'h00000013;

    end


    // =========================================================
    // CPU BUS MONITOR
    // =========================================================

    always @(posedge clk) begin

        if (!rst) begin

            if (DUT.CPU.dmem_re) begin

                $display(
                    "CPU LOAD  | addr=0x%08h | data=0x%08h",
                    DUT.CPU.dmem_addr,
                    DUT.CPU.dmem_rdata
                );

            end

            if (DUT.CPU.dmem_we) begin

                $display(
                    "CPU STORE | addr=0x%08h | data=0x%08h",
                    DUT.CPU.dmem_addr,
                    DUT.CPU.dmem_wdata
                );

            end

        end

    end


    // =========================================================
    // PROGRAM
    // =========================================================

    initial begin

        // -----------------------------------------------------
        // NOP all instructions
        // -----------------------------------------------------

        for (i = 0; i < 128; i = i + 1)

            instruction_memory[i] =
                32'h00000013;


        // =====================================================
        // x1 = 0x80
        // =====================================================

        instruction_memory[0] =
            {
                12'd128,
                5'd0,
                3'b000,
                5'd1,
                7'b0010011
            };


        // =====================================================
        // MATRIX A
        // =====================================================

        // A0
        instruction_memory[1] =
            {
                12'd0,
                5'd0,
                3'b010,
                5'd2,
                7'b0000011
            };

        instruction_memory[2] = 32'h00000013;
        instruction_memory[3] = 32'h00000013;

        instruction_memory[4] =
            {
                7'b0000000,
                5'd2,
                5'd1,
                3'b010,
                5'd0,
                7'b0100011
            };


        // A1
        instruction_memory[5] =
            {
                12'd4,
                5'd0,
                3'b010,
                5'd2,
                7'b0000011
            };

        instruction_memory[6] = 32'h00000013;
        instruction_memory[7] = 32'h00000013;

        instruction_memory[8] =
            {
                7'b0000000,
                5'd2,
                5'd1,
                3'b010,
                5'd4,
                7'b0100011
            };


        // A2
        instruction_memory[9] =
            {
                12'd8,
                5'd0,
                3'b010,
                5'd2,
                7'b0000011
            };

        instruction_memory[10] = 32'h00000013;
        instruction_memory[11] = 32'h00000013;

        instruction_memory[12] =
            {
                7'b0000000,
                5'd2,
                5'd1,
                3'b010,
                5'd8,
                7'b0100011
            };


        // A3
        instruction_memory[13] =
            {
                12'd12,
                5'd0,
                3'b010,
                5'd2,
                7'b0000011
            };

        instruction_memory[14] = 32'h00000013;
        instruction_memory[15] = 32'h00000013;

        instruction_memory[16] =
            {
                7'b0000000,
                5'd2,
                5'd1,
                3'b010,
                5'd12,
                7'b0100011
            };


        // =====================================================
        // MATRIX B
        // =====================================================

        // B0
        instruction_memory[17] =
            {
                12'd16,
                5'd0,
                3'b010,
                5'd2,
                7'b0000011
            };

        instruction_memory[18] = 32'h00000013;
        instruction_memory[19] = 32'h00000013;

        instruction_memory[20] =
            {
                7'b0000000,
                5'd2,
                5'd1,
                3'b010,
                5'd16,
                7'b0100011
            };


        // B1
        instruction_memory[21] =
            {
                12'd20,
                5'd0,
                3'b010,
                5'd2,
                7'b0000011
            };

        instruction_memory[22] = 32'h00000013;
        instruction_memory[23] = 32'h00000013;

        instruction_memory[24] =
            {
                7'b0000000,
                5'd2,
                5'd1,
                3'b010,
                5'd20,
                7'b0100011
            };


        // B2
        instruction_memory[25] =
            {
                12'd24,
                5'd0,
                3'b010,
                5'd2,
                7'b0000011
            };

        instruction_memory[26] = 32'h00000013;
        instruction_memory[27] = 32'h00000013;

        instruction_memory[28] =
            {
                7'b0000000,
                5'd2,
                5'd1,
                3'b010,
                5'd24,
                7'b0100011
            };


        // B3
        instruction_memory[29] =
            {
                12'd28,
                5'd0,
                3'b010,
                5'd2,
                7'b0000011
            };

        instruction_memory[30] = 32'h00000013;
        instruction_memory[31] = 32'h00000013;

        instruction_memory[32] =
            {
                7'b0000000,
                5'd2,
                5'd1,
                3'b010,
                5'd28,
                7'b0100011
            };


        // =====================================================
        // START ACCELERATOR
        // =====================================================

        // ADDI x2,x0,1

        instruction_memory[33] =
            {
                12'd1,
                5'd0,
                3'b000,
                5'd2,
                7'b0010011
            };

        instruction_memory[34] =
            32'h00000013;


        // SW x2,32(x1)
        // 0x80 + 0x20 = 0xA0

        instruction_memory[35] =
            {
                7'b0000001,
                5'd2,
                5'd1,
                3'b010,
                5'd0,
                7'b0100011
            };


        // =====================================================
        // WAIT
        // =====================================================

        instruction_memory[36] = 32'h00000013;
        instruction_memory[37] = 32'h00000013;
        instruction_memory[38] = 32'h00000013;
        instruction_memory[39] = 32'h00000013;
        instruction_memory[40] = 32'h00000013;
        instruction_memory[41] = 32'h00000013;
        instruction_memory[42] = 32'h00000013;
        instruction_memory[43] = 32'h00000013;
        instruction_memory[44] = 32'h00000013;
        instruction_memory[45] = 32'h00000013;
        instruction_memory[46] = 32'h00000013;
        instruction_memory[47] = 32'h00000013;
        instruction_memory[48] = 32'h00000013;
        instruction_memory[49] = 32'h00000013;


        // =====================================================
        // RESULT READBACK
        //
        // Base = 0x80
        // Result starts at 0xA8
        // =====================================================

        // C00 -> x10
        instruction_memory[50] =
            {
                12'd40,
                5'd1,
                3'b010,
                5'd10,
                7'b0000011
            };

        instruction_memory[51] = 32'h00000013;
        instruction_memory[52] = 32'h00000013;


        // C01 -> x11
        instruction_memory[53] =
            {
                12'd44,
                5'd1,
                3'b010,
                5'd11,
                7'b0000011
            };

        instruction_memory[54] = 32'h00000013;
        instruction_memory[55] = 32'h00000013;


        // C02 -> x12
        instruction_memory[56] =
            {
                12'd48,
                5'd1,
                3'b010,
                5'd12,
                7'b0000011
            };

        instruction_memory[57] = 32'h00000013;
        instruction_memory[58] = 32'h00000013;


        // C03 -> x13
        instruction_memory[59] =
            {
                12'd52,
                5'd1,
                3'b010,
                5'd13,
                7'b0000011
            };

        instruction_memory[60] = 32'h00000013;
        instruction_memory[61] = 32'h00000013;


        // C10 -> x14
        instruction_memory[62] =
            {
                12'd56,
                5'd1,
                3'b010,
                5'd14,
                7'b0000011
            };

        instruction_memory[63] = 32'h00000013;
        instruction_memory[64] = 32'h00000013;


        // C11 -> x15
        instruction_memory[65] =
            {
                12'd60,
                5'd1,
                3'b010,
                5'd15,
                7'b0000011
            };

        instruction_memory[66] = 32'h00000013;
        instruction_memory[67] = 32'h00000013;


        // C12 -> x16
        instruction_memory[68] =
            {
                12'd64,
                5'd1,
                3'b010,
                5'd16,
                7'b0000011
            };

        instruction_memory[69] = 32'h00000013;
        instruction_memory[70] = 32'h00000013;


        // C13 -> x17
        instruction_memory[71] =
            {
                12'd68,
                5'd1,
                3'b010,
                5'd17,
                7'b0000011
            };

        instruction_memory[72] = 32'h00000013;
        instruction_memory[73] = 32'h00000013;


        // C20 -> x18
        instruction_memory[74] =
            {
                12'd72,
                5'd1,
                3'b010,
                5'd18,
                7'b0000011
            };

        instruction_memory[75] = 32'h00000013;
        instruction_memory[76] = 32'h00000013;


        // C21 -> x19
        instruction_memory[77] =
            {
                12'd76,
                5'd1,
                3'b010,
                5'd19,
                7'b0000011
            };

        instruction_memory[78] = 32'h00000013;
        instruction_memory[79] = 32'h00000013;


        // C22 -> x20
        instruction_memory[80] =
            {
                12'd80,
                5'd1,
                3'b010,
                5'd20,
                7'b0000011
            };

        instruction_memory[81] = 32'h00000013;
        instruction_memory[82] = 32'h00000013;


        // C23 -> x21
        instruction_memory[83] =
            {
                12'd84,
                5'd1,
                3'b010,
                5'd21,
                7'b0000011
            };

        instruction_memory[84] = 32'h00000013;
        instruction_memory[85] = 32'h00000013;


        // C30 -> x22
        instruction_memory[86] =
            {
                12'd88,
                5'd1,
                3'b010,
                5'd22,
                7'b0000011
            };

        instruction_memory[87] = 32'h00000013;
        instruction_memory[88] = 32'h00000013;


        // C31 -> x23
        instruction_memory[89] =
            {
                12'd92,
                5'd1,
                3'b010,
                5'd23,
                7'b0000011
            };

        instruction_memory[90] = 32'h00000013;
        instruction_memory[91] = 32'h00000013;


        // C32 -> x24
        instruction_memory[92] =
            {
                12'd96,
                5'd1,
                3'b010,
                5'd24,
                7'b0000011
            };

        instruction_memory[93] = 32'h00000013;
        instruction_memory[94] = 32'h00000013;


        // C33 -> x25
        // 0x80 + 100 = 0xE4

        instruction_memory[95] =
            {
                12'd100,
                5'd1,
                3'b010,
                5'd25,
                7'b0000011
            };


        // Extra NOPs

        instruction_memory[96]  = 32'h00000013;
        instruction_memory[97]  = 32'h00000013;
        instruction_memory[98]  = 32'h00000013;
        instruction_memory[99]  = 32'h00000013;
        instruction_memory[100] = 32'h00000013;
        instruction_memory[101] = 32'h00000013;
        instruction_memory[102] = 32'h00000013;

    end


    // =========================================================
    // RESET + DATA RAM
    // =========================================================

    initial begin

        rst = 1'b1;

        #30;

        rst = 1'b0;

        #10;


        // =====================================================
        // MATRIX A
        // =====================================================

        DUT.data_ram[0] = 32'h04030201;
        DUT.data_ram[1] = 32'h08070605;
        DUT.data_ram[2] = 32'h0C0B0A09;
        DUT.data_ram[3] = 32'h100F0E0D;


        // =====================================================
        // MATRIX B
        // =====================================================

        DUT.data_ram[4] = 32'h00010201;
        DUT.data_ram[5] = 32'h01020100;
        DUT.data_ram[6] = 32'h02010001;
        DUT.data_ram[7] = 32'h01000102;


        // =====================================================
        // HEADER
        // =====================================================

        $display("");
        $display("========================================");
        $display("RISC-V AI ACCELERATOR FULL TEST");
        $display("========================================");

        $display("");
        $display("SOURCE MATRICES LOADED");

        $display("");
        $display("AI BASE ADDRESS = 0x00000080");

        $display("");
        $display("PROGRAM EXECUTION STARTED");


        // =====================================================
        // RUN LONG ENOUGH FOR ALL 16 LOADS
        // =====================================================

        #3000;


        // =====================================================
        // RESULT MATRIX
        // =====================================================

        $display("");
        $display("========================================");
        $display("RESULT MATRIX");
        $display("========================================");

        $display(
            "%d  %d  %d  %d",
            $signed(DUT.CPU.REGFILE.regs[10]),
            $signed(DUT.CPU.REGFILE.regs[11]),
            $signed(DUT.CPU.REGFILE.regs[12]),
            $signed(DUT.CPU.REGFILE.regs[13])
        );

        $display(
            "%d  %d  %d  %d",
            $signed(DUT.CPU.REGFILE.regs[14]),
            $signed(DUT.CPU.REGFILE.regs[15]),
            $signed(DUT.CPU.REGFILE.regs[16]),
            $signed(DUT.CPU.REGFILE.regs[17])
        );

        $display(
            "%d  %d  %d  %d",
            $signed(DUT.CPU.REGFILE.regs[18]),
            $signed(DUT.CPU.REGFILE.regs[19]),
            $signed(DUT.CPU.REGFILE.regs[20]),
            $signed(DUT.CPU.REGFILE.regs[21])
        );

        $display(
            "%d  %d  %d  %d",
            $signed(DUT.CPU.REGFILE.regs[22]),
            $signed(DUT.CPU.REGFILE.regs[23]),
            $signed(DUT.CPU.REGFILE.regs[24]),
            $signed(DUT.CPU.REGFILE.regs[25])
        );


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
        // CHECK ALL 16 RESULTS
        // =====================================================

        $display("");
        $display("========================================");
        $display("RESULT CHECK");
        $display("========================================");


        if ($signed(DUT.CPU.REGFILE.regs[10]) == 12)
            $display("C00 PASS");
        else
            $display("C00 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[11]) == 8)
            $display("C01 PASS");
        else
            $display("C01 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[12]) == 8)
            $display("C02 PASS");
        else
            $display("C02 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[13]) == 12)
            $display("C03 PASS");
        else
            $display("C03 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[14]) == 28)
            $display("C10 PASS");
        else
            $display("C10 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[15]) == 24)
            $display("C11 PASS");
        else
            $display("C11 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[16]) == 24)
            $display("C12 PASS");
        else
            $display("C12 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[17]) == 28)
            $display("C13 PASS");
        else
            $display("C13 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[18]) == 44)
            $display("C20 PASS");
        else
            $display("C20 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[19]) == 40)
            $display("C21 PASS");
        else
            $display("C21 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[20]) == 40)
            $display("C22 PASS");
        else
            $display("C22 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[21]) == 44)
            $display("C23 PASS");
        else
            $display("C23 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[22]) == 60)
            $display("C30 PASS");
        else
            $display("C30 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[23]) == 56)
            $display("C31 PASS");
        else
            $display("C31 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[24]) == 56)
            $display("C32 PASS");
        else
            $display("C32 FAIL");


        if ($signed(DUT.CPU.REGFILE.regs[25]) == 60)
            $display("C33 PASS");
        else
            $display("C33 FAIL");


        // =====================================================
        // FINAL PASS / FAIL
        // =====================================================

        if (
            ($signed(DUT.CPU.REGFILE.regs[10]) == 12) &&
            ($signed(DUT.CPU.REGFILE.regs[11]) == 8) &&
            ($signed(DUT.CPU.REGFILE.regs[12]) == 8) &&
            ($signed(DUT.CPU.REGFILE.regs[13]) == 12) &&

            ($signed(DUT.CPU.REGFILE.regs[14]) == 28) &&
            ($signed(DUT.CPU.REGFILE.regs[15]) == 24) &&
            ($signed(DUT.CPU.REGFILE.regs[16]) == 24) &&
            ($signed(DUT.CPU.REGFILE.regs[17]) == 28) &&

            ($signed(DUT.CPU.REGFILE.regs[18]) == 44) &&
            ($signed(DUT.CPU.REGFILE.regs[19]) == 40) &&
            ($signed(DUT.CPU.REGFILE.regs[20]) == 40) &&
            ($signed(DUT.CPU.REGFILE.regs[21]) == 44) &&

            ($signed(DUT.CPU.REGFILE.regs[22]) == 60) &&
            ($signed(DUT.CPU.REGFILE.regs[23]) == 56) &&
            ($signed(DUT.CPU.REGFILE.regs[24]) == 56) &&
            ($signed(DUT.CPU.REGFILE.regs[25]) == 60)
        ) begin

            $display("");
            $display("========================================");
            $display("RISC-V AI ACCELERATOR FULL TEST PASSED");
            $display("ALL 16 RESULTS CORRECT");
            $display("========================================");

        end
        else begin

            $display("");
            $display("========================================");
            $display("RISC-V AI ACCELERATOR FULL TEST FAILED");
            $display("========================================");

        end


        #20;

        $finish;

    end


    // =========================================================
    // WAVEFORM
    // =========================================================

    initial begin

        $dumpfile("riscv_ai_soc_full_test.vcd");

        $dumpvars(0, tb_riscv_ai_soc);

    end

endmodule