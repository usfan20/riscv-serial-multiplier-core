`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 06:33:40 PM
// Design Name: 
// Module Name: pc_plus_immediate
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


module pc_plus_immediate(
    input  logic [31:0] pc,
    input  logic [31:0] imme,
    output logic [31:0] pc_imm
);

assign pc_imm = pc + (imme << 1);

endmodule

