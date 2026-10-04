`timescale 1ns/1ps

module ai_accelerator (

    input clk,
    input rst,

    // =========================================================
    // Accelerator control
    // =========================================================

    input start,

    output busy,
    output done,


    // =========================================================
    // Matrix A
    //
    // Four rows × four INT8 values
    // =========================================================

    input signed [7:0] a0,
    input signed [7:0] a1,
    input signed [7:0] a2,
    input signed [7:0] a3,


    // =========================================================
    // Matrix B
    //
    // Four columns × four INT8 values
    // =========================================================

    input signed [7:0] b0,
    input signed [7:0] b1,
    input signed [7:0] b2,
    input signed [7:0] b3,


    // =========================================================
    // Result matrix C
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
    // Controller signals
    // =========================================================

    wire load_enable;
    wire compute_enable;

    wire [1:0] controller_state;


    // =========================================================
    // Systolic array compute cycles
    //
    // 4x4 array needs multiple cycles for:
    //
    // input skew
    // +
    // matrix computation
    // +
    // output propagation
    //
    // =========================================================

    localparam COMPUTE_CYCLES = 8'd10;


    // =========================================================
    // Controller
    // =========================================================

    ai_accel_controller CONTROLLER (

        .clk(clk),
        .rst(rst),

        .start(start),

        .compute_cycles(COMPUTE_CYCLES),

        .busy(busy),
        .done(done),

        .load_enable(load_enable),
        .compute_enable(compute_enable),

        .state(controller_state)

    );


    // =========================================================
    // Systolic Array
    // =========================================================

    ai_systolic_4x4 SYSTOLIC_ARRAY (

        .clk(clk),
        .rst(rst),

        .enable(compute_enable),

        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),

        .b0(b0),
        .b1(b1),
        .b2(b2),
        .b3(b3),

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