`timescale 1ns/1ps

module ai_matrix_buffer (

    input clk,
    input rst,

    // =========================================================
    // Matrix A write interface
    // =========================================================

    input        a_write_enable,
    input  [1:0]  a_write_addr,
    input [31:0] a_write_data,


    // =========================================================
    // Matrix B write interface
    // =========================================================

    input        b_write_enable,
    input  [1:0]  b_write_addr,
    input [31:0] b_write_data,


    // =========================================================
    // Matrix A read interface
    // =========================================================

    input  [1:0]  a_read_addr,
    output reg [31:0] a_read_data,


    // =========================================================
    // Matrix B read interface
    // =========================================================

    input  [1:0]  b_read_addr,
    output reg [31:0] b_read_data

);


    // =========================================================
    // Matrix storage
    //
    // Four 32-bit words for A
    // Four 32-bit words for B
    // =========================================================

    reg [31:0] matrix_a [0:3];

    reg [31:0] matrix_b [0:3];

    integer i;


    // =========================================================
    // WRITE LOGIC
    // =========================================================

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            for (i = 0; i < 4; i = i + 1) begin

                matrix_a[i] <= 32'd0;

                matrix_b[i] <= 32'd0;

            end

        end

        else begin

            if (a_write_enable)
                matrix_a[a_write_addr] <= a_write_data;

            if (b_write_enable)
                matrix_b[b_write_addr] <= b_write_data;

        end

    end


    // =========================================================
    // READ MATRIX A
    // =========================================================

    always @(*) begin

        a_read_data = matrix_a[a_read_addr];

    end


    // =========================================================
    // READ MATRIX B
    // =========================================================

    always @(*) begin

        b_read_data = matrix_b[b_read_addr];

    end


endmodule