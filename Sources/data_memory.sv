`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2025 12:40:02 PM
// Design Name: 
// Module Name: data_memory
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


module data_memory #(parameter n= 32,parameter addrlen = 32,parameter width = 8)(
input logic[addrlen-1:0] d_mem_addr,
input logic[n-1:0] data2,   
input logic memR,memW,clk, // 1 enable 0 disable
input logic[2:0] fun3,
output logic[31:0] mem_out  //load word ouput
    );
    logic[width-1:0] datamem[0:addrlen-1];
    initial begin
        $readmemh("data_memory.mem",datamem);
    end
    logic [7:0] tempval;
    logic [7:0] tempval1;
    logic [7:0] tempval2;
    logic [7:0] tempval3;
    assign tempval = data2[7:0];
    assign tempval1 = data2[15:8];
    assign tempval2 = data2[23:16];
    assign tempval3 = data2[31:24];
//    logic [width-1:0] tempval3;
    always_comb begin
        if(memR)begin
            case (fun3)
                3'b000: mem_out = {{24{datamem[d_mem_addr][7]}}, datamem[d_mem_addr]};
                3'b001: mem_out = {{16{datamem[d_mem_addr+1][7]}}, datamem[d_mem_addr+1], datamem[d_mem_addr]};
                3'b010: mem_out = {datamem[d_mem_addr+3],datamem[d_mem_addr+2],datamem[d_mem_addr+1],datamem[d_mem_addr]};
                3'b100: mem_out = {{24{1'b0}},datamem[d_mem_addr]};
                3'b101: mem_out = {{16{1'b0}},datamem[d_mem_addr+1],datamem[d_mem_addr]};
                default : mem_out = 0;
            endcase
            end 
        else begin
            mem_out = 32'b0;
        end
    end
    always @ (posedge clk) begin
        if(memW)begin
            case(fun3)
                3'b000: datamem[d_mem_addr] <= tempval;
                3'b001:  begin
                datamem[d_mem_addr] <= tempval;
                datamem[d_mem_addr+1] <= tempval1;
                end
                3'b010: begin
                datamem[d_mem_addr] <= tempval;
                datamem[d_mem_addr+1] <= tempval1;
                datamem[d_mem_addr+2] <= tempval2;
                datamem[d_mem_addr+3] <= tempval3;
                end
            endcase
        end
    end
endmodule
