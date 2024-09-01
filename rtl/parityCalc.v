module PARTY_CALC #(parameter DATA_W = 8)
(
    input wire CLK,
    input wire RST,
    input wire [DATA_W-1:0] P_DATA,
    input wire DATA_VLD,
    input wire PAR_TYP,
    input wire PAR_FLAG,
    output reg PAR_BIT
);

localparam EVEN_PAR = 1'b0, ODD_PAR = 1'b1;

reg [DATA_W-1:0] REG;

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        PAR_BIT <= 0;
        REG <= 'b0;
    end else if ((PAR_TYP == EVEN_PAR) && (PAR_FLAG)) begin
        PAR_BIT <= ^REG;
    end else if ((PAR_TYP == ODD_PAR) && (PAR_FLAG)) begin
        PAR_BIT <= ~^REG;
    end else if (DATA_VLD) begin
        REG <= P_DATA;
    end
end

endmodule