`timescale 1ns/1ps

module ai_accel_controller (

    input  clk,
    input  rst,

    // Start computation
    input start,

    // Number of computation cycles
    input [7:0] compute_cycles,

    // Status
    output reg busy,
    output reg done,

    // Control for accelerator datapath
    output reg load_enable,
    output reg compute_enable,

    // Current state for debugging
    output reg [1:0] state

);


    // =========================================================
    // FSM STATES
    // =========================================================

    localparam STATE_IDLE    = 2'b00;
    localparam STATE_LOAD    = 2'b01;
    localparam STATE_COMPUTE = 2'b10;
    localparam STATE_DONE    = 2'b11;


    // =========================================================
    // Internal registers
    // =========================================================

    reg [7:0] cycle_count;


    // =========================================================
    // State machine
    // =========================================================

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            state       <= STATE_IDLE;

            cycle_count <= 8'd0;

        end

        else begin

            case (state)

                // =================================================
                // IDLE
                // =================================================

                STATE_IDLE: begin

                    cycle_count <= 8'd0;

                    if (start)
                        state <= STATE_LOAD;

                end


                // =================================================
                // LOAD
                // =================================================

                STATE_LOAD: begin

                    cycle_count <= 8'd0;

                    state <= STATE_COMPUTE;

                end


                // =================================================
                // COMPUTE
                // =================================================

                STATE_COMPUTE: begin

                    if (cycle_count >= compute_cycles - 1'b1) begin

                        cycle_count <= 8'd0;

                        state <= STATE_DONE;

                    end

                    else begin

                        cycle_count <= cycle_count + 1'b1;

                    end

                end


                // =================================================
                // DONE
                // =================================================

                STATE_DONE: begin

                    state <= STATE_IDLE;

                end


                // =================================================
                // DEFAULT
                // =================================================

                default: begin

                    state <= STATE_IDLE;

                    cycle_count <= 8'd0;

                end

            endcase

        end

    end


    // =========================================================
    // Output logic
    // =========================================================

    always @(*) begin

        // -----------------------------------------------------
        // Defaults
        // -----------------------------------------------------

        busy = 1'b0;

        done = 1'b0;

        load_enable = 1'b0;

        compute_enable = 1'b0;


        case (state)

            // -------------------------------------------------
            // IDLE
            // -------------------------------------------------

            STATE_IDLE: begin

                busy = 1'b0;

            end


            // -------------------------------------------------
            // LOAD
            // -------------------------------------------------

            STATE_LOAD: begin

                busy = 1'b1;

                load_enable = 1'b1;

            end


            // -------------------------------------------------
            // COMPUTE
            // -------------------------------------------------

            STATE_COMPUTE: begin

                busy = 1'b1;

                compute_enable = 1'b1;

            end


            // -------------------------------------------------
            // DONE
            // -------------------------------------------------

            STATE_DONE: begin

                busy = 1'b0;

                done = 1'b1;

            end


            default: begin

                busy = 1'b0;

            end

        endcase

    end

endmodule