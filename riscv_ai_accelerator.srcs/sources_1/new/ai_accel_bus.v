`timescale 1ns/1ps

module ai_accel_bus (

    input clk,
    input rst,

    // =========================================================
    // CPU / BUS WRITE INTERFACE
    // =========================================================

    input        bus_write_enable,
    input [6:0]  bus_write_addr,
    input [31:0] bus_write_data,


    // =========================================================
    // CPU / BUS READ INTERFACE
    // =========================================================

    input        bus_read_enable,
    input [6:0]  bus_read_addr,

    output reg [31:0] bus_read_data,


    // =========================================================
    // ACCELERATOR STATUS
    // =========================================================

    output busy,
    output done

);


    // =========================================================
    // INTERNAL SIGNALS
    // =========================================================

    reg start_pulse;


    wire [5:0] accelerator_write_addr;

    wire [31:0] accelerator_read_data;


    // =========================================================
    // ADDRESS TO ACCELERATOR
    //
    // The existing accelerator top uses a 6-bit write address.
    // All write registers are below 0x40, so the lower 6 bits
    // are sufficient.
    // =========================================================

    assign accelerator_write_addr =
                bus_write_addr[5:0];


    // =========================================================
    // START GENERATOR
    //
    // CPU writes:
    //
    // Address = 0x20
    // Data[0] = 1
    //
    // This generates a one-clock start pulse.
    // =========================================================

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            start_pulse <= 1'b0;

        end

        else begin

            // Default:
            // start is only one clock wide.

            start_pulse <= 1'b0;


            // -------------------------------------------------
            // CONTROL REGISTER
            // -------------------------------------------------

            if (bus_write_enable &&
                (bus_write_addr == 7'h20) &&
                bus_write_data[0]) begin

                start_pulse <= 1'b1;

            end

        end

    end


    // =========================================================
    // ACCELERATOR TOP
    // =========================================================

    ai_accelerator_top ACCELERATOR (

        .clk(clk),
        .rst(rst),


        // -----------------------------------------------------
        // MATRIX WRITE INTERFACE
        // -----------------------------------------------------

        .write_enable(
            bus_write_enable &&
            (bus_write_addr != 7'h20)
        ),

        .write_addr(
            accelerator_write_addr
        ),

        .write_data(
            bus_write_data
        ),


        // -----------------------------------------------------
        // START
        // -----------------------------------------------------

        .start(start_pulse),


        // -----------------------------------------------------
        // STATUS
        // -----------------------------------------------------

        .busy(busy),
        .done(done),


        // -----------------------------------------------------
        // RESULT READ INTERFACE
        // -----------------------------------------------------

        .read_addr(bus_read_addr),

        .read_data(accelerator_read_data)

    );


    // =========================================================
    // BUS READ MULTIPLEXER
    // =========================================================

    always @(*) begin

        bus_read_data = 32'd0;


        if (bus_read_enable) begin

            bus_read_data = accelerator_read_data;

        end

        else begin

            bus_read_data = 32'd0;

        end

    end


endmodule