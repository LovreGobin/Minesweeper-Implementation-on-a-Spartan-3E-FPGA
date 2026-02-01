`timescale 1ns / 1ps

module grid_sprite(
	 input wire [3:0] digit,     // Broj (0-9)
    input wire [2:0] row,       // Redak u fontu (0-7)
    output reg [7:0] bitmap     // Bitmapa za redak
    );

always @*
    case({digit, row})
        // Broj 1
        7'h10: bitmap = 8'b00011000; // Row 0
        7'h11: bitmap = 8'b00111000; // Row 1
        7'h12: bitmap = 8'b00011000; // Row 2
        7'h13: bitmap = 8'b00011000; // Row 3
        7'h14: bitmap = 8'b00011000; // Row 4
        7'h15: bitmap = 8'b00011000; // Row 5
        7'h16: bitmap = 8'b01111110; // Row 6
        7'h17: bitmap = 8'b00000000; // Row 7
        

        default: bitmap = 8'h00;
    endcase

endmodule
