`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2025 08:19:14 PM
// Design Name: 
// Module Name: wb_mux
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


module wb_mux(

    input logic [31:0] alu_out,
    input logic [31:0] mem_out,
    input logic[31:0] mul_res,
    input logic [1:0] sig,
    input logic finish,
    output logic [31:0] wb_mux_out
);
logic extra ;
    always_comb begin
      extra=finish && 1;
        case(sig)

            2'b01:
            begin
             wb_mux_out = alu_out;
             extra=finish && 0;
             end      
            2'b10:
            begin 
             wb_mux_out = mem_out;  // Memory read value (if needed)
             extra=finish && 0;
            end    
            default: wb_mux_out = alu_out;
        endcase
        if(extra)
        begin 
          wb_mux_out = mul_res;
        end
    end

endmodule


