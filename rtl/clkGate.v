module CLK_GATE
(
    input wire Clk,
    input wire Clk_en,
    output wire Gated_clk
);

reg latch_out;

always @(Clk or Clk_en) begin
    if (!Clk) begin
        latch_out <= Clk_en;
    end
end

assign Gated_clk = Clk && latch_out;
    
endmodule