`timescale 1ns/1ps

module riscv_forwarding (

    input      [4:0] idex_rs1,
    input      [4:0] idex_rs2,

    input      [4:0] exmem_rd,
    input             exmem_regwrite,

    input      [4:0] memwb_rd,
    input             memwb_regwrite,

    output reg [1:0] forward_a,
    output reg [1:0] forward_b

);

    // =========================================================
    // Forwarding selection
    //
    // 00 = Register File
    // 01 = MEM/WB
    // 10 = EX/MEM
    // =========================================================

    always @(*) begin

        // -----------------------------------------------------
        // Default
        // -----------------------------------------------------

        forward_a = 2'b00;
        forward_b = 2'b00;


        // =====================================================
        // Forward A
        // =====================================================

        if (exmem_regwrite &&
            (exmem_rd != 5'd0) &&
            (exmem_rd == idex_rs1)) begin

            forward_a = 2'b10;

        end

        else if (memwb_regwrite &&
                 (memwb_rd != 5'd0) &&
                 (memwb_rd == idex_rs1)) begin

            forward_a = 2'b01;

        end


        // =====================================================
        // Forward B
        // =====================================================

        if (exmem_regwrite &&
            (exmem_rd != 5'd0) &&
            (exmem_rd == idex_rs2)) begin

            forward_b = 2'b10;

        end

        else if (memwb_regwrite &&
                 (memwb_rd != 5'd0) &&
                 (memwb_rd == idex_rs2)) begin

            forward_b = 2'b01;

        end

    end

endmodule