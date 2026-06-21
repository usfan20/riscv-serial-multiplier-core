`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2025 09:50:29 AM
// Design Name: 
// Module Name: imem
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


module immediate (
    input  logic [31:0] instr,   
    input  logic [1:0]  imm_src, // Selector: 00=I, 01=S, 10=B, 11=J
    output logic [31:0] imm_ext  
);

    always_comb begin
        case (imm_src)

            2'b00: begin  // I-type
                imm_ext = {{20{instr[31]}}, instr[31:20]};
            end
            
            2'b01: begin // S-type
                imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end

            2'b10: begin // B-type (NO implicit shift)
                imm_ext = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8]};
            end

            2'b11: begin  // J-type (NO implicit shift)
                imm_ext = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21]};
            end

            default: imm_ext = 32'bx;
        endcase
    end

endmodule

