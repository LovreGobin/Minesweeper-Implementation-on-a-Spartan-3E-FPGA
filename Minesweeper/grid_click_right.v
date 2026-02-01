`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:34:43 06/19/2025 
// Design Name: 
// Module Name:    grid_click_right 
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
module grid_click_right(

	 input wire clk,
    input wire reset,
    input wire [3:0] grid_col,   // 0-9
    input wire [3:0] grid_row,   // 0-9
    input wire mouse_click,      // Desno dugme miša
    output reg [63:0] grid_state // 100-bitni vektor za stanje polja
    );
	 
	 

// Registri za detekciju "release" eventa
reg mouse_click_prev = 0;
wire mouse_release = mouse_click_prev && !mouse_click;

// Provjera je li klik unutar grida
wire valid_click = (grid_col < 8) && (grid_row < 8);

// Raèunanje indeksa æelije (0-99)
wire [6:0] cell_index = grid_row * 8 + grid_col;

// Ažuriranje prethodnog stanja dugmeta
always @(posedge clk) begin
    mouse_click_prev <= mouse_click;
end

// Ažuriranje grida, LED-ica i prvog klika
always @(posedge clk or posedge reset) begin
    if (reset) begin
        grid_state <= 64'b0;
    end else if (mouse_release && valid_click) begin
        // Ažuriraj grid_state i LED-ice
        grid_state[cell_index] <= 1'b1;

        
    end
end

endmodule
