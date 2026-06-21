module multiplier_module(
    input  logic        clk,
    input  logic        start,        
    input  logic [31:0] multiplicand,
    input  logic [31:0] multiplier,
    output logic [63:0] product,
    output logic        finish,
    output logic [31:0] lo_reg,hi_reg,
    output logic [5:0]  count,
    input  logic        mul_enable,
    output logic        busy
);

    logic [31:0] A;
    logic [31:0] B;
    logic        start_d;       
    logic        start_edge;    

    always_ff @(posedge clk) begin
   
        start_d    <= start;
        start_edge <= start & ~start_d;

        finish <= 1'b0;  

        if (!mul_enable) begin
            busy  <= 1'b0;
            finish<=1'b1;
           
        end
        else begin
           
            if (start_edge && !busy) begin
                busy    <= 1'b1;
                A       <= multiplicand;
                B       <= multiplier;
                product <= 64'd0;
                count   <= 6'd0;
                finish   <= 1'b0;
            end

            else if (busy) begin
                if (B[0])
                    product <= product + ( (64'b0 | A) << count );

                B     <= B >> 1;
                count <= count + 1;

                if (count == 6'd31) begin
                    busy <= 1'b0;
                    finish <= 1'b1;     
                end
            end
        end
    end

    assign lo_reg = product[31:0];
    assign hi_reg=product[63:32];


endmodule  




