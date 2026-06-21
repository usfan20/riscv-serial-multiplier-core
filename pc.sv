`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2025 01:34:35 PM
// Design Name: 
// Module Name: pc
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
module pc #(
    parameter addr_w = 32
)(
    input  logic clk,
    input  logic reset,pc_enable,
    input  logic [addr_w-1:0] nxt_pc,
    output logic [addr_w-1:0] pc
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        pc <= 0;
    else if(pc_enable==1'b1)
        pc <= nxt_pc;
    else
        pc <= pc;
end

endmodule
