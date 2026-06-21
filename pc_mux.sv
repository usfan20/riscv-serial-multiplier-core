`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 07:09:30 PM
// Design Name: 
// Module Name: pc_mux
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


module pc_mux(
    input  logic [31:0] pc_plus4,
    input  logic [31:0] pc_imm,
    input  logic branch,
    input  logic zero_flag,
    output logic [31:0] nxt_pc
);

always_comb begin
    if(branch && zero_flag)begin
        nxt_pc = pc_imm;
    end
    else begin
        nxt_pc = pc_plus4;
    end
end

endmodule

