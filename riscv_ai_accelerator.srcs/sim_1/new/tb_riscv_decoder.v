`timescale 1ns/1ps

module tb_riscv_decoder;

    reg [31:0] instruction;

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    wire reg_write;
    wire mem_read;
    wire mem_write;

    wire alu_src;

    wire branch;
    wire branch_ne;

    wire jump;

    wire ai_enable;

    wire [3:0] alu_control;

    wire [31:0] immediate;


    // =========================================================
    // DUT
    // =========================================================

    riscv_decoder DUT (

        .instruction(instruction),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .reg_write(reg_write),

        .mem_read(mem_read),
        .mem_write(mem_write),

        .alu_src(alu_src),

        .branch(branch),
        .branch_ne(branch_ne),

        .jump(jump),

        .ai_enable(ai_enable),

        .alu_control(alu_control),

        .immediate(immediate)

    );


    // =========================================================
    // Test
    // =========================================================

    initial begin

        $display("========================================");
        $display("RISC-V INSTRUCTION DECODER TEST");
        $display("========================================");


        // =====================================================
        // ADD x5,x6,x7
        // =====================================================

        instruction =
            {7'b0000000,
             5'd7,
             5'd6,
             3'b000,
             5'd5,
             7'b0110011};

        #10;

        $display("");
        $display("ADD x5,x6,x7");
        $display("rs1       = %d",rs1);
        $display("rs2       = %d",rs2);
        $display("rd        = %d",rd);
        $display("reg_write = %d",reg_write);
        $display("alu_ctrl  = %b",alu_control);

        if ((rs1 == 6) &&
            (rs2 == 7) &&
            (rd == 5) &&
            (reg_write == 1))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // ADDI x5,x6,25
        // =====================================================

        instruction =
            {12'd25,
             5'd6,
             3'b000,
             5'd5,
             7'b0010011};

        #10;

        $display("");
        $display("ADDI x5,x6,25");
        $display("immediate = %d",immediate);

        if ((immediate == 32'd25) &&
            (reg_write == 1) &&
            (alu_src == 1))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // LW x5,8(x6)
        // =====================================================

        instruction =
            {12'd8,
             5'd6,
             3'b010,
             5'd5,
             7'b0000011};

        #10;

        $display("");
        $display("LW x5,8(x6)");
        $display("mem_read  = %d",mem_read);
        $display("reg_write = %d",reg_write);
        $display("immediate = %d",immediate);

        if ((mem_read == 1) &&
            (reg_write == 1) &&
            (immediate == 32'd8))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // SW x5,12(x6)
        // =====================================================

        instruction =
            {7'd0,
             5'd5,
             5'd6,
             3'b010,
             5'b01100,
             7'b0100011};

        #10;

        $display("");
        $display("SW x5,12(x6)");
        $display("mem_write = %d",mem_write);

        if (mem_write == 1)
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // BEQ x5,x6,offset
        // =====================================================

        instruction =
            {7'b0000000,
             5'd6,
             5'd5,
             3'b000,
             5'b00000,
             7'b1100011};

        #10;

        $display("");
        $display("BEQ x5,x6");
        $display("branch = %d",branch);
        $display("branch_ne = %d",branch_ne);

        if ((branch == 1) &&
            (branch_ne == 0))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // AI_DOT4 x7,x5,x6
        // =====================================================

        instruction =
            {7'b0000001,
             5'd6,
             5'd5,
             3'b000,
             5'd7,
             7'b0001011};

        #10;

        $display("");
        $display("AI_DOT4 x7,x5,x6");

        $display("rs1       = %d",rs1);
        $display("rs2       = %d",rs2);
        $display("rd        = %d",rd);
        $display("ai_enable = %d",ai_enable);
        $display("reg_write = %d",reg_write);

        if ((rs1 == 5) &&
            (rs2 == 6) &&
            (rd == 7) &&
            (ai_enable == 1) &&
            (reg_write == 1))
            $display("PASS");
        else
            $display("FAIL");


        // =====================================================
        // Complete
        // =====================================================

        $display("");
        $display("========================================");
        $display("DECODER TEST COMPLETE");
        $display("========================================");

        #10;

        $finish;

    end


    initial begin

        $dumpfile("riscv_decoder.vcd");

        $dumpvars(0,tb_riscv_decoder);

    end

endmodule