`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2025 02:52:38 PM
// Design Name: 
// Module Name: control_logic
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


module control_logic (
input logic[6:0] opcode,fun7,
output logic branch,mem_write,mem_read,mem_to_reg,reg_write,alu_src,pc_enable,start,
output logic[1:0] alu_op,imm_src,
output logic[1:0] sig,
input logic finish,
input logic[4:0] count
    );

    always_comb begin 
    
                branch = 0;
                mem_write = 0;
                mem_read = 0;
                mem_to_reg = 0;
                reg_write = 0;
                sig = 2'b00;
                alu_src = 0;
                alu_op = 2'b00;
                imm_src=2'b00;
                pc_enable=finish;

        case(opcode)
            7'b0110011: begin   // r type 
            if(fun7==7'b0000000) begin
                branch = 0;
                mem_write = 0;
                mem_read = 0;
                mem_to_reg = 0;
                reg_write = 1;
                sig = 2'b01;
                alu_src = 0;
                pc_enable = 1;
                alu_op = 2'b10;
                imm_src=2'b00;
                end
            end
            7'b0010011: begin   // i type 
                branch = 0;
                mem_write = 0;
                mem_read = 0;
                mem_to_reg = 0;
                reg_write = 1;
                sig = 2'b01;  // ALU Result
                alu_src = 1;
                pc_enable = 1;
                alu_op = 2'b11;
                imm_src=2'b00;
            end
            7'b1100011:begin     //branch 
                branch = 1;
                mem_write = 0;
                mem_read = 0;
                mem_to_reg = 0;
                reg_write = 0;
                alu_src = 0;
                pc_enable = 1;
                sig=2'b01;
                alu_op = 2'b01;
                imm_src = 2'b10;
            end
            7'b0000011:begin     //load word   
                branch = 0;
                mem_write = 0;
                mem_read = 1;
                mem_to_reg = 1;
                reg_write = 1;
                alu_src = 1;
                pc_enable = 1;
                sig = 2'b10;
                alu_op = 2'b00;
                imm_src=2'b00;
            end
            7'b0100011:begin    //store word alu op is 00
                 branch = 0;
                mem_write = 1;
                mem_read = 0;
                mem_to_reg = 0;
                reg_write = 0;
                sig=2'b00;
                alu_src = 1;
                pc_enable = 1;
                alu_op = 2'b00;
            end
            7'b0110011: begin     // multiplication
    if(fun7==7'b0000001) begin

        sig       = 2'b11;   // select multiplier output
        alu_src   = 0;
        alu_op    = 2'b00;
        imm_src   = 2'b00;
        branch    = 0;
        mem_write = 0;
        mem_read  = 0;
        start = finish;       

        // Stall PC & RegWrite while multiplier 
       
        if(finish) begin
            pc_enable = 1;   
            reg_write = 1;   
        end else begin
            pc_enable = 0;  
            reg_write = 0;   
        end
    end
end
        endcase
        end
endmodule
