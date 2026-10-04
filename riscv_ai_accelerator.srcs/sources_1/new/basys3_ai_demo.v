`timescale 1ns/1ps

// Basys 3 hardware top.
// LED0 reset held, LED1 accelerator busy, LED2 accelerator done,
// LED3 latches once the expected final result (x25 = 60) is observed.
module basys3_ai_demo (
    input  clk,
    input  btnC,
    output [3:0] led
);
    wire [31:0] imem_addr;
    reg  [31:0] imem_rdata;
    wire ai_busy, ai_done;
    wire [31:0] cpu_x25;
    reg pass_latched;

    // btnC is active-high.  It is used as an asynchronous reset for this demo.
    riscv_ai_soc_basys3 SOC (
        .clk(clk), .rst(btnC), .imem_addr(imem_addr), .imem_rdata(imem_rdata),
        .ai_busy(ai_busy), .ai_done(ai_done), .cpu_x25(cpu_x25)
    );

    reg [31:0] instruction_rom [0:159];
    integer i;
    localparam [31:0] NOP = 32'h00000013;

    function [31:0] rv_i;
        input [11:0] imm; input [4:0] rs1; input [2:0] funct3;
        input [4:0] rd; input [6:0] opcode;
        begin rv_i = {imm, rs1, funct3, rd, opcode}; end
    endfunction
    function [31:0] rv_s;
        input [11:0] imm; input [4:0] rs2; input [4:0] rs1;
        input [2:0] funct3; input [6:0] opcode;
        begin rv_s = {imm[11:5], rs2, rs1, funct3, imm[4:0], opcode}; end
    endfunction
    task put_load;
        input integer slot; input [4:0] rd; input [11:0] offset; input [4:0] base;
        begin
            instruction_rom[slot] = rv_i(offset, base, 3'b010, rd, 7'b0000011);
            instruction_rom[slot+1] = NOP;
            instruction_rom[slot+2] = NOP;
        end
    endtask
    task put_store;
        input integer slot; input [4:0] rs2; input [11:0] offset; input [4:0] base;
        begin instruction_rom[slot] = rv_s(offset, rs2, base, 3'b010, 7'b0100011); end
    endtask

    // Vivado initializes this ROM into FPGA configuration memory.
    initial begin
        for (i = 0; i < 160; i = i + 1) instruction_rom[i] = NOP;
        instruction_rom[0] = rv_i(12'd128, 5'd0, 3'b000, 5'd1, 7'b0010011);
        put_load(1, 5'd2, 12'd0, 5'd0);   put_store(4, 5'd2, 12'd0, 5'd1);
        put_load(5, 5'd2, 12'd4, 5'd0);   put_store(8, 5'd2, 12'd4, 5'd1);
        put_load(9, 5'd2, 12'd8, 5'd0);   put_store(12,5'd2, 12'd8, 5'd1);
        put_load(13,5'd2, 12'd12,5'd0);   put_store(16,5'd2, 12'd12,5'd1);
        put_load(17,5'd2, 12'd16,5'd0);   put_store(20,5'd2, 12'd16,5'd1);
        put_load(21,5'd2, 12'd20,5'd0);   put_store(24,5'd2, 12'd20,5'd1);
        put_load(25,5'd2, 12'd24,5'd0);   put_store(28,5'd2, 12'd24,5'd1);
        put_load(29,5'd2, 12'd28,5'd0);   put_store(32,5'd2, 12'd28,5'd1);
        instruction_rom[33] = rv_i(12'd1, 5'd0, 3'b000, 5'd2, 7'b0010011);
        put_store(35, 5'd2, 12'd32, 5'd1);
        // Fixed wait for the existing accelerator implementation.
        for (i = 36; i < 66; i = i + 1) instruction_rom[i] = NOP;
        put_load(66, 5'd10, 12'd40, 5'd1); put_load(69, 5'd11, 12'd44, 5'd1);
        put_load(72, 5'd12, 12'd48, 5'd1); put_load(75, 5'd13, 12'd52, 5'd1);
        put_load(78, 5'd14, 12'd56, 5'd1); put_load(81, 5'd15, 12'd60, 5'd1);
        put_load(84, 5'd16, 12'd64, 5'd1); put_load(87, 5'd17, 12'd68, 5'd1);
        put_load(90, 5'd18, 12'd72, 5'd1); put_load(93, 5'd19, 12'd76, 5'd1);
        put_load(96, 5'd20, 12'd80, 5'd1); put_load(99, 5'd21, 12'd84, 5'd1);
        put_load(102,5'd22, 12'd88, 5'd1); put_load(105,5'd23, 12'd92, 5'd1);
        put_load(108,5'd24, 12'd96, 5'd1); put_load(111,5'd25, 12'd100,5'd1);
    end

    always @(*) begin
        if (imem_addr[31:2] < 160)
            imem_rdata = instruction_rom[imem_addr[9:2]];
        else
            imem_rdata = NOP;
    end

    always @(posedge clk or posedge btnC) begin
        if (btnC)
            pass_latched <= 1'b0;
        else if (cpu_x25 == 32'd60)
            pass_latched <= 1'b1;
    end

    assign led[0] = btnC;
    assign led[1] = ai_busy;
    assign led[2] = ai_done;
    assign led[3] = pass_latched;
endmodule
