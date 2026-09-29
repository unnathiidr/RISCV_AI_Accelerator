`timescale 1ns/1ps

module tb_riscv_branch_unit;

    reg [31:0] pc;

    reg [31:0] rs1_value;
    reg [31:0] rs2_value;

    reg branch;
    reg branch_ne;
    reg jump;

    reg [31:0] immediate;

    wire branch_taken;
    wire [31:0] target_address;


    // =========================================================
    // DUT
    // =========================================================

    riscv_branch_unit DUT (

        .pc(pc),

        .rs1_value(rs1_value),
        .rs2_value(rs2_value),

        .branch(branch),
        .branch_ne(branch_ne),
        .jump(jump),

        .immediate(immediate),

        .branch_taken(branch_taken),
        .target_address(target_address)

    );


    // =========================================================
    // Test
    // =========================================================

    initial begin

        $display("========================================");
        $display("RISC-V BRANCH UNIT TEST");
        $display("========================================");


        // =====================================================
        // TEST 1
        // BEQ where values are equal
        // =====================================================

        pc = 32'h00001000;

        rs1_value = 32'd100;
        rs2_value = 32'd100;

        branch = 1'b1;
        branch_ne = 1'b0;
        jump = 1'b0;

        immediate = 32'd16;

        #10;

        $display("");
        $display("TEST 1 - BEQ TAKEN");
        $display("Branch Taken = %b", branch_taken);
        $display("Target       = %h", target_address);

        if ((branch_taken == 1'b1) &&
            (target_address == 32'h00001010))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 2
        // BEQ where values differ
        // =====================================================

        rs1_value = 32'd100;
        rs2_value = 32'd200;

        branch = 1'b1;
        branch_ne = 1'b0;
        jump = 1'b0;

        immediate = 32'd16;

        #10;

        $display("");
        $display("TEST 2 - BEQ NOT TAKEN");
        $display("Branch Taken = %b", branch_taken);

        if (branch_taken == 1'b0)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 3
        // BNE where values differ
        // =====================================================

        rs1_value = 32'd100;
        rs2_value = 32'd200;

        branch = 1'b1;
        branch_ne = 1'b1;
        jump = 1'b0;

        immediate = 32'd20;

        #10;

        $display("");
        $display("TEST 3 - BNE TAKEN");
        $display("Branch Taken = %b", branch_taken);
        $display("Target       = %h", target_address);

        if ((branch_taken == 1'b1) &&
            (target_address == 32'h00001014))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 4
        // BNE where values are equal
        // =====================================================

        rs1_value = 32'd50;
        rs2_value = 32'd50;

        branch = 1'b1;
        branch_ne = 1'b1;
        jump = 1'b0;

        immediate = 32'd20;

        #10;

        $display("");
        $display("TEST 4 - BNE NOT TAKEN");
        $display("Branch Taken = %b", branch_taken);

        if (branch_taken == 1'b0)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 5
        // JAL
        // =====================================================

        pc = 32'h00002000;

        rs1_value = 32'd0;
        rs2_value = 32'd0;

        branch = 1'b0;
        branch_ne = 1'b0;
        jump = 1'b1;

        immediate = 32'd100;

        #10;

        $display("");
        $display("TEST 5 - JAL");
        $display("Jump Taken = %b", branch_taken);
        $display("Target     = %h", target_address);

        if ((branch_taken == 1'b1) &&
            (target_address == 32'h00002064))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // TEST 6
        // No branch
        // =====================================================

        pc = 32'h00003000;

        rs1_value = 32'd100;
        rs2_value = 32'd100;

        branch = 1'b0;
        branch_ne = 1'b0;
        jump = 1'b0;

        immediate = 32'd200;

        #10;

        $display("");
        $display("TEST 6 - NO CONTROL TRANSFER");
        $display("Branch Taken = %b", branch_taken);

        if (branch_taken == 1'b0)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // COMPLETE
        // =====================================================

        $display("");
        $display("========================================");
        $display("BRANCH UNIT TEST COMPLETE");
        $display("========================================");

        #10;

        $finish;

    end


    initial begin

        $dumpfile("riscv_branch_unit.vcd");

        $dumpvars(0,tb_riscv_branch_unit);

    end

endmodule