module FIFO_REG_FILE 
#(parameter DATA_WIDTH = 8, ADD_WIDTH = 3)
(
    input  wire Clk,
    input  wire Reset_n,
    input  wire W_en,
    input  wire [ADD_WIDTH - 1 : 0]  R_addr,
    input  wire [ADD_WIDTH - 1 : 0]  W_addr,
    input  wire [DATA_WIDTH - 1 : 0] W_data,
    output wire [DATA_WIDTH - 1 : 0] R_data
);

wire [DATA_WIDTH - 1 : 0] memory [0 : 2 ** ADD_WIDTH - 1];

// synchronous write
always @(posedge Clk or negedge Reset_n) begin
    if (!Reset_n) begin
        for (i = 0; i < (2**ADD_WIDTH); i = i +1) begin
            memory[i] <= 'd0;
        end
    end else if (W_en) begin
        memory[W_addr] <= W_data;
    end
end

// asynchronous read
assign R_data = memory[R_addr];

endmodule