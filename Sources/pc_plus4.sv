`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2025 07:39:58 PM
// Design Name: 
// Module Name: pc_plus4
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


module pc_plus4 (
    input  logic [31:0] pc,
    output logic [31:0] pc4
);

    assign pc4 = pc + 32'd1;

endmodule

