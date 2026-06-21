`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2025 03:09:38 PM
// Design Name: 
// Module Name: alu_control_logic
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


module alu_control_logic #(parameter alu_o = 2)(
input logic[1:0] alu_op,
input logic[2:0] fun3,
input logic thirty_bit,
output logic[3:0] alu_control
    );
    logic[5:0] sel;
    assign sel= {alu_op,thirty_bit,fun3};
    always_comb
        casez(sel)
            // load and store
            6'b00????:alu_control=4'b0010;
            // R-type and I-type
            6'b100000: alu_control = 4'b0010; // addition
            6'b101000: alu_control = 4'b0110; // subtraction
            6'b100111: alu_control = 4'b0000; // AND
            6'b100110: alu_control = 4'b0001; // OR
            6'b100001: alu_control = 4'b0101; // shift left logical
            6'b100101: alu_control = 4'b0111; // shift right logical
//          I type 
            6'b11?000: alu_control = 4'b0010; // addition
//            6'b10000: alu_control = 4'b0110; // subtraction
            6'b11?111: alu_control = 4'b0000; // AND
            6'b11?110: alu_control = 4'b0001; // OR
            6'b11?001: alu_control = 4'b0101; // shift left logical
            6'b11?101: alu_control = 4'b0111; // shift right logical
            // branch-type instruction
            6'b01?000: alu_control = 4'b1110; // branch equal
            6'b01?001: alu_control = 4'b1010;   //branch not equal
            6'b01?100: alu_control = 4'b1100;   //branch less than
            6'b01?101: alu_control = 4'b1000;   //branch greater than equal to
            6'b01?110: alu_control = 4'b1001; // BLTU 
            6'b01?111: alu_control = 4'b1011; // BGEU
            default: alu_control = 4'b0000; // default case to avoid latch inference
//            // jump operation 
//            6'b11?000: alu_control = 4'b0010;   // jump
            
        endcase
        
endmodule
