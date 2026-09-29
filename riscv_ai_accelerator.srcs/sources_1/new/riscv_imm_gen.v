`timescale 1ns/1ps

module riscv_imm_gen (

    input      [31:0] instruction,

    output reg [31:0] immediate

);

    // =========================================================
    // Opcode
    // =========================================================

    wire [6:0] opcode;

    assign opcode = instruction[6:0];


    // =========================================================
    // RISC-V Opcodes
    // =========================================================

    localparam OPCODE_I      = 7'b0010011;
    localparam OPCODE_LOAD   = 7'b0000011;
    localparam OPCODE_STORE  = 7'b0100011;
    localparam OPCODE_BRANCH = 7'b1100011;
    localparam OPCODE_LUI    = 7'b0110111;
    localparam OPCODE_AUIPC  = 7'b0010111;
    localparam OPCODE_JAL    = 7'b1101111;


    // =========================================================
    // Immediate generator
    // =========================================================

    always @(*) begin

        immediate = 32'd0;

        case (opcode)

            // =================================================
            // I-TYPE
            //
            // ADDI, ANDI, ORI, XORI
            // =================================================

            OPCODE_I: begin

                immediate =
                    {{20{instruction[31]}},
                     instruction[31:20]};

            end


            // =================================================
            // LOAD
            //
            // LW
            // =================================================

            OPCODE_LOAD: begin

                immediate =
                    {{20{instruction[31]}},
                     instruction[31:20]};

            end


            // =================================================
            // S-TYPE
            //
            // SW
            //
            // imm[11:5] = instruction[31:25]
            // imm[4:0]  = instruction[11:7]
            // =================================================

            OPCODE_STORE: begin

                immediate =
                    {{20{instruction[31]}},
                     instruction[31:25],
                     instruction[11:7]};

            end


            // =================================================
            // B-TYPE
            //
            // BEQ / BNE
            //
            // imm[12]   = bit 31
            // imm[11]   = bit 7
            // imm[10:5] = bits 30:25
            // imm[4:1]  = bits 11:8
            // imm[0]    = 0
            // =================================================

            OPCODE_BRANCH: begin

                immediate =
                    {{19{instruction[31]}},
                     instruction[31],
                     instruction[7],
                     instruction[30:25],
                     instruction[11:8],
                     1'b0};

            end


            // =================================================
            // U-TYPE
            //
            // LUI
            // =================================================

            OPCODE_LUI: begin

                immediate =
                    {instruction[31:12],
                     12'b0};

            end


            // =================================================
            // AUIPC
            // =================================================

            OPCODE_AUIPC: begin

                immediate =
                    {instruction[31:12],
                     12'b0};

            end


            // =================================================
            // J-TYPE
            //
            // JAL
            //
            // imm[20]    = bit 31
            // imm[10:1]  = bits 30:21
            // imm[11]    = bit 20
            // imm[19:12] = bits 19:12
            // imm[0]     = 0
            // =================================================

            OPCODE_JAL: begin

                immediate =
                    {{11{instruction[31]}},
                     instruction[31],
                     instruction[19:12],
                     instruction[20],
                     instruction[30:21],
                     1'b0};

            end


            default: begin

                immediate = 32'd0;

            end

        endcase

    end

endmodule