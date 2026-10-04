`timescale 1ns/1ps

// Five-stage RISC-V pipeline.
// Data memory is assumed to provide combinational read data while dmem_re is high.
module riscv_pipeline (
    input         clk,
    input         rst,
    output [31:0] imem_addr,
    input  [31:0] imem_rdata,
    output        dmem_we,
    output        dmem_re,
    output [31:0] dmem_addr,
    output [31:0] dmem_wdata,
    input  [31:0] dmem_rdata
);

    reg [31:0] pc;
    assign imem_addr = pc;

    // IF/ID
    reg [31:0] ifid_pc;
    reg [31:0] ifid_instruction;
    reg        ifid_valid;

    // Decode
    wire [4:0]  dec_rs1, dec_rs2, dec_rd;
    wire        dec_reg_write, dec_mem_read, dec_mem_write;
    wire        dec_alu_src, dec_branch, dec_branch_ne, dec_jump, dec_ai_enable;
    wire [3:0]  dec_alu_control;
    wire [31:0] dec_immediate;

    riscv_decoder DECODER (
        .instruction(ifid_instruction),
        .rs1(dec_rs1), .rs2(dec_rs2), .rd(dec_rd),
        .reg_write(dec_reg_write),
        .mem_read(dec_mem_read), .mem_write(dec_mem_write),
        .alu_src(dec_alu_src),
        .branch(dec_branch), .branch_ne(dec_branch_ne), .jump(dec_jump),
        .ai_enable(dec_ai_enable), .alu_control(dec_alu_control),
        .immediate(dec_immediate)
    );

    // MEM/WB (declared here because it supplies regfile writeback).
    reg [31:0] memwb_result;
    reg [4:0]  memwb_rd;
    reg        memwb_reg_write;
    reg        memwb_valid;

    wire        wb_reg_write = memwb_valid && memwb_reg_write;
    wire [4:0]  wb_rd        = memwb_rd;
    wire [31:0] wb_data      = memwb_result;
    wire [31:0] reg_rs1_data, reg_rs2_data;

    riscv_regfile REGFILE (
        .clk(clk), .rst(rst),
        .rs1_addr(dec_rs1), .rs2_addr(dec_rs2),
        .rs1_data(reg_rs1_data), .rs2_data(reg_rs2_data),
        .rd_we(wb_reg_write), .rd_addr(wb_rd), .rd_data(wb_data)
    );

    // ID/EX
    reg [31:0] idex_pc, idex_rs1_value, idex_rs2_value, idex_immediate;
    reg [4:0]  idex_rs1, idex_rs2, idex_rd;
    reg        idex_reg_write, idex_mem_read, idex_mem_write, idex_alu_src;
    reg        idex_branch, idex_branch_ne, idex_jump, idex_ai_enable;
    reg [3:0]  idex_alu_control;
    reg        idex_valid;

    // EX/MEM
    reg [31:0] exmem_result, exmem_store_data;
    reg [4:0]  exmem_rd;
    reg        exmem_reg_write, exmem_mem_read, exmem_mem_write, exmem_valid;

    // One-cycle load/use interlock.  A bubble is injected into ID/EX while PC
    // and IF/ID retain the dependent instruction.
    wire pc_write, ifid_write, idex_flush;
    riscv_hazard HAZARD (
        .id_rs1(dec_rs1), .id_rs2(dec_rs2),
        .idex_rd(idex_rd), .idex_memread(idex_mem_read && idex_valid),
        .pc_write(pc_write), .ifid_write(ifid_write), .idex_flush(idex_flush)
    );

    // Standard EX operand forwarding.  The MEM stage result is the selected
    // writeback value, so this works for both ALU/AI operations and loads.
    wire [1:0] forward_a, forward_b;
    riscv_forwarding FORWARDING (
        .idex_rs1(idex_rs1), .idex_rs2(idex_rs2),
        .exmem_rd(exmem_rd), .exmem_regwrite(exmem_reg_write && exmem_valid),
        .memwb_rd(memwb_rd), .memwb_regwrite(memwb_reg_write && memwb_valid),
        .forward_a(forward_a), .forward_b(forward_b)
    );

    reg [31:0] ex_operand_a, ex_operand_b;
    always @(*) begin
        case (forward_a)
            2'b10: ex_operand_a = exmem_result;
            2'b01: ex_operand_a = memwb_result;
            default: ex_operand_a = idex_rs1_value;
        endcase
        case (forward_b)
            2'b10: ex_operand_b = exmem_result;
            2'b01: ex_operand_b = memwb_result;
            default: ex_operand_b = idex_rs2_value;
        endcase
    end

    wire [31:0] alu_input_b = idex_alu_src ? idex_immediate : ex_operand_b;
    wire [31:0] alu_result;
    wire        alu_zero, alu_less_than;
    riscv_alu ALU (
        .operand_a(ex_operand_a), .operand_b(alu_input_b),
        .alu_control(idex_alu_control), .result(alu_result),
        .zero(alu_zero), .less_than(alu_less_than)
    );

    wire [31:0] ai_result;
    ai_dot4 AI_DOT4 (.a(ex_operand_a), .b(ex_operand_b), .result(ai_result));

    // JAL writes its link value, PC+4.  All other custom AI and ALU results
    // use the normal EX/MEM path and therefore receive normal forwarding.
    wire [31:0] ex_result = idex_jump ? (idex_pc + 32'd4) :
                          (idex_ai_enable ? ai_result : alu_result);

    wire branch_taken;
    wire [31:0] branch_target;
    riscv_branch_unit BRANCH_UNIT (
        .pc(idex_pc), .rs1_value(ex_operand_a), .rs2_value(ex_operand_b),
        .branch(idex_branch), .branch_ne(idex_branch_ne), .jump(idex_jump),
        .immediate(idex_immediate), .branch_taken(branch_taken),
        .target_address(branch_target)
    );
    wire control_transfer = idex_valid && branch_taken;

    // Data memory interface: address, store data and enables are all held in
    // EX/MEM for the entire memory-stage cycle.
    assign dmem_we    = exmem_valid && exmem_mem_write;
    assign dmem_re    = exmem_valid && exmem_mem_read;
    assign dmem_addr  = exmem_result;
    assign dmem_wdata = exmem_store_data;

    // Decode-side WB bypass.  It removes any dependence on the regfile's
    // write/read edge ordering, including an instruction two cycles after a
    // producer and AI/JAL writeback results.
    wire [31:0] dec_rs1_value = (wb_reg_write && (wb_rd != 5'd0) &&
                                 (wb_rd == dec_rs1)) ? wb_data : reg_rs1_data;
    wire [31:0] dec_rs2_value = (wb_reg_write && (wb_rd != 5'd0) &&
                                 (wb_rd == dec_rs2)) ? wb_data : reg_rs2_data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 32'd0;
            ifid_pc <= 32'd0;
            ifid_instruction <= 32'h00000013;
            ifid_valid <= 1'b0;

            idex_pc <= 32'd0;
            idex_rs1_value <= 32'd0;
            idex_rs2_value <= 32'd0;
            idex_immediate <= 32'd0;
            idex_rs1 <= 5'd0;
            idex_rs2 <= 5'd0;
            idex_rd <= 5'd0;
            idex_reg_write <= 1'b0;
            idex_mem_read <= 1'b0;
            idex_mem_write <= 1'b0;
            idex_alu_src <= 1'b0;
            idex_branch <= 1'b0;
            idex_branch_ne <= 1'b0;
            idex_jump <= 1'b0;
            idex_ai_enable <= 1'b0;
            idex_alu_control <= 4'd0;
            idex_valid <= 1'b0;

            exmem_result <= 32'd0;
            exmem_store_data <= 32'd0;
            exmem_rd <= 5'd0;
            exmem_reg_write <= 1'b0;
            exmem_mem_read <= 1'b0;
            exmem_mem_write <= 1'b0;
            exmem_valid <= 1'b0;

            memwb_result <= 32'd0;
            memwb_rd <= 5'd0;
            memwb_reg_write <= 1'b0;
            memwb_valid <= 1'b0;
        end else begin
            // MEM -> WB: capture memory read data during the memory cycle.
            memwb_valid <= exmem_valid;
            memwb_rd <= exmem_rd;
            memwb_reg_write <= exmem_reg_write;
            memwb_result <= (exmem_valid && exmem_mem_read) ?
                            dmem_rdata : exmem_result;

            // EX -> MEM: forwarded B is also the correct SW write data.
            exmem_valid <= idex_valid;
            exmem_result <= ex_result;
            exmem_store_data <= ex_operand_b;
            exmem_rd <= idex_rd;
            exmem_reg_write <= idex_reg_write;
            exmem_mem_read <= idex_mem_read;
            exmem_mem_write <= idex_mem_write;

            // A resolved branch/jump kills the two younger instructions:
            // current IF/ID and the instruction that would enter ID/EX now.
            if (control_transfer || idex_flush) begin
                idex_valid <= 1'b0;
                idex_reg_write <= 1'b0;
                idex_mem_read <= 1'b0;
                idex_mem_write <= 1'b0;
                idex_alu_src <= 1'b0;
                idex_branch <= 1'b0;
                idex_branch_ne <= 1'b0;
                idex_jump <= 1'b0;
                idex_ai_enable <= 1'b0;
                idex_alu_control <= 4'd0;
                idex_rd <= 5'd0;
            end else begin
                idex_valid <= ifid_valid;
                idex_pc <= ifid_pc;
                idex_rs1_value <= dec_rs1_value;
                idex_rs2_value <= dec_rs2_value;
                idex_immediate <= dec_immediate;
                idex_rs1 <= dec_rs1;
                idex_rs2 <= dec_rs2;
                idex_rd <= dec_rd;
                idex_reg_write <= dec_reg_write;
                idex_mem_read <= dec_mem_read;
                idex_mem_write <= dec_mem_write;
                idex_alu_src <= dec_alu_src;
                idex_branch <= dec_branch;
                idex_branch_ne <= dec_branch_ne;
                idex_jump <= dec_jump;
                idex_ai_enable <= dec_ai_enable;
                idex_alu_control <= dec_alu_control;
            end

            if (control_transfer) begin
                pc <= branch_target;
                ifid_pc <= 32'd0;
                ifid_instruction <= 32'h00000013;
                ifid_valid <= 1'b0;
            end else begin
                if (pc_write)
                    pc <= pc + 32'd4;
                if (ifid_write) begin
                    ifid_pc <= pc;
                    ifid_instruction <= imem_rdata;
                    ifid_valid <= 1'b1;
                end
            end
        end
    end
endmodule
