/*
 Reset synchronizers are used to safely transition an asynchronous reset signal into a clocked domain.
 This is crucial in digital design to avoid metastability issues, which can occur when an asynchronous signal (like a reset) is sampled by a clocked circuit.
*/

module RST_SYNC #(parameter NUM_STAGES = 2)
(
    input  wire Reset_n,
    input  wire Clk,
    output wire Sync_rst
);

// Internal register for synchronization
reg [NUM_STAGES-1:0] sync_reg;

// Double flop synchronizer
always @(posedge Clk or negedge Reset_n) begin
    if (!Reset_n)
        sync_reg <= 'b0;
    else
        sync_reg <= {sync_reg[NUM_STAGES-2:0], 1'b1};
end

// Output assignment
assign Sync_rst = sync_reg[NUM_STAGES-1];

endmodule
