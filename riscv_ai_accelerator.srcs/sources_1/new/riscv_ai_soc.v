`timescale 1ns/1ps

module riscv_ai_soc (

    input clk,
    input rst,

    // =========================================================
    // INSTRUCTION MEMORY
    // =========================================================

    output [31:0] imem_addr,
    input  [31:0] imem_rdata

);

    // =========================================================
    // RISC-V DATA BUS
    // =========================================================

    wire        dmem_we;
    wire        dmem_re;

    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;

    reg [31:0] dmem_rdata;


    // =========================================================
    // RISC-V CPU
    // =========================================================

    riscv_pipeline CPU (

        .clk(clk),
        .rst(rst),

        .imem_addr(imem_addr),
        .imem_rdata(imem_rdata),

        .dmem_we(dmem_we),
        .dmem_re(dmem_re),

        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),

        .dmem_rdata(dmem_rdata)

    );


    // =========================================================
    // AI REGION
    //
    // 0x80 - 0xFF
    //
    // Base = 0x80
    // =========================================================

    wire ai_selected;

    assign ai_selected =
        (dmem_addr[31:7] == 25'd1);


    // =========================================================
    // AI BUS
    // =========================================================

    wire [31:0] ai_read_data;

    wire ai_busy;
    wire ai_done;


    ai_accel_bus AI_BUS (

        .clk(clk),
        .rst(rst),

        .bus_write_enable(
            dmem_we && ai_selected
        ),

        .bus_write_addr(
            dmem_addr[6:0]
        ),

        .bus_write_data(
            dmem_wdata
        ),

        .bus_read_enable(
            dmem_re && ai_selected
        ),

        .bus_read_addr(
            dmem_addr[6:0]
        ),

        .bus_read_data(
            ai_read_data
        ),

        .busy(ai_busy),
        .done(ai_done)

    );


    // =========================================================
    // NORMAL DATA RAM
    // =========================================================

    reg [31:0] data_ram [0:255];

    integer i;


    // =========================================================
    // DATA RAM WRITE
    // =========================================================

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            for (i = 0; i < 256; i = i + 1)

                data_ram[i] <= 32'd0;

        end

        else begin

            if (dmem_we && !ai_selected)

                data_ram[dmem_addr[9:2]]
                    <= dmem_wdata;

        end

    end


    // =========================================================
    // DATA READ MUX
    // =========================================================

    always @(*) begin

        dmem_rdata = 32'd0;

        if (dmem_re) begin

            if (ai_selected)

                dmem_rdata = ai_read_data;

            else

                dmem_rdata =
                    data_ram[dmem_addr[9:2]];

        end

    end


endmodule