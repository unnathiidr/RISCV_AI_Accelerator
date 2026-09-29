`timescale 1ns/1ps

module riscv_regfile (
    input             clk,
    input             rst,

    input      [4:0]  rs1_addr,
    input      [4:0]  rs2_addr,

    output     [31:0] rs1_data,
    output     [31:0] rs2_data,

    input             rd_we,
    input      [4:0]  rd_addr,
    input      [31:0] rd_data
);

    reg [31:0] regs [0:31];

    integer i;


    // =========================================================
    // Read port 1 with write-through bypass
    // =========================================================

    assign rs1_data =
        (rs1_addr == 5'd0) ?
            32'd0 :

        (rd_we && (rd_addr != 5'd0) &&
         (rd_addr == rs1_addr)) ?
            rd_data :

            regs[rs1_addr];


    // =========================================================
    // Read port 2 with write-through bypass
    // =========================================================

    assign rs2_data =
        (rs2_addr == 5'd0) ?
            32'd0 :

        (rd_we && (rd_addr != 5'd0) &&
         (rd_addr == rs2_addr)) ?
            rd_data :

            regs[rs2_addr];


    // =========================================================
    // Register write
    // =========================================================

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'd0;

        end

        else begin

            if (rd_we && (rd_addr != 5'd0))
                regs[rd_addr] <= rd_data;

            regs[0] <= 32'd0;

        end

    end

endmodule