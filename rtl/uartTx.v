module UART_TX #(parameter DATA_W = 8)
(
    input  wire Clk,
    input  wire Reset_n,
    input  wire Prty_en,
    input  wire Prty_t
    input  wire Data_vld,
    input  wire [DATA_W-1:0] P_Data,
    output wire Busy,
    output wire Tx_out
);
    
endmodule