module SERIALIZER #(parameter DATA_W = 8)
(
    input  wire CLK,
    input  wire RST,
    input  wire [DATA_W-1:0] P_DATA,
    input  wire DATA_VLD,
    input  wire SER_EN,
    output wire SER_DONE,
    output reg  SER_DATA
);

reg [3:0] counter;
reg [DATA_W-1:0] REG;

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        SER_DATA <= 1'b0;
        counter <= DATA_W;
        REG <= 'b0;
    end else if ((SER_EN) && (counter != 0)) begin
        SER_DATA <= REG[counter - 1];
        counter  <= counter - 1;
    end else if (DATA_VLD) begin
        counter <= DATA_W;
        REG <= P_DATA;
    end
end

assign SER_DONE = (counter == 0 ) ? 1 : 0;
endmodule