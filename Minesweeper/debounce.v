module debounce (
    input clk,
    input reset,
    input bouncey_input,
    output reg clean_data
);
    parameter DEBOUNCE_CYCLES = 250000; // 10ms at 25MHz
    reg [20:0] count;
    reg old_input;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            old_input <= 0;
            clean_data <= 0;
        end else begin
            // Use PREVIOUS cycle's old_input for comparison
            if (bouncey_input != old_input) 
                count <= 0;
            else if (count < DEBOUNCE_CYCLES) 
                count <= count + 1;
            else 
                clean_data <= old_input;
            
            // Update old_input LAST for next cycle
            old_input <= bouncey_input;
        end
    end
endmodule
