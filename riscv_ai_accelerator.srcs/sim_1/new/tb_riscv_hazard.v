`timescale 1ns/1ps

module tb_riscv_hazard;

    reg [4:0] id_rs1;
    reg [4:0] id_rs2;

    reg [4:0] idex_rd;
    reg       idex_memread;

    wire pc_write;
    wire ifid_write;
    wire idex_flush;


    // =========================================================
    // DUT
    // =========================================================

    riscv_hazard DUT (

        .id_rs1(id_rs1),
        .id_rs2(id_rs2),

        .idex_rd(idex_rd),
        .idex_memread(idex_memread),

        .pc_write(pc_write),
        .ifid_write(ifid_write),
        .idex_flush(idex_flush)

    );


    // =========================================================
    // Test
    // =========================================================

    initial begin

        $display("========================================");
        $display("RISC-V HAZARD DETECTION TEST");
        $display("========================================");


        // =====================================================
        // TEST 1
        //
        // No load instruction
        //
        // ADD x6,x5,x2
        // =====================================================

        id_rs1 = 5'd5;
        id_rs2 = 5'd2;

        idex_rd = 5'd5;
        idex_memread = 1'b0;

        #10;

        $display("");
        $display("TEST 1 - NO LOAD");
        $display("PC Write   = %b", pc_write);
        $display("IFID Write = %b", ifid_write);
        $display("IDEX Flush = %b", idex_flush);

        if ((pc_write == 1'b1) &&
            (ifid_write == 1'b1) &&
            (idex_flush == 1'b0))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 2
        //
        // LW x5,...
        // ADD x6,x5,x2
        //
        // Hazard on RS1
        // =====================================================

        id_rs1 = 5'd5;
        id_rs2 = 5'd2;

        idex_rd = 5'd5;
        idex_memread = 1'b1;

        #10;

        $display("");
        $display("TEST 2 - LOAD USE RS1");
        $display("PC Write   = %b", pc_write);
        $display("IFID Write = %b", ifid_write);
        $display("IDEX Flush = %b", idex_flush);

        if ((pc_write == 1'b0) &&
            (ifid_write == 1'b0) &&
            (idex_flush == 1'b1))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 3
        //
        // Hazard on RS2
        //
        // LW x7,...
        // ADD x6,x1,x7
        // =====================================================

        id_rs1 = 5'd1;
        id_rs2 = 5'd7;

        idex_rd = 5'd7;
        idex_memread = 1'b1;

        #10;

        $display("");
        $display("TEST 3 - LOAD USE RS2");
        $display("PC Write   = %b", pc_write);
        $display("IFID Write = %b", ifid_write);
        $display("IDEX Flush = %b", idex_flush);

        if ((pc_write == 1'b0) &&
            (ifid_write == 1'b0) &&
            (idex_flush == 1'b1))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 4
        //
        // No dependency
        //
        // LW x5,...
        // ADD x6,x1,x2
        // =====================================================

        id_rs1 = 5'd1;
        id_rs2 = 5'd2;

        idex_rd = 5'd5;
        idex_memread = 1'b1;

        #10;

        $display("");
        $display("TEST 4 - LOAD WITH NO DEPENDENCY");
        $display("PC Write   = %b", pc_write);
        $display("IFID Write = %b", ifid_write);
        $display("IDEX Flush = %b", idex_flush);

        if ((pc_write == 1'b1) &&
            (ifid_write == 1'b1) &&
            (idex_flush == 1'b0))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 5
        //
        // Destination is x0.
        //
        // x0 must never cause a hazard.
        // =====================================================

        id_rs1 = 5'd0;
        id_rs2 = 5'd0;

        idex_rd = 5'd0;
        idex_memread = 1'b1;

        #10;

        $display("");
        $display("TEST 5 - x0");
        $display("PC Write   = %b", pc_write);
        $display("IFID Write = %b", ifid_write);
        $display("IDEX Flush = %b", idex_flush);

        if ((pc_write == 1'b1) &&
            (ifid_write == 1'b1) &&
            (idex_flush == 1'b0))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 6
        //
        // Both RS1 and RS2 depend on loaded register.
        //
        // LW  x8,...
        // ADD x9,x8,x8
        // =====================================================

        id_rs1 = 5'd8;
        id_rs2 = 5'd8;

        idex_rd = 5'd8;
        idex_memread = 1'b1;

        #10;

        $display("");
        $display("TEST 6 - BOTH OPERANDS");
        $display("PC Write   = %b", pc_write);
        $display("IFID Write = %b", ifid_write);
        $display("IDEX Flush = %b", idex_flush);

        if ((pc_write == 1'b0) &&
            (ifid_write == 1'b0) &&
            (idex_flush == 1'b1))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // COMPLETE
        // =====================================================

        $display("");
        $display("========================================");
        $display("HAZARD DETECTION TEST COMPLETE");
        $display("========================================");

        #10;

        $finish;

    end


    initial begin

        $dumpfile("riscv_hazard.vcd");

        $dumpvars(0,tb_riscv_hazard);

    end

endmodule