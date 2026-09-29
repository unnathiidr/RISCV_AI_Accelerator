`timescale 1ns/1ps

module riscv_branch_unit (

    input  [31:0] pc,

    input  [31:0] rs1_value,
    input  [31:0] rs2_value,

    input         branch,
    input         branch_ne,
    input         jump,

    input  [31:0] immediate,

    output reg    branch_taken,
    output reg [31:0] target_address

);

    always @(*) begin

        branch_taken  = 1'b0;
        target_address = pc + immediate;

        // -----------------------------------------------------
        // JAL
        // -----------------------------------------------------

        if (jump) begin

            branch_taken = 1'b1;

        end

        // -----------------------------------------------------
        // BEQ
        // -----------------------------------------------------

        else if (branch && !branch_ne) begin

            if (rs1_value == rs2_value)
                branch_taken = 1'b1;

        end

        // -----------------------------------------------------
        // BNE
        // -----------------------------------------------------

        else if (branch && branch_ne) begin

            if (rs1_value != rs2_value)
                branch_taken = 1'b1;

        end

    end

endmodule