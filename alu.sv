`timescale 1ns / 1ps
module alu #(
    parameter n = 32
)(
    input  logic [n-1:0] data1,
    input  logic [n-1:0] data2,
    input  logic [3:0]   alu_control,
    output logic [n-1:0] dataW,
    output logic zero_flag
);

    always_comb begin
        unique case (alu_control)
            4'b0010: dataW <= data1 + data2;
            4'b0110: dataW <= data1 - data2;
            4'b0000: dataW <= data1 & data2;
            4'b0001: dataW <= data1 | data2;
            4'b0011: dataW <= data1 ^ data2;
            4'b0100: dataW <= ($signed(data1) < $signed(data2)) ? 1 : 0;
            4'b0101: dataW <= data1 << data2[4:0];
            4'b0111: dataW <= data1 >> data2[4:0];
            4'b1110: zero_flag <= (data1 == data2);// beq
            4'b1010: zero_flag <= (data1 != data2); // bneq         
            4'b1100: zero_flag <= ($signed(data1) <= $signed(data2)); // blt signed     
            4'b1000: zero_flag <= ($signed(data1) >= $signed(data2));// bge signed
            4'b1001: zero_flag <= (data1 <= data2);//blt unsigned
            4'b1011: zero_flag <= (data1 >= data2);//bge unsigned
            default: dataW <= '0;
        endcase
    end

endmodule
