`timescale 1ns/1ps

module riscv_alu (
    input      [31:0] operand_a,
    input      [31:0] operand_b,

    input      [3:0]  alu_control,

    output reg [31:0] result,

    output            zero,
    output            less_than
);

    // =========================================================
    // ALU operation codes
    // =========================================================

    parameter ALU_ADD = 4'b0000;
    parameter ALU_SUB = 4'b0001;
    parameter ALU_AND = 4'b0010;
    parameter ALU_OR  = 4'b0011;
    parameter ALU_XOR = 4'b0100;
    parameter ALU_SLT = 4'b0101;
    parameter ALU_SLL = 4'b0110;
    parameter ALU_SRL = 4'b0111;
    parameter ALU_SRA = 4'b1000;


    // =========================================================
    // ALU
    // =========================================================

    always @(*) begin

        case (alu_control)

            // ADD
            ALU_ADD:
                result = operand_a + operand_b;


            // SUB
            ALU_SUB:
                result = operand_a - operand_b;


            // AND
            ALU_AND:
                result = operand_a & operand_b;


            // OR
            ALU_OR:
                result = operand_a | operand_b;


            // XOR
            ALU_XOR:
                result = operand_a ^ operand_b;


            // Signed Set Less Than
            ALU_SLT:
                result = ($signed(operand_a) <
                          $signed(operand_b)) ?
                          32'd1 : 32'd0;


            // Shift Left Logical
            ALU_SLL:
                result = operand_a << operand_b[4:0];


            // Shift Right Logical
            ALU_SRL:
                result = operand_a >> operand_b[4:0];


            // Shift Right Arithmetic
            ALU_SRA:
                result = $signed(operand_a) >>> operand_b[4:0];


            default:
                result = 32'd0;

        endcase

    end


    // =========================================================
    // Zero flag
    // =========================================================

    assign zero = (result == 32'd0);


    // =========================================================
    // Signed less-than flag
    // =========================================================

    assign less_than =
        ($signed(operand_a) < $signed(operand_b));

endmodule