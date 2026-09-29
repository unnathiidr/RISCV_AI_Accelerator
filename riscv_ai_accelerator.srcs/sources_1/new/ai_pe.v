`timescale 1ns/1ps

module ai_pe (

    input               clk,
    input               rst,

    input               enable,

    input signed [7:0]  a_in,
    input signed [7:0]  b_in,

    output reg signed [7:0]  a_out,
    output reg signed [7:0]  b_out,

    output reg signed [31:0] accumulator

);

    reg signed [15:0] product;


    always @(posedge clk or posedge rst) begin

        if (rst) begin

            a_out      <= 8'sd0;
            b_out      <= 8'sd0;

            accumulator <= 32'sd0;

        end

        else if (enable) begin

            // -------------------------------------------------
            // Pass operands to neighboring PE
            // -------------------------------------------------

            a_out <= a_in;

            b_out <= b_in;


            // -------------------------------------------------
            // INT8 multiplication
            // -------------------------------------------------

            product = a_in * b_in;


            // -------------------------------------------------
            // Accumulate
            // -------------------------------------------------

            accumulator <= accumulator + product;

        end

    end

endmodule