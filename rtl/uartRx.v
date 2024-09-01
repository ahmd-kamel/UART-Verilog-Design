module UART_RX #(parameter DATA_W = 8, SCALE_W = 6)
(
    input  wire Clk,
    input  wire Reset_n,
    input  wire Rx_in,
    input  wire Prty_en,
    input  wire Prty_t
    input  wire [SCALE_W-1:0] Prescale,
    output wire Data_vld,
    output wire Prty_err,
    output wire Stp_err,
    output wire [DATA_W-1:0] P_Data
);
    
endmodule