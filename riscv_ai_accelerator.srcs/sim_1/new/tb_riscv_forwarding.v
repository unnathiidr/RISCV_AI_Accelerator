`timescale 1ns/1ps

module tb_riscv_forwarding;

    reg [4:0] idex_rs1;
    reg [4:0] idex_rs2;

    reg [4:0] exmem_rd;
    reg       exmem_regwrite;

    reg [4:0] memwb_rd;
    reg       memwb_regwrite;

    wire [1:0] forward_a;
    wire [1:0] forward_b;


    // =========================================================
    // DUT
    // =========================================================

    riscv_forwarding DUT (

        .idex_rs1(idex_rs1),
        .idex_rs2(idex_rs2),

        .exmem_rd(exmem_rd),
        .exmem_regwrite(exmem_regwrite),

        .memwb_rd(memwb_rd),
        .memwb_regwrite(memwb_regwrite),

        .forward_a(forward_a),
        .forward_b(forward_b)

    );


    // =========================================================
    // Test
    // =========================================================

    initial begin

        $display("========================================");
        $display("RISC-V FORWARDING UNIT TEST");
        $display("========================================");


        // =====================================================
        // TEST 1
        //
        // No dependency
        // =====================================================

        idex_rs1 = 5'd1;
        idex_rs2 = 5'd2;

        exmem_rd = 5'd3;
        exmem_regwrite = 1'b1;

        memwb_rd = 5'd4;
        memwb_regwrite = 1'b1;

        #10;

        $display("");
        $display("TEST 1 - NO DEPENDENCY");
        $display("Forward A = %b",forward_a);
        $display("Forward B = %b",forward_b);

        if ((forward_a == 2'b00) &&
            (forward_b == 2'b00))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 2
        //
        // rs1 depends on EX/MEM
        // =====================================================

        idex_rs1 = 5'd5;
        idex_rs2 = 5'd2;

        exmem_rd = 5'd5;
        exmem_regwrite = 1'b1;

        memwb_rd = 5'd4;
        memwb_regwrite = 1'b1;

        #10;

        $display("");
        $display("TEST 2 - EX/MEM -> RS1");
        $display("Forward A = %b",forward_a);

        if (forward_a == 2'b10)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 3
        //
        // rs2 depends on EX/MEM
        // =====================================================

        idex_rs1 = 5'd1;
        idex_rs2 = 5'd6;

        exmem_rd = 5'd6;
        exmem_regwrite = 1'b1;

        memwb_rd = 5'd4;
        memwb_regwrite = 1'b1;

        #10;

        $display("");
        $display("TEST 3 - EX/MEM -> RS2");
        $display("Forward B = %b",forward_b);

        if (forward_b == 2'b10)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 4
        //
        // rs1 depends on MEM/WB
        // =====================================================

        idex_rs1 = 5'd7;
        idex_rs2 = 5'd2;

        exmem_rd = 5'd4;
        exmem_regwrite = 1'b1;

        memwb_rd = 5'd7;
        memwb_regwrite = 1'b1;

        #10;

        $display("");
        $display("TEST 4 - MEM/WB -> RS1");
        $display("Forward A = %b",forward_a);

        if (forward_a == 2'b01)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 5
        //
        // rs2 depends on MEM/WB
        // =====================================================

        idex_rs1 = 5'd1;
        idex_rs2 = 5'd8;

        exmem_rd = 5'd4;
        exmem_regwrite = 1'b1;

        memwb_rd = 5'd8;
        memwb_regwrite = 1'b1;

        #10;

        $display("");
        $display("TEST 5 - MEM/WB -> RS2");
        $display("Forward B = %b",forward_b);

        if (forward_b == 2'b01)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 6
        //
        // Both operands forwarded from EX/MEM
        // =====================================================

        idex_rs1 = 5'd10;
        idex_rs2 = 5'd11;

        exmem_rd = 5'd10;
        exmem_regwrite = 1'b1;

        memwb_rd = 5'd11;
        memwb_regwrite = 1'b1;

        #10;

        $display("");
        $display("TEST 6 - BOTH OPERANDS");
        $display("Forward A = %b",forward_a);
        $display("Forward B = %b",forward_b);

        if ((forward_a == 2'b10) &&
            (forward_b == 2'b01))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 7
        //
        // EX/MEM has priority over MEM/WB
        //
        // Both produce x12
        // =====================================================

        idex_rs1 = 5'd12;
        idex_rs2 = 5'd2;

        exmem_rd = 5'd12;
        exmem_regwrite = 1'b1;

        memwb_rd = 5'd12;
        memwb_regwrite = 1'b1;

        #10;

        $display("");
        $display("TEST 7 - EX/MEM PRIORITY");
        $display("Forward A = %b",forward_a);

        if (forward_a == 2'b10)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 8
        //
        // x0 must never be forwarded
        // =====================================================

        idex_rs1 = 5'd0;
        idex_rs2 = 5'd0;

        exmem_rd = 5'd0;
        exmem_regwrite = 1'b1;

        memwb_rd = 5'd0;
        memwb_regwrite = 1'b1;

        #10;

        $display("");
        $display("TEST 8 - x0");
        $display("Forward A = %b",forward_a);
        $display("Forward B = %b",forward_b);

        if ((forward_a == 2'b00) &&
            (forward_b == 2'b00))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // COMPLETE
        // =====================================================

        $display("");
        $display("========================================");
        $display("FORWARDING UNIT TEST COMPLETE");
        $display("========================================");

        #10;

        $finish;

    end


    initial begin

        $dumpfile("riscv_forwarding.vcd");

        $dumpvars(0,tb_riscv_forwarding);

    end

endmodule