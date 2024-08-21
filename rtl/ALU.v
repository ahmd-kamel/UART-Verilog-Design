module ALU #(parameter DATA_W = 8, ALU_OP = 4)
(
    input  wire Clk,
    input  wire Enable,
    input  wire Reset_n,
    input  wire [ALU_OP - 1 : 0] AluFun,
    input  wire [DATA_W - 1 : 0] OpA,
    input  wire [DATA_W - 1 : 0] OpB,
    output reg  [2 * DATA_W - 1 : 0] AluOut,
    output reg  OutValid
);

parameter ADD  = 'b0000;
parameter SUB  = 'b0001;
parameter MUL  = 'b0010;
parameter DIV  = 'b0011;
parameter AND  = 'b0100;
parameter OR   = 'b0101;
parameter NAND = 'b0110;
parameter NOR  = 'b0111;
parameter XOR  = 'b1000;
parameter XNOR = 'b1001;
parameter CMPE = 'b1010;
parameter CMPG = 'b1011;
parameter SFTR = 'b1100;
parameter SFTL = 'b1101;

reg  [2 * DATA_W - 1 : 0] AluOut_comb;
reg  OutValid_comb;


always @(posedge Clk or negedge Reset_n) begin
    if (!Reset_n) begin
        AluOut   <= 'b0;
        OutValid <= 1'b0;
    end else begin
        AluOut   <= AluOut_comb;
        OutValid <= OutValid_comb;
    end
end

always @(*) begin

    AluOut_comb   = 'b0;
    OutValid_comb = 1'b0;

    if (Enable) begin

        OutValid_comb = 1'b1;
        case (AluFun)
            ADD  : begin
                AluOut_comb = OpA + OpB;
            end
            SUB  : begin
                AluOut_comb = OpA - OpB;
            end
            MUL  : begin
                AluOut_comb = OpA * OpB;
            end
            DIV  : begin
                AluOut_comb = OpA / OpB;
            end
            AND  : begin
                AluOut_comb = OpA & OpB;
            end
            OR   : begin
                AluOut_comb = OpA | OpB;
            end
            NAND : begin
                AluOut_comb = ~(OpA & OpB);
            end
            NOR  : begin
                AluOut_comb = ~(OpA | OpB);
            end
            XOR  : begin
                AluOut_comb = OpA ^ OpB;
            end
            XNOR : begin
                AluOut_comb = ~(OpA ^ OpB);
            end
            CMPE : begin
                if (OpA == OpB) begin
                    AluOut_comb = 'b1;
                end else begin
                    AluOut_comb = 'b0;
                end
            end
            CMPG : begin
                if (OpA > OpB) begin
                    AluOut_comb = 'b1;
                end else begin
                    AluOut_comb = 'b0;
                end
            end
            SFTR : begin
                AluOut_comb = OpA >> 1;
            end
            SFTL : begin
                AluOut_comb = OpA << 1;
            end
            default : begin
                AluOut_comb = 'b0;
            end
        endcase
    end else begin
        OutValid_comb = 1'b0;
    end
end
    
endmodule