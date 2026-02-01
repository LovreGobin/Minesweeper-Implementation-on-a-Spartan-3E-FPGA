`timescale 1ns / 1ps

module grid_click(
    input wire clk,
    input wire reset,
    input wire [3:0] grid_col,   // 0-9
    input wire [3:0] grid_row,   // 0-9
    input wire mouse_click,      // Lijevo dugme miša
	 input wire game_win,
	 input wire game_over,
//    output reg [7:0] led_state,  // LED[7:0]
    output reg [63:0] grid_state,// 100-bitni vektor za stanje polja
    output reg [6:0] first_click_index, // Indeks prvog kliknutog polja (0-99)
    output reg first_click_done  // Signal da je prvi klik obavljen
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
       // led_state <= 8'b0;
        grid_state <= 64'b0;
        first_click_done <= 0;
        first_click_index <= 7'b0;
    end else if (mouse_release && valid_click) begin
        // Ažuriraj grid_state i LED-ice
        grid_state[cell_index] <= 1'b1;
      //  led_state <= {1'b0, cell_index};
        
        // Ako je prvi klik, spremi indeks
        if (!first_click_done) begin
            first_click_index <= cell_index;
            first_click_done <= 1;
        end
    end
	 else if(game_over || game_win) begin
		first_click_done <= 0;
	 end
end

endmodule
