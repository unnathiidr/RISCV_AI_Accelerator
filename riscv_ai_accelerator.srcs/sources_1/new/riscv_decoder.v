`timescale 1ns/1ps

module riscv_decoder (

    input      [31:0] instruction,

    output reg [4:0]  rs1,
    output reg [4:0]  rs2,
    output reg [4:0]  rd,

    output reg        reg_write,
    output reg        mem_read,
    output reg        mem_write,

    output reg        alu_src,

    output reg        branch,
    output reg        branch_ne,

    output reg        jump,

    output reg        ai_enable,

    output reg [3:0]  alu_control,

    output reg [31:0] immediate

);


    // =========================================================
    // Opcodes
    // =========================================================

    localparam OPCODE_R      = 7'b0110011;
    localparam OPCODE_I      = 7'b0010011;
    localparam OPCODE_LOAD   = 7'b0000011;
    localparam OPCODE_STORE  = 7'b0100011;
    localparam OPCODE_BRANCH = 7'b1100011;
    localparam OPCODE_JAL    = 7'b1101111;

    // Custom-0 opcode
    localparam OPCODE_AI     = 7'b0001011;


    // =========================================================
    // ALU operations
    // =========================================================

    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;


    // =========================================================
    // Instruction fields
    // =========================================================

    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];


    // =========================================================
    // Decoder
    // =========================================================

    always @(*) begin

        // -----------------------------------------------------
        // Default values
        // -----------------------------------------------------

        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        rd  = instruction[11:7];

        reg_write = 1'b0;

        mem_read  = 1'b0;
        mem_write = 1'b0;

        alu_src = 1'b0;

        branch    = 1'b0;
        branch_ne = 1'b0;

        jump = 1'b0;

        ai_enable = 1'b0;

        alu_control = ALU_ADD;

        immediate = 32'd0;


        // =====================================================
        // Instruction decoding
        // =====================================================

        case (opcode)


            // =================================================
            // R-TYPE
            // =================================================

            OPCODE_R: begin

                reg_write = 1'b1;

                case ({funct7,funct3})

                    // ADD
                    10'b0000000000:
                        alu_control = ALU_ADD;

                    // SUB
                    10'b0100000000:
                        alu_control = ALU_SUB;

                    // AND
                    10'b0000000111:
                        alu_control = ALU_AND;

                    // OR
                    10'b0000000110:
                        alu_control = ALU_OR;

                    // XOR
                    10'b0000000100:
                        alu_control = ALU_XOR;

                    // SLT
                    10'b0000000010:
                        alu_control = ALU_SLT;

                    default: begin
                        reg_write = 1'b0;
                    end

                endcase

            end


            // =================================================
            // I-TYPE ALU
            // =================================================

            OPCODE_I: begin

                reg_write = 1'b1;

                alu_src = 1'b1;

                immediate =
                    {{20{instruction[31]}},
                     instruction[31:20]};


                case (funct3)

                    // ADDI
                    3'b000:
                        alu_control = ALU_ADD;

                    // ANDI
                    3'b111:
                        alu_control = ALU_AND;

                    // ORI
                    3'b110:
                        alu_control = ALU_OR;

                    // XORI
                    3'b100:
                        alu_control = ALU_XOR;

                    default: begin
                        reg_write = 1'b0;
                    end

                endcase

            end


            // =================================================
            // LOAD WORD
            // =================================================

            OPCODE_LOAD: begin

                if (funct3 == 3'b010) begin

                    reg_write = 1'b1;

                    mem_read = 1'b1;

                    alu_src = 1'b1;

                    alu_control = ALU_ADD;

                    immediate =
                        {{20{instruction[31]}},
                         instruction[31:20]};

                end

            end


            // =================================================
            // STORE WORD
            // =================================================

            OPCODE_STORE: begin

                if (funct3 == 3'b010) begin

                    mem_write = 1'b1;

                    alu_src = 1'b1;

                    alu_control = ALU_ADD;

                    immediate =
                        {{20{instruction[31]}},
                         instruction[31:25],
                         instruction[11:7]};

                end

            end


            // =================================================
            // BRANCH
            // =================================================

            OPCODE_BRANCH: begin

                if ((funct3 == 3'b000) ||
                    (funct3 == 3'b001)) begin

                    branch = 1'b1;

                    branch_ne =
                        (funct3 == 3'b001);

                    immediate =
                        {{19{instruction[31]}},
                         instruction[31],
                         instruction[7],
                         instruction[30:25],
                         instruction[11:8],
                         1'b0};

                end

            end


            // =================================================
            // JAL
            // =================================================

            OPCODE_JAL: begin

                jump = 1'b1;

                reg_write = 1'b1;

                immediate =
                    {{11{instruction[31]}},
                     instruction[31],
                     instruction[19:12],
                     instruction[20],
                     instruction[30:21],
                     1'b0};

            end


            // =================================================
            // CUSTOM AI INSTRUCTION
            //
            // AI_DOT4
            //
            // funct7 = 0000001
            // funct3 = 000
            // opcode = 0001011
            // =================================================

            OPCODE_AI: begin

                if ((funct7 == 7'b0000001) &&
                    (funct3 == 3'b000)) begin

                    ai_enable = 1'b1;

                    reg_write = 1'b1;

                end

            end


            default: begin

                reg_write = 1'b0;

            end

        endcase

    end

endmodule