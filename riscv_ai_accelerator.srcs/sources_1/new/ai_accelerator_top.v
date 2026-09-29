`timescale 1ns/1ps

module ai_accelerator_top (

    input clk,
    input rst,

    // =========================================================
    // MEMORY-MAPPED WRITE INTERFACE
    // =========================================================

    input        write_enable,
    input [5:0]  write_addr,
    input [31:0] write_data,

    // =========================================================
    // START CONTROL
    // =========================================================

    input start,

    // =========================================================
    // STATUS
    // =========================================================

    output busy,
    output done,

    // =========================================================
    // MEMORY-MAPPED READ INTERFACE
    // =========================================================

    input [6:0]  read_addr,
    output reg [31:0] read_data

);


    // =========================================================
    // MATRIX A STORAGE
    // =========================================================

    reg [31:0] matrix_a0;
    reg [31:0] matrix_a1;
    reg [31:0] matrix_a2;
    reg [31:0] matrix_a3;


    // =========================================================
    // MATRIX B STORAGE
    // =========================================================

    reg [31:0] matrix_b0;
    reg [31:0] matrix_b1;
    reg [31:0] matrix_b2;
    reg [31:0] matrix_b3;


    // =========================================================
    // COMPUTE ENGINE RESULTS
    // =========================================================

    wire signed [31:0] c00;
    wire signed [31:0] c01;
    wire signed [31:0] c02;
    wire signed [31:0] c03;

    wire signed [31:0] c10;
    wire signed [31:0] c11;
    wire signed [31:0] c12;
    wire signed [31:0] c13;

    wire signed [31:0] c20;
    wire signed [31:0] c21;
    wire signed [31:0] c22;
    wire signed [31:0] c23;

    wire signed [31:0] c30;
    wire signed [31:0] c31;
    wire signed [31:0] c32;
    wire signed [31:0] c33;


    // =========================================================
    // MATRIX REGISTER WRITE LOGIC
    // =========================================================

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            matrix_a0 <= 32'd0;
            matrix_a1 <= 32'd0;
            matrix_a2 <= 32'd0;
            matrix_a3 <= 32'd0;

            matrix_b0 <= 32'd0;
            matrix_b1 <= 32'd0;
            matrix_b2 <= 32'd0;
            matrix_b3 <= 32'd0;

        end

        else begin

            if (write_enable) begin

                case (write_addr)

                    // =================================================
                    // MATRIX A
                    // =================================================

                    6'h00:
                        matrix_a0 <= write_data;

                    6'h04:
                        matrix_a1 <= write_data;

                    6'h08:
                        matrix_a2 <= write_data;

                    6'h0C:
                        matrix_a3 <= write_data;


                    // =================================================
                    // MATRIX B
                    // =================================================

                    6'h10:
                        matrix_b0 <= write_data;

                    6'h14:
                        matrix_b1 <= write_data;

                    6'h18:
                        matrix_b2 <= write_data;

                    6'h1C:
                        matrix_b3 <= write_data;


                    default:
                        begin
                        end

                endcase

            end

        end

    end


    // =========================================================
    // COMPUTE ENGINE
    // =========================================================

    ai_compute_engine COMPUTE_ENGINE (

        .clk(clk),
        .rst(rst),

        .start(start),

        .busy(busy),
        .done(done),

        .matrix_a0(matrix_a0),
        .matrix_a1(matrix_a1),
        .matrix_a2(matrix_a2),
        .matrix_a3(matrix_a3),

        .matrix_b0(matrix_b0),
        .matrix_b1(matrix_b1),
        .matrix_b2(matrix_b2),
        .matrix_b3(matrix_b3),

        .c00(c00),
        .c01(c01),
        .c02(c02),
        .c03(c03),

        .c10(c10),
        .c11(c11),
        .c12(c12),
        .c13(c13),

        .c20(c20),
        .c21(c21),
        .c22(c22),
        .c23(c23),

        .c30(c30),
        .c31(c31),
        .c32(c32),
        .c33(c33)

    );


    // =========================================================
    // COMPLETE READ MAP
    //
    // STATUS
    // 0x24
    //
    // RESULT MATRIX
    // 0x28 - 0x64
    // =========================================================

    always @(*) begin

        read_data = 32'd0;

        case (read_addr)

            // =================================================
            // STATUS
            // =================================================

            7'h24:
                read_data = {
                    30'd0,
                    done,
                    busy
                };


            // =================================================
            // ROW 0
            // =================================================

            7'h28:
                read_data = c00;

            7'h2C:
                read_data = c01;

            7'h30:
                read_data = c02;

            7'h34:
                read_data = c03;


            // =================================================
            // ROW 1
            // =================================================

            7'h38:
                read_data = c10;

            7'h3C:
                read_data = c11;

            7'h40:
                read_data = c12;

            7'h44:
                read_data = c13;


            // =================================================
            // ROW 2
            // =================================================

            7'h48:
                read_data = c20;

            7'h4C:
                read_data = c21;

            7'h50:
                read_data = c22;

            7'h54:
                read_data = c23;


            // =================================================
            // ROW 3
            // =================================================

            7'h58:
                read_data = c30;

            7'h5C:
                read_data = c31;

            7'h60:
                read_data = c32;

            7'h64:
                read_data = c33;


            // =================================================
            // DEFAULT
            // =================================================

            default:
                read_data = 32'd0;

        endcase

    end

endmodule