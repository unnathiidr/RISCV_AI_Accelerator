`timescale 1ns/1ps

module ai_systolic_4x4 (

    input clk,
    input rst,

    input enable,

    // =========================================================
    // Four 8-bit inputs for each row
    // =========================================================

    input signed [7:0] a0,
    input signed [7:0] a1,
    input signed [7:0] a2,
    input signed [7:0] a3,


    // =========================================================
    // Four 8-bit inputs for each column
    // =========================================================

    input signed [7:0] b0,
    input signed [7:0] b1,
    input signed [7:0] b2,
    input signed [7:0] b3,


    // =========================================================
    // 4 × 4 output matrix
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
    // A operand propagation
    //
    // Horizontal movement
    // =========================================================

    wire signed [7:0] a00;
    wire signed [7:0] a01;
    wire signed [7:0] a02;
    wire signed [7:0] a03;

    wire signed [7:0] a10;
    wire signed [7:0] a11;
    wire signed [7:0] a12;
    wire signed [7:0] a13;

    wire signed [7:0] a20;
    wire signed [7:0] a21;
    wire signed [7:0] a22;
    wire signed [7:0] a23;

    wire signed [7:0] a30;
    wire signed [7:0] a31;
    wire signed [7:0] a32;
    wire signed [7:0] a33;


    // =========================================================
    // B operand propagation
    //
    // Vertical movement
    // =========================================================

    wire signed [7:0] b00;
    wire signed [7:0] b01;
    wire signed [7:0] b02;
    wire signed [7:0] b03;

    wire signed [7:0] b10;
    wire signed [7:0] b11;
    wire signed [7:0] b12;
    wire signed [7:0] b13;

    wire signed [7:0] b20;
    wire signed [7:0] b21;
    wire signed [7:0] b22;
    wire signed [7:0] b23;

    wire signed [7:0] b30;
    wire signed [7:0] b31;
    wire signed [7:0] b32;
    wire signed [7:0] b33;


    // =========================================================
    // PE00
    // =========================================================

    ai_pe PE00 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a0),
        .b_in(b0),

        .a_out(a00),
        .b_out(b00),

        .accumulator(c00)

    );


    // =========================================================
    // PE01
    // =========================================================

    ai_pe PE01 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a00),
        .b_in(b1),

        .a_out(a01),
        .b_out(b01),

        .accumulator(c01)

    );


    // =========================================================
    // PE02
    // =========================================================

    ai_pe PE02 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a01),
        .b_in(b2),

        .a_out(a02),
        .b_out(b02),

        .accumulator(c02)

    );


    // =========================================================
    // PE03
    // =========================================================

    ai_pe PE03 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a02),
        .b_in(b3),

        .a_out(a03),
        .b_out(b03),

        .accumulator(c03)

    );


    // =========================================================
    // PE10
    // =========================================================

    ai_pe PE10 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a1),
        .b_in(b00),

        .a_out(a10),
        .b_out(b10),

        .accumulator(c10)

    );


    // =========================================================
    // PE11
    // =========================================================

    ai_pe PE11 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a10),
        .b_in(b01),

        .a_out(a11),
        .b_out(b11),

        .accumulator(c11)

    );


    // =========================================================
    // PE12
    // =========================================================

    ai_pe PE12 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a11),
        .b_in(b02),

        .a_out(a12),
        .b_out(b12),

        .accumulator(c12)

    );


    // =========================================================
    // PE13
    // =========================================================

    ai_pe PE13 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a12),
        .b_in(b03),

        .a_out(a13),
        .b_out(b13),

        .accumulator(c13)

    );


    // =========================================================
    // PE20
    // =========================================================

    ai_pe PE20 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a2),
        .b_in(b10),

        .a_out(a20),
        .b_out(b20),

        .accumulator(c20)

    );


    // =========================================================
    // PE21
    // =========================================================

    ai_pe PE21 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a20),
        .b_in(b11),

        .a_out(a21),
        .b_out(b21),

        .accumulator(c21)

    );


    // =========================================================
    // PE22
    // =========================================================

    ai_pe PE22 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a21),
        .b_in(b12),

        .a_out(a22),
        .b_out(b22),

        .accumulator(c22)

    );


    // =========================================================
    // PE23
    // =========================================================

    ai_pe PE23 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a22),
        .b_in(b13),

        .a_out(a23),
        .b_out(b23),

        .accumulator(c23)

    );


    // =========================================================
    // PE30
    // =========================================================

    ai_pe PE30 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a3),
        .b_in(b20),

        .a_out(a30),
        .b_out(b30),

        .accumulator(c30)

    );


    // =========================================================
    // PE31
    // =========================================================

    ai_pe PE31 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a30),
        .b_in(b21),

        .a_out(a31),
        .b_out(b31),

        .accumulator(c31)

    );


    // =========================================================
    // PE32
    // =========================================================

    ai_pe PE32 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a31),
        .b_in(b22),

        .a_out(a32),
        .b_out(b32),

        .accumulator(c32)

    );


    // =========================================================
    // PE33
    // =========================================================

    ai_pe PE33 (

        .clk(clk),
        .rst(rst),
        .enable(enable),

        .a_in(a32),
        .b_in(b23),

        .a_out(a33),
        .b_out(b33),

        .accumulator(c33)

    );

endmodule