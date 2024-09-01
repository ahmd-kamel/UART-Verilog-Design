module DATA_SYNC #(parameter BUS_W = 8, NUM_STAGES = 2,)
(
    input  wire dest_clk,
    input  wire dest_rst,
    input  wire bus_en,
    input  wire [BUS_W-1:0] unsync_bus,
    output reg  enable_pulse,
    output reg  [BUS_W-1:0] sync_bus
);

always @(posedge dest_clk or negedge dest_rst) begin
    if (!dest_rst) begin
        
    end else begin
        
    end
end

endmodule