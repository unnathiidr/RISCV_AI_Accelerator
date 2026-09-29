`timescale 1ns/1ps

module tb_riscv_alu;

    reg [31:0] operand_a;
    reg [31:0] operand_b;

    reg [3:0] alu_control;

    wire [31:0] result;

    wire zero;
    wire less_than;


    // =========================================================
    // ALU
    // =========================================================

    riscv_alu DUT (

        .operand_a(operand_a),
        .operand_b(operand_b),

        .alu_control(alu_control),

        .result(result),

        .zero(zero),
        .less_than(less_than)

    );

    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;
    localparam ALU_SLL = 4'b0110;
    localparam ALU_SRL = 4'b0111;
    localparam ALU_SRA = 4'b1000;

    initial begin

        $display("========================================");
        $display("RISC-V ALU TEST");
        $display("========================================");


        // -----------------------------------------------------
        // ADD
        // -----------------------------------------------------

        operand_a   = 32'd10;
        operand_b   = 32'd20;
        alu_control = ALU_ADD;

        #10;

        $display("ADD: %d + %d = %d",
                 operand_a,
                 operand_b,
                 result);

        if (result == 32'd30)
            $display("PASS");
        else
            $display("FAIL");

        operand_a   = 32'd50;
        operand_b   = 32'd20;
        alu_control = ALU_SUB;

        #10;

        $display("SUB: %d - %d = %d",
                 operand_a,
                 operand_b,
                 result);

        if (result == 32'd30)
            $display("PASS");
        else
            $display("FAIL");


        // -----------------------------------------------------
        // AND
        // -----------------------------------------------------

        operand_a   = 32'hF0F0F0F0;
        operand_b   = 32'h0FF00FF0;
        alu_control = ALU_AND;

        #10;

        $display("AND: %h", result);

        if (result == 32'h00F000F0)
            $display("PASS");
        else
            $display("FAIL");

        operand_a   = 32'hF0000000;
        operand_b   = 32'h0000000F;
        alu_control = ALU_OR;

        #10;

        $display("OR: %h", result);

        if (result == 32'hF000000F)
            $display("PASS");
        else
            $display("FAIL");


        // -----------------------------------------------------
        // XOR
        // -----------------------------------------------------

        operand_a   = 32'hAAAAAAAA;
        operand_b   = 32'h55555555;
        alu_control = ALU_XOR;

        #10;

        $display("XOR: %h", result);

        if (result == 32'hFFFFFFFF)
            $display("PASS");
        else
            $display("FAIL");


        // -----------------------------------------------------
        // SLT
        // -----------------------------------------------------

        operand_a   = -32'sd10;
        operand_b   = 32'sd5;
        alu_control = ALU_SLT;

        #10;

        $display("SLT: -10 < 5 = %d", result);

        if (result == 32'd1)
            $display("PASS");
        else
            $display("FAIL");

        operand_a   = 32'd1;
        operand_b   = 32'd4;
        alu_control = ALU_SLL;

        #10;

        $display("SLL: 1 << 4 = %d", result);

        if (result == 32'd16)
            $display("PASS");
        else
            $display("FAIL");

        operand_a   = 32'd128;
        operand_b   = 32'd3;
        alu_control = ALU_SRL;

        #10;

        $display("SRL: 128 >> 3 = %d", result);

        if (result == 32'd16)
            $display("PASS");
        else
            $display("FAIL");


        // -----------------------------------------------------
        // SRA
        // -----------------------------------------------------

        operand_a   = 32'hFFFFFFF0;
        operand_b   = 32'd2;
        alu_control = ALU_SRA;

        #10;

        $display("SRA: FFFFFFF0 >>> 2 = %h", result);

        if (result == 32'hFFFFFFFC)
            $display("PASS");
        else
            $display("FAIL");


        operand_a   = 32'd25;
        operand_b   = 32'd25;
        alu_control = ALU_SUB;

        #10;

        $display("ZERO FLAG = %d", zero);

        if (zero == 1'b1)
            $display("PASS");
        else
            $display("FAIL");

        operand_a   = -32'sd5;
        operand_b   = 32'sd3;
        alu_control = ALU_SUB;

        #10;

        $display("LESS THAN FLAG = %d", less_than);

        if (less_than == 1'b1)
            $display("PASS");
        else
            $display("FAIL");

        $display("");
        $display("========================================");
        $display("ALU TEST COMPLETE");
        $display("========================================");

        #10;

        $finish;

    end

    initial begin

        $dumpfile("riscv_alu.vcd");

        $dumpvars(0, tb_riscv_alu);

    end

endmodule