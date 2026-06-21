`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Top-level RISC-V processor with JALR support
//////////////////////////////////////////////////////////////////////////////////

module top_module #(
    parameter w = 32,
    parameter r_addr_w = 5,
    parameter addr_w = 32,
    parameter addrlen = 32,
    parameter width = 8
)(
    input  logic clk, 
    input  logic reset,
    output logic [w-1:0] alu_result,
    output logic [w-1:0] data1_out,
    output logic [w-1:0] data2_out,
    output logic [w-1:0] imm_out_top,
    output logic [w-1:0] data2_reg_top,
    output logic [w-1:0] inst_val_top,
    output logic [w-1:0] data_for_rd,
    output logic [addr_w-1:0] pc_addr_out,
    output logic [31:0] imm_inp_top,
    output alu_src_top,
    output logic branch_1,
    output logic[63:0] product_out,
    output logic[5:0] count,
    output logic mul_enable,busy,start,finish,
    output logic[31:0] hi_reg,lo_reg
);

    // Internal signals
    logic [31:0] pc, pc4, nxt_pc,pc_imm;
    logic [r_addr_w-1:0] rs1, rs2, rs3;
    logic [w-1:0] data1, data2, data2_m_i, dataW;
    logic [w-1:0] inst_val;
    logic [w-1:0] imms_val;
    logic [2:0] fun3;
    logic [6:0] fun7, opcode;
    logic ALUsrc, zero_flag;
    logic branch, mem_write, mem_read, mem_to_reg, reg_write;
    logic [1:0] alu_op,imm_src;
    logic [3:0] alu_control;
    logic [31:0] mem_out;
    logic [31:0] wb_mux_out;   
    logic [1:0] sig; 
    logic [63:0] product; 
    logic rst_n,pc_enable;
    logic[31:0] mul_res;
   

    // PC
    pc u_pc (
        .clk(clk),
        .reset(reset),
        .nxt_pc(nxt_pc),
        .pc(pc),
        .pc_enable(pc_enable)
    );

    // PC + 4
    pc_plus4 u_pc_plus4 (
        .pc(pc),
        .pc4(pc4)
    );
    pc_plus_immediate u_pc_plus_immediate(
    .pc(pc),
    .imme(imms_val),
    .pc_imm(pc_imm)
    );

    // Instruction memory
    inst_mem #(.n(w), .r_addr_w(r_addr_w), .addr_w(addr_w)) u_inst_mem (
        .addr(pc),
        .val(inst_val),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rs3(rs3),
        .fun3(fun3),
        .fun7(fun7)
    );

    // Register file
    reg_file #(.n(w), .r_addr_w(r_addr_w)) u_reg_file (
        .clk(clk),
        .RegWEn(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rs3(rs3),
        .data1(data1),
        .data2_m_i(data2_m_i),
        .dataW(wb_mux_out)
    );

    // Immediate generator
    immediate u_immediate (
       .instr(inst_val),
       .imm_src(imm_src),
       .imm_ext(imms_val)
       
    );

    // Control logic
    control_logic  ctrl (
    .opcode(opcode),
    .finish(finish),
    .branch(branch),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .mem_to_reg(mem_to_reg),
    .reg_write(reg_write),
    .alu_src(ALUsrc),
    .pc_enable(pc_enable),
    .alu_op(alu_op),
    .imm_src(imm_src),
    .sig(sig),
    .count(count)
);

    // ALU control
    alu_control_logic u_alu_control_logic (
        .alu_op(alu_op),
        .fun3(fun3),
        .thirty_bit(fun7[5]),
        .alu_control(alu_control)
    );

    // ALU second operand mux
    mux u_mux (
        .reg_inp(data2_m_i),
        .imm_inp(imms_val),
        .mux_out(data2),
        .signal(ALUsrc)
    );

    // ALU
    alu #(.n(w)) u_alu (
        .data1(data1),
        .data2(data2),
        .alu_control(alu_control),
        .dataW(dataW),
        .zero_flag(zero_flag)
    );

    // Data memory
    data_memory #(.n(w), .addrlen(addrlen), .width(width)) u_data_memory (
        .clk(clk),
        .d_mem_addr(dataW),
        .data2(data2_m_i),
        .memR(mem_read),
        .memW(mem_write),
        .fun3(fun3),
        .mem_out(mem_out)
    );
    // Writeback mux
    wb_mux u_wb_mux (
        .alu_out(dataW),
        .mem_out(mem_out),
        .sig(sig),
        .finish(finish),
        .wb_mux_out(wb_mux_out),
        .mul_res(mul_res)
    );

    // PC mux for branch (nxt_pc selection)
    pc_mux u_pc_mux (
        .pc_plus4(pc4),
        .pc_imm(pc_imm),  // ALU result with immediate for branch/jump
        .branch(branch),
        .zero_flag(zero_flag),
        .nxt_pc(nxt_pc)
       
    );
    multiplier_module mul_unit (
    .clk(clk),
    .start(start),              
    .multiplicand(data1),
    .multiplier(data2),
    .product(product),
    .finish(finish),
    .mul_enable(mul_enable),
    .count(count),
    .busy(busy),
    .hi_reg(hi_reg),
    .lo_reg(mul_res)
   
    
);
multiplier_control uut_multiplier_control(
    .opcode(opcode),
    .fun3(fun3),
    .fun7(fun7),
    .mul_enable(mul_enable),
    .start(start),
    .busy(busy)
   
);

    // Outputs
    assign alu_result = dataW;
    assign data1_out = data1;
    assign data2_out = data2;
    assign imm_out_top = imms_val;
    assign data2_reg_top = data2_m_i;
    assign inst_val_top = inst_val;
    assign data_for_rd =wb_mux_out;
    assign pc_addr_out = pc;
    assign imm_inp_top = imms_val;
    assign alu_src_top = ALUsrc;
    assign branch_1 = branch;
    assign product_out = product;
    assign lo_reg=mul_res;

endmodule


