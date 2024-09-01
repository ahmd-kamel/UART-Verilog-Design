module ASYC_FIFO #(parameter DATA_W = 8)
(
    input  wire W_clk,
    input  wire W_rst,
    input  wire W_inc,
    input  wire R_clk,
    input  wire R_rst,
    input  wire R_inc,
    input  wire [DATA_W-1:0] WR_data,
    output reg full,
    output reg empty,
    output reg RD_data
);


endmodule