module SYS_CTRL#(parameter DATA_W = 8, ADD_W = 4, ALU_F = 4)
(
    input wire CLK,
    input wire RST,
    input wire FIFO_FULL,
    input wire [2*DATA_W-1:0] ALU_OUT,
    input wire ALU_OUT_VALID,
    input wire [DATA_W-1:0] RD_DATA,
    input wire RD_DATA_VALID,
    input wire [DATA_W-1:0] RX_P_DATA,
    input wire RX_DATA_VALID,
    output reg ALU_EN,
    output reg CLK_GATE_EN,
    output reg WR_EN,
    output reg RD_EN,
    output reg [DATA_W-1:0] WR_DATA,
    output reg [ADD_W-1:0] ADDRESS,
    output reg [ALU_F-1:0] ALU_FUN,
    output reg [DATA_W-1:0] TX_P_DATA,
    output reg TX_DATA_VALID,
    output reg CLK_DIV_EN
);

// Gray code state encoding --> easy error detection and low power transition
parameter   [3:0]   IDLE           = 'b0000,
                    WRITE_ADDRESS  = 'b0001,
                    WRITE_DATA     = 'b0010,
                    READ_ADDRESS   = 'b0011,
                    READ_DATA      = 'b0100,
                    ALU_OPERAND_A  = 'b0101,
                    ALU_OPERAND_B  = 'b0110,
                    ALU_OPERATION  = 'b0111,
                    ALU_OUT_STATE  = 'b1000,
                    ALU_OUT_VLD_F  = 'b1001,
                    ALU_OUT_VLD_S  = 'b1010;


reg [ADD_W-1:0] ADDRESS_REG;
reg [2*DATA_W-1:0] ALU_OUT_REG;

reg ADDRESS_FLAG, ALU_OUT_FLAG;

reg [3:0] current_state, next_state;

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        ADDRESS_REG <= 'b0';
    end
    else if(ADDRESS_FLAG) begin
        ADDRESS_REG <= RX_P_DATA;
    end
end

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        ALU_OUT_REG <= 'b0';
    end
    else if(ALU_OUT_FLAG) begin
        ALU_OUT_REG <= ALU_OUT;
    end
end

