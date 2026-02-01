`timescale 1ns / 1ps

module mouse
(
    input wire clk, reset,
    inout wire ps2d, ps2c,
    output wire [8:0] xm, ym,
    output wire [2:0] btnm,
    output reg m_done_tick
);

// Konstante
localparam STRM = 8'hF4; // Stream mode komanda
localparam ACK = 8'hFA;  // PS/2 ACK bajt

// Stanja FSM
localparam [2:0] 
    init1 = 3'b000,
    init2 = 3'b001,
    init3 = 3'b010,
    ack   = 3'b011,
    pack1 = 3'b100,
    pack2 = 3'b101,
    pack3 = 3'b110,
    done  = 3'b111;

// Interni signali
reg [2:0] state_reg, state_next;
wire [7:0] rx_data;
reg wr_ps2;
wire rx_done_tick, tx_done_tick;
reg [8:0] x_reg, y_reg, x_next, y_next;
reg [2:0] btn_reg, btn_next;

// Instanciranje PS/2 kontrolera
ps2_rxtx ps2_unit
(
    .clk(clk),
    .reset(reset),
    .wr_ps2(wr_ps2),
    .din(STRM),
    .dout(rx_data),
    .ps2d(ps2d),
    .ps2c(ps2c),
    .rx_done_tick(rx_done_tick),
    .tx_done_tick(tx_done_tick)
);

// Registri stanja i podataka
always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        state_reg <= init1;
        x_reg <= 0;
        y_reg <= 0;
        btn_reg <= 0;
    end
    else
    begin
        state_reg <= state_next;
        x_reg <= x_next;
        y_reg <= y_next;
        btn_reg <= btn_next;
    end
end

// FSM logika
always @*
begin
    // Podrazumevane vrednosti
    state_next = state_reg;
    wr_ps2 = 1'b0;
    m_done_tick = 1'b0;
    x_next = x_reg;
    y_next = y_reg;
    btn_next = btn_reg;

    case (state_reg)
        init1: // Pošalji F4 komandu
        begin
            wr_ps2 = 1'b1;
            state_next = init2;
        end

        init2: // Èekaj završetak slanja
            if (tx_done_tick)
                state_next = init3;

        init3: // Èekaj ACK bajt
            if (rx_done_tick)
                state_next = (rx_data == ACK) ? ack : init1;

        ack: // Èekaj poèetak stream paketa
            state_next = pack1;

        pack1: // Status bajt (dugmad + sign bitovi)
            if (rx_done_tick)
            begin
                btn_next = rx_data[2:0];       // Bitovi 0-2: left, right, middle
                x_next[8] = rx_data[4];        // Bit 4: X sign (1 = negativno)
                y_next[8] = rx_data[5];        // Bit 5: Y sign (1 = negativno)
                state_next = pack2;
            end

        pack2: // X delta vrednost
            if (rx_done_tick)
            begin
                x_next[7:0] = rx_data;         // Donjih 8 bitova X pomeraja
                state_next = pack3;
            end

        pack3: // Y delta vrednost
            if (rx_done_tick)
            begin
                y_next[7:0] = rx_data;         // Donjih 8 bitova Y pomeraja
                state_next = done;
            end

        done: // Završetak prijma
        begin
            m_done_tick = 1'b1;
            state_next = pack1; // Nastavi sa prijemom
        end
    endcase
end

// Izlazi
assign xm = x_reg;
assign ym = y_reg;
assign btnm = btn_reg;

endmodule
