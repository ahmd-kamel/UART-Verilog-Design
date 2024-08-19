module reg_file#(parameter DATA_W = 8, ADD_W = 4)
( 
    input  wire Clk,
    input  wire RdEn,
    input  wire WrEn,
    input  wire RST_n,
    input  wire [ADD_W - 1 : 0] Address,
    input  wire [DATA_W - 1 : 0] WrData,
    output wire [DATA_W - 1 : 0] Reg0,
    output wire [DATA_W - 1 : 0] Reg1,
    output wire [DATA_W - 1 : 0] Reg2,
    output wire [DATA_W - 1 : 0] Reg3,
    output reg  [DATA_W - 1 : 0] RdData,
    output reg RdData_Valid
);

parameter DEPTH = 2 ** ADD_W;
reg [DATA_W - 1 : 0] reg_mem [DEPTH - 1];

integer i;

always @(posedge Clk or negedge RST_n) begin
    if(!RST_n) begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            if (i == 2) begin
                reg_mem[i] <= 'b10000001 ;
            end 
            else if (i == 3) begin
                reg_mem[i] <= 'b00100000 ;
            end
            else begin
                reg_mem[i] <= 'b0;
            end
        end
        RdData_Valid <= 1'b0;
        RdData <= 'b0;
    end
    else if (WrEn && !RdEn) begin
        reg_mem[Address] <= WrData;
    end
    else if (RdEn && !WrEn) begin
        RdData <= reg_mem[Address];
        RdData_Valid <= 1'b1;
    end
    else begin
        RdData_Valid <= 1'b0;
    end
end

assign Reg0 = reg_mem[0];
assign Reg1 = reg_mem[1];
assign Reg2 = reg_mem[2];
assign Reg3 = reg_mem[3];
    
endmodule