always @(*) begin
    next_state = IDLE;
    case (current_state)
        IDLE: begin
            if (RX_DATA_VALID && RX_P_DATA == 8'hAA) begin
                next_state = WRITE_ADDRESS;
            end 
            else if (RX_DATA_VALID && RX_P_DATA == 8'hBB) begin
                next_state = READ_ADDRESS;
            end
            else if (RX_DATA_VALID && RX_P_DATA == 8'hCC) begin
                next_state = ALU_OPERAND_A;
            end 
            else if (RX_DATA_VALID && RX_P_DATA == 8'hDD) begin
                next_state = ALU_OPERATION;
            end
            else begin
                next_state = IDLE;
            end
        end

        WRITE_ADDRESS: begin
            if (RX_DATA_VALID) begin
                next_state = WRITE_DATA;
            end else begin
                next_state = WRITE_ADDRESS;
            end
        end

        WRITE_DATA: begin
            if (RX_DATA_VALID) begin
                next_state = IDLE;
            end else begin
                next_state = WRITE_DATA;
            end
        end

        READ_ADDRESS: begin
            if (RX_DATA_VALID) begin
                next_state = READ_DATA;
            end else begin
                next_state = READ_ADDRESS;
            end
        end

        READ_DATA: begin
            if (RX_DATA_VALID) begin
                next_state = IDLE;
            end else begin
                next_state = READ_DATA;
            end
        end

        ALU_OPERAND_A: begin
            if (RX_DATA_VALID) begin
                next_state = ALU_OPERAND_B;
            end else begin
                next_state = ALU_OPERAND_A;
            end
        end

        ALU_OPERAND_B: begin
            if (RX_DATA_VALID) begin
                next_state = ALU_OPERATION;
            end else begin
                next_state = ALU_OPERAND_B;
            end
        end

        ALU_OPERATION: begin
            if (RX_DATA_VALID) begin
                next_state = ALU_OUT_STATE;
            end else begin
                next_state = ALU_OPERATION;
            end
        end

        ALU_OUT_STATE: begin
            if (ALU_OUT_VALID && !FIFO_FULL) begin
                next_state = ALU_OUT_VLD_F;
            end else begin
                next_state = ALU_OUT_STATE;
            end
        end

        ALU_OUT_VLD_F: begin
            next_state = ALU_VALID_S;
        end

        ALU_OUT_VLD_S: begin
            next_state = IDLE;
        end

        default: begin
            next_state = IDLE;
        end
    endcase
end

always @(*) begin
    CLK_GATE_EN   = 0;
    CLK_DIV_EN    = 1;
    ALU_EN        = 0;
    ALU_FUN       = 0;
    WR_EN         = 0;
    RD_EN         = 0;
    ADDRESS       = 0;
    WR_DATA       = 0;
    TX_P_DATA     = 0;
    TX_DATA_VALID = 0;
    ADDRESS_FLAG  = 0;
    ALU_OUT_FLAG  = 0;
    case (current_state)
        IDLE: begin
            CLK_GATE_EN   = 0;
            CLK_DIV_EN    = 1;
            ALU_EN        = 0;
            ALU_FUN       = 0;
            WR_EN         = 0;
            RD_EN         = 0;
            ADDRESS       = 0;
            WR_DATA       = 0;
            TX_P_DATA     = 0;
            TX_DATA_VALID = 0;
            ADDRESS_FLAG  = 0;
            ALU_OUT_FLAG  = 0;
        end

        WRITE_ADDRESS: begin
            if (RX_DATA_VALID) begin
                ADDRESS_FLAG = 'b1;      
            end else begin
                ADDRESS_FLAG = 'b0;
            end
        end

        WRITE_DATA: begin
            if (RX_DATA_VALID) begin
                WR_EN = 1;
                ADDRESS = ADDRESS_REG;
                WR_DATA = RX_P_DATA;
            end else begin
                WR_EN   = 'b0;
                ADDRESS = 'b0;
                WR_DATA = 'b0;
            end
            
        end

        READ_ADDRESS: begin
            if (RX_DATA_VALID) begin
                RD_EN = 'b1;
                ADDRESS = RX_P_DATA[3:0];
            end else begin
                RD_EN   = 'b0;
                ADDRESS = 'b0;
            end
        end

        READ_DATA: begin
            if (RD_DATA_VALID) begin
                TX_P_DATA = RD_DATA;
                TX_DATA_VALID = 'b1;
            end else begin
                TX_P_DATA = 'b0;
                TX_DATA_VALID = 'b0;
            end
        end

        ALU_OPERAND_A: begin
            if (RX_DATA_VALID) begin
                WR_EN = 'b1;
                ADDRESS = 4'b0;
                WR_DATA = RX_P_DATA;
            end else begin
                WR_EN =   'b0;
                ADDRESS = 'b0;
                WR_DATA = RX_P_DATA;
            end
        end

        ALU_OPERAND_B: begin
            if (RX_DATA_VALID) begin
                WR_EN = 'b1;
                ADDRESS = 4'd1;
                WR_DATA = RX_P_DATA;
            end else begin
                WR_EN = 'b0;
                ADDRESS = 4'd1;
                WR_DATA = RX_P_DATA;
            end
        end

        ALU_OPERATION: begin
            CLK_GATE_EN = 'b1;
            if (RX_DATA_VALID) begin
                ALU_EN = 'b1;
                ALU_FUN = RX_P_DATA;
            end else begin
                ALU_EN =  'b0;
                ALU_FUN = 'b0;
            end
        end

        ALU_OUT_STATE: begin
            CLK_GATE_EN =  'b1;
            if (ALU_OUT_VALID) begin
                ALU_OUT_FLAG = 'b1;
            end else begin
                ALU_OUT_FLAG = 'b0;
            end
        end

        ALU_OUT_VLD_F: begin
            CLK_GATE_EN = 'b1;
            if (!FIFO_FULL) begin
                TX_P_DATA = ALU_OUT_REG[DATA_W-1:0];
                TX_DATA_VALID = 'b1;
            end else begin
                TX_P_DATA = 'b0';
                TX_DATA_VALID = 'b0;
            end
        end

        ALU_OUT_VLD_S: begin
            CLK_GATE_EN = 'b1;
            if (!FIFO_FULL) begin
                TX_P_DATA = ALU_OUT_REG[2*DATA_W-1:DATA_W];
                TX_DATA_VALID = 'b1;
            end else begin
                TX_P_DATA = 'b0';
                TX_DATA_VALID = 'b0;
            end
        end

        default: begin
            CLK_GATE_EN   = 0;
            CLK_DIV_EN    = 1;
            ALU_EN        = 0;
            ALU_FUN       = 0;
            WR_EN         = 0;
            RD_EN         = 0;
            ADDRESS       = 0;
            WR_DATA       = 0;
            TX_P_DATA     = 0;
            TX_DATA_VALID = 0;
            ADDRESS_FLAG  = 0;
            ALU_OUT_FLAG  = 0;
        end
    endcase
end
endmodule