`timescale 1ns/1ps

module riscv_hazard (

    input      [4:0] id_rs1,
    input      [4:0] id_rs2,

    input      [4:0] idex_rd,
    input             idex_memread,

    output reg        pc_write,
    output reg        ifid_write,
    output reg        idex_flush

);

    // =========================================================
    // Load-use hazard detection
    //
    // Example:
    //
    // LW  x5, 0(x1)
    // ADD x6, x5, x2
    //
    // ID instruction requires x5 while EX instruction is
    // loading x5 from memory.
    // =========================================================

    always @(*) begin

        // -----------------------------------------------------
        // Normal operation
        // -----------------------------------------------------

        pc_write   = 1'b1;
        ifid_write = 1'b1;
        idex_flush = 1'b0;


        // -----------------------------------------------------
        // Detect load-use hazard
        // -----------------------------------------------------

        if (idex_memread &&
            (idex_rd != 5'd0) &&
            ((idex_rd == id_rs1) ||
             (idex_rd == id_rs2))) begin

            /*
             * Freeze PC
             */
            pc_write = 1'b0;

            /*
             * Freeze IF/ID
             */
            ifid_write = 1'b0;

            /*
             * Insert bubble into ID/EX
             */
            idex_flush = 1'b1;

        end

    end

endmodule