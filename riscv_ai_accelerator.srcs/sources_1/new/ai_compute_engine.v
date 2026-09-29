`timescale 1ns/1ps

module ai_compute_engine (

    input clk,
    input rst,

    // =========================================================
    // START / STATUS
    // =========================================================

    input start,

    output busy,
    output done,


    // =========================================================
    // MATRIX A
    //
    // Four rows, four signed INT8 values per row
    // =========================================================

    input [31:0] matrix_a0,
    input [31:0] matrix_a1,
    input [31:0] matrix_a2,
    input [31:0] matrix_a3,


    // =========================================================
    // MATRIX B
    //
    // Four rows, four signed INT8 values per row
    // =========================================================

    input [31:0] matrix_b0,
    input [31:0] matrix_b1,
    input [31:0] matrix_b2,
    input [31:0] matrix_b3,


    // =========================================================
    // RESULT MATRIX C
    // =========================================================

    output signed [31:0] c00,
    output signed [31:0] c01,
    output signed [31:0] c02,
    output signed [31:0] c03,

    output signed [31:0] c10,
    output signed [31:0] c11,
    output signed [31:0] c12,
    output signed [31:0] c13,

    output signed [31:0] c20,
    output signed [31:0] c21,
    output signed [31:0] c22,
    output signed [31:0] c23,

    output signed [31:0] c30,
    output signed [31:0] c31,
    output signed [31:0] c32,
    output signed [31:0] c33

);


    // =========================================================
    // STREAM CONTROLLER SIGNALS
    // =========================================================

    wire stream_busy;
    wire stream_done;

    wire signed [7:0] stream_a0;
    wire signed [7:0] stream_a1;
    wire signed [7:0] stream_a2;
    wire signed [7:0] stream_a3;

    wire signed [7:0] stream_b0;
    wire signed [7:0] stream_b1;
    wire signed [7:0] stream_b2;
    wire signed [7:0] stream_b3;

    wire compute_enable;


    // =========================================================
    // STREAM CONTROLLER
    // =========================================================

    ai_stream_controller STREAM_CONTROLLER (

        .clk(clk),
        .rst(rst),

        .start(start),

        .busy(stream_busy),
        .done(stream_done),

        .matrix_a0(matrix_a0),
        .matrix_a1(matrix_a1),
        .matrix_a2(matrix_a2),
        .matrix_a3(matrix_a3),

        .matrix_b0(matrix_b0),
        .matrix_b1(matrix_b1),
        .matrix_b2(matrix_b2),
        .matrix_b3(matrix_b3),

        .a0(stream_a0),
        .a1(stream_a1),
        .a2(stream_a2),
        .a3(stream_a3),

        .b0(stream_b0),
        .b1(stream_b1),
        .b2(stream_b2),
        .b3(stream_b3),

        .compute_enable(compute_enable)

    );


    // =========================================================
    // BUSY / DONE
    // =========================================================

    assign busy = stream_busy;

    assign done = stream_done;


    // =========================================================
    // 4×4 SYSTOLIC ARRAY
    // =========================================================

    ai_systolic_4x4 SYSTOLIC_ARRAY (

        .clk(clk),
        .rst(rst),

        .enable(compute_enable),

        .a0(stream_a0),
        .a1(stream_a1),
        .a2(stream_a2),
        .a3(stream_a3),

        .b0(stream_b0),
        .b1(stream_b1),
        .b2(stream_b2),
        .b3(stream_b3),

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

endmodule