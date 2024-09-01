module CLK_DIV #( parameter RATIO_WD = 8 )
(
  input  wire i_ref_clk,    // Reference clock
  input  wire i_rst_n,      // Reset Signal
  input  wire i_clk_en,     // Clock divider enable
  input  wire [RATIO_WD-1 : 0]  i_div_ratio,  // Clock division ratio
  output wire o_div_clk     // Divided clock
);

wire clk_en;
reg  div_clk;
wire is_zero, is_one, is_odd;
reg  [RATIO_WD-1 : 0]  count;

// Edge flipping based on the division ratio
wire [RATIO_WD-1 : 0] edge_flip = (i_div_ratio >> 1) - 1'b1;

always @(posedge i_ref_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        count <= 0;
        div_clk <= 0;
    end else if (clk_en) begin
        if (count == edge_flip) begin
            count <= 0;
            div_clk <= ~div_clk;
            end else begin
            count <= count + 1'b1;
        end
    end
end

// Determine if the division ratio is odd, zero, or one
assign is_odd = i_div_ratio[0];
assign is_zero = ~|i_div_ratio;
assign is_one = (i_div_ratio == 1);

// Enable clock division if the divider is enabled and the ratio is not zero or one
assign clk_en = i_clk_en & !is_one & !is_zero;

// Output clock signal
assign o_div_clk = clk_en ? div_clk : i_ref_clk;

endmodule
