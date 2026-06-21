module multiplier_control(
    input  logic [6:0] opcode,
    input  logic [2:0] fun3,
    input  logic [6:0] fun7,
    input  logic       busy,
    output logic       mul_enable,
    output logic       start
);

    always_comb begin
        mul_enable = 0;
        start      = 0;

        if (opcode == 7'b0110011 && fun7 == 7'b0000001) begin
            mul_enable = 1;

            if (!busy) 
                start = 1; 
        end
    end

endmodule

