`timescale 1ns/1ps

// Synthesizable SoC variant for the Basys 3 demo.
// Unlike the simulation-only testbench, source matrices are restored by reset.
module riscv_ai_soc_basys3 (
    input clk,
    input rst,
    output [31:0] imem_addr,
    input  [31:0] imem_rdata,
    output ai_busy,
    output ai_done,
    output [31:0] cpu_x25
);
    wire dmem_we, dmem_re;
    wire [31:0] dmem_addr, dmem_wdata;
    reg  [31:0] dmem_rdata;

    riscv_pipeline CPU (
        .clk(clk), .rst(rst),
        .imem_addr(imem_addr), .imem_rdata(imem_rdata),
        .dmem_we(dmem_we), .dmem_re(dmem_re),
        .dmem_addr(dmem_addr), .dmem_wdata(dmem_wdata),
        .dmem_rdata(dmem_rdata)
    );

    // Memory-mapped accelerator window: 0x00000080 through 0x000000FF.
    wire ai_selected = (dmem_addr[31:7] == 25'd1);
    wire [31:0] ai_read_data;
    ai_accel_bus AI_BUS (
        .clk(clk), .rst(rst),
        .bus_write_enable(dmem_we && ai_selected),
        .bus_write_addr(dmem_addr[6:0]), .bus_write_data(dmem_wdata),
        .bus_read_enable(dmem_re && ai_selected),
        .bus_read_addr(dmem_addr[6:0]), .bus_read_data(ai_read_data),
        .busy(ai_busy), .done(ai_done)
    );

    reg [31:0] data_ram [0:255];
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 256; i = i + 1)
                data_ram[i] <= 32'd0;
            // Matrix A: rows [1,2,3,4] through [13,14,15,16].
            data_ram[0] <= 32'h04030201;
            data_ram[1] <= 32'h08070605;
            data_ram[2] <= 32'h0c0b0a09;
            data_ram[3] <= 32'h100f0e0d;
            // Matrix B.
            data_ram[4] <= 32'h00010201;
            data_ram[5] <= 32'h01020100;
            data_ram[6] <= 32'h02010001;
            data_ram[7] <= 32'h01000102;
        end else if (dmem_we && !ai_selected) begin
            data_ram[dmem_addr[9:2]] <= dmem_wdata;
        end
    end

    always @(*) begin
        dmem_rdata = 32'd0;
        if (dmem_re) begin
            if (ai_selected)
                dmem_rdata = ai_read_data;
            else
                dmem_rdata = data_ram[dmem_addr[9:2]];
        end
    end

    assign cpu_x25 = CPU.REGFILE.regs[25];
endmodule
