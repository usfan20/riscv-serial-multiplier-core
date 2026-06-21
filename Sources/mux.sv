`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2025 09:33:39 AM
// Design Name: 
// Module Name: mux
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


module mux #(parameter n = 32)(
    input  logic[n-1:0] reg_inp,
    input  logic[n-1:0] imm_inp,
    output logic[n-1:0] mux_out,
    input  logic        signal
);
    always_comb begin 
        if (!signal)
            mux_out = reg_inp;
        else
            mux_out = imm_inp;
    end
endmodule
