`timescale 1ns/1ps

module tb_riscv_imm_gen;

    reg [31:0] instruction;

    wire [31:0] immediate;


    // =========================================================
    // DUT
    // =========================================================

    riscv_imm_gen DUT (

        .instruction(instruction),

        .immediate(immediate)

    );


    // =========================================================
    // Test
    // =========================================================

    initial begin

        $display("========================================");
        $display("RISC-V IMMEDIATE GENERATOR TEST");
        $display("========================================");


        // =====================================================
        // TEST 1
        //
        // ADDI x5,x6,25
        //
        // Immediate = 25
        // =====================================================

        instruction =
            {12'd25,
             5'd6,
             3'b000,
             5'd5,
             7'b0010011};

        #10;

        $display("");
        $display("TEST 1 - I TYPE");
        $display("Immediate = %d", immediate);

        if (immediate == 32'd25)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 2
        //
        // ADDI with negative immediate
        //
        // -10
        // =====================================================

        instruction =
            {12'b111111110110,
             5'd6,
             3'b000,
             5'd5,
             7'b0010011};

        #10;

        $display("");
        $display("TEST 2 - NEGATIVE I TYPE");
        $display("Immediate = %d", $signed(immediate));

        if ($signed(immediate) == -32'sd10)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 3
        //
        // SW immediate
        //
        // 12
        // =====================================================

        instruction =
            {7'b0000000,
             5'd5,
             5'd6,
             3'b010,
             5'b00110,
             7'b0100011};

        #10;

        $display("");
        $display("TEST 3 - S TYPE");
        $display("Immediate = %d", immediate);

        if (immediate == 32'd6)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 4
        //
        // B-type
        //
        // offset = 8
        //
        // Manually construct:
        //
        // imm[12]   = 0
        // imm[11]   = 0
        // imm[10:5] = 000000
        // imm[4:1]  = 0100
        // imm[0]    = 0
        // =====================================================

        instruction =
            {1'b0,
             6'b000000,
             5'd6,
             5'd5,
             3'b000,
             4'b0100,
             1'b0,
             7'b1100011};

        #10;

        $display("");
        $display("TEST 4 - B TYPE");
        $display("Immediate = %d", immediate);

        if (immediate == 32'd8)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 5
        //
        // LUI
        //
        // 0x12345000
        // =====================================================

        instruction =
            {20'h12345,
             5'd5,
             7'b0110111};

        #10;

        $display("");
        $display("TEST 5 - U TYPE");
        $display("Immediate = %h", immediate);

        if (immediate == 32'h12345000)
            $display("PASS");
        else
            $display("FAIL");


// =====================================================
// TEST 6
//
// JAL x1, 8
//
// J-type format:
//
// imm[20]    = bit 31
// imm[10:1]  = bits 30:21
// imm[11]    = bit 20
// imm[19:12] = bits 19:12
// rd         = bits 11:7
// opcode     = bits 6:0
// =====================================================

instruction =
    {1'b0,
     10'b0000000100,
     1'b0,
     8'b00000000,
     5'd1,
     7'b1101111};

#10;

$display("");
$display("TEST 6 - J TYPE");
$display("Immediate = %d", immediate);

if (immediate == 32'd8)
    $display("PASS");
else
    $display("FAIL");


        // =====================================================
        // COMPLETE
        // =====================================================

        $display("");
        $display("========================================");
        $display("IMMEDIATE GENERATOR TEST COMPLETE");
        $display("========================================");

        #10;

        $finish;

    end


    initial begin

        $dumpfile("riscv_imm_gen.vcd");

        $dumpvars(0,tb_riscv_imm_gen);

    end

endmodule