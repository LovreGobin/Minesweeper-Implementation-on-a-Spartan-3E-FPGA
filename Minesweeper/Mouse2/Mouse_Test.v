`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:55:48 08/04/2011 
// Design Name: 
// Module Name:    Mouse_Test 
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
module Mouse_Test(
		input CLK_50MHZ,
		inout PS2_CLK,
		inout PS2_DATA,
		output [7:0] LED
    );
	
	// register declarations
	wire LeftButton;
	wire RightButton;
	wire [8:0] XMovement;
	wire [8:0] YMovement;
	
	// Instantiate the module
	ps2_mouse_interface mouse (
		.clk(CLK_50MHZ), 
		.ps2_clk(PS2_CLK), 
		.ps2_data(PS2_DATA), 
		.left_button(LeftButton), 
		.right_button(RightButton), 
		.x_increment(XMovement), 
		.y_increment(YMovement)
	);

	
	assign LED[0] = RightButton;
	assign LED[1] = LeftButton;
	
	assign LED[2] = XMovement[0];
	assign LED[3] = XMovement[1];
	assign LED[4] = XMovement[2];
	
	assign LED[5] = YMovement[0];
	assign LED[6] = YMovement[1];
	assign LED[7] = YMovement[2];
	
endmodule
