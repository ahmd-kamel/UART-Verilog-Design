/*
This pulse generator is designed to detect rising edges on the lvl_sig input and generate a one-clock-wide pulse in response.
*/
module PULSE_GEN
(
    input wire Clk,
    input wire Reset_n,
    input wire LvlSig,
    input wire PulseSig
);

reg pulse_f, rcv_f; 

always @(posedge Clk or negedge Reset_n) begin
    if(!Reset_n) begin
        rcv_f <= 1'b0;
        pulse_f <= 1'b0;
    end
    else begin
        rcv_f <= LvlSig;
        pulse_f <= rcv_f;
    end
end

assign PulseSig = rcv_f && !pulse_f;

endmodule