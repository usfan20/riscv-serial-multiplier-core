`timescale 1ns / 1ps
module inst_mem #(
    parameter n = 32,
    parameter addr_w = 32,
    parameter r_addr_w = 5,
    parameter depth = 19
)(
    input  logic [addr_w-1:0] addr,     // <-- addr is INPUT now
    output logic [n-1:0] val,
    output logic [r_addr_w-1:0] rs1, rs2, rs3,
    output logic [2:0] fun3,
    output logic [6:0] fun7,
    output logic [6:0] opcode
);

    logic [n-1:0] mem [0:depth-1];

    initial begin
        $readmemh("instructions.mem", mem);
    end
    // safe access: if addr out-of-range synthesize will still try mem[addr]
    assign val = mem[addr];
    assign opcode = val[6:0];
    assign rs3 = val[11:7];
    assign fun3 = val[14:12];
    assign rs1 = val[19:15];
    assign rs2 = val[24:20];
    assign fun7 = val[31:25];
endmodule
