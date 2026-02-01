`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:48:31 06/13/2025 
// Design Name: 
// Module Name:    ps2_rxtx 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ps2_rxtx
(
    input wire clk, reset,
    input wire wr_ps2,
    inout wire ps2d, ps2c,
    input wire [7:0] din,
    output wire rx_done_tick, tx_done_tick,
    output wire [7:0] dout
);

// signal declaration
wire tx_idle;

// instanciranje PS/2 prijemnika (receiver)
ps2_rx ps2_rx_unit (
    .clk(clk),
    .reset(reset),
    .rx_en(tx_idle),
    .ps2d(ps2d),
    .ps2c(ps2c),
    .rx_done_tick(rx_done_tick),
    .dout(dout)
);

// instanciranje PS/2 predajnika (transmitter)
ps2_tx ps2_tx_unit (
    .clk(clk),
    .reset(reset),
    .wr_ps2(wr_ps2),
    .din(din),
    .ps2d(ps2d),
    .ps2c(ps2c),
    .tx_idle(tx_idle),
    .tx_done_tick(tx_done_tick)
);

endmodule

