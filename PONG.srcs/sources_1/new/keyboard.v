
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2023 06:45:05 PM
// Design Name: 
// Module Name: keyboard
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
 
 
module keyboard(
    input wire clk, reset,
    input wire ps2d, ps2c,
    output wire KEY_A, KEY_S,
    output reg key_release
);
 
// Declare variables
wire [7:0] dout;
wire rx_done_tick;
supply1 rx_en; // always HIGH
reg [7:0] key;
 
// Instantiate models
// Nexys4 converts USB to PS2, we grab that data with this module
ps2_rx ps2(clk, reset, ps2d, ps2c, 
            rx_en, rx_done_tick, dout);
 
// Sequential logic
always @(posedge clk)
begin
    if (rx_done_tick)
    begin 
        key <= dout; // key is one rx cycle behind dout
        if (key == 8'hf0) // check if the key has been released
            key_release <= 1'b1;
        else
            key_release <= 1'b0;
    end
end
 
// Output control keys of interest
assign KEY_A = (key == 8'h1C) & !key_release; // 1C is the code for 'A'
assign KEY_S = (key == 8'h1B) & !key_release; // 1F is the code for 'S'

endmodule