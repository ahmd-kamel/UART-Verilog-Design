module MUX 
 (
 input  wire  CLK,
 input  wire  RST,	
 input  wire  [1:0] MUX_SEL ,
 input  wire  SER_DATA ,
 input  wire  PAR_BIT,
 output reg   TX_OUT 
 );

localparam START_BIT = 1'b0,
           STOP_BIT  = 1'b1;

reg MUX_OUT;
 
always @(*) begin
    case(MUX_SEL)
        2'b00 : begin
            MUX_OUT <= START_BIT;
        end
        2'b01 : begin
            MUX_OUT <= SER_DATA;
        end
        2'b10 : begin
            MUX_OUT <= PAR_BIT;
        end
        2'b11 : begin
            MUX_OUT <= STOP_BIT;
        end
        default : begin
            MUX_OUT <= 1'b1;
        end
    endcase
end

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        TX_OUT <= 0;
    end else begin
        TX_OUT <= MUX_OUT;
    end
end

endmodule