`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2025 05:55:44 PM
// Design Name: 
// Module Name: reg_file
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module reg_file #(
parameter n = 32,
parameter r_addr_w = 5,
parameter depth =19
)(
    input logic clk,
    input logic RegWEn,
    input logic[r_addr_w-1:0] rs1,rs2,rs3,
    output [n-1:0] data1,data2_m_i,
    input [n-1:0] dataW
    );
    logic [n-1:0] mem[0:depth-1];
    always_ff @ (posedge clk) begin
    if(RegWEn)begin
            mem[rs3] <= dataW;
            end
    end
     initial begin
        $readmemh("reg_file_mem.mem",mem);
    end
    assign data1=mem[rs1];
    assign data2_m_i=mem[rs2];
endmodule
