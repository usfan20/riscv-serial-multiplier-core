`timescale 1ns / 1ps
module top_module_tb;
    logic clk;
    logic reset,branch_1;
    logic [31:0] alu_result,data1_out,data2_out,data2_reg_top,inst_val_top,data_for_rd;
    logic [31:0] pc_addr_out;
    logic [63:0] product_out;
    logic[5:0] count;
    logic finish,start,mul_enable,busy;
    logic [31:0] hi_reg,lo_reg;

    top_module uut (
        .clk(clk),
        .reset(reset),
        .alu_result(alu_result),
        .pc_addr_out(pc_addr_out),
        .data1_out(data1_out),
       .data2_out(data2_out),
      .data2_reg_top(data2_reg_top),
      .inst_val_top(inst_val_top),
        .branch_1(branch_1),
        .data_for_rd(data_for_rd),
        .product_out(product_out),
        .count(count),
        .mul_enable(mul_enable),
        .start(start),
        .finish(finish),
        .busy(busy),
        .lo_reg(lo_reg),
        .hi_reg(hi_reg)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   
    end
    
    initial begin
        
        reset  = 1;
        #20;                 
        reset  = 0;
        #10;                 
        #1200;               
        
        $finish;
    end

endmodule
