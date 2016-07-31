module Cursor (VGA_X, VGA_Y, VGA_CLK, C1, C2, C3, oX, oY, oClicked, oThreshedR, oThreshedG);
	// INPUTS
	input [10:0] VGA_X, VGA_Y;
	input VGA_CLK;
	input [9:0] C1, C2, C3;
	
	// OUTPUTS
	output [10:0] oX, oY;
	output oClicked, oThreshedR, oThreshedG;

	// THRESHOLD PARAMETERS
	parameter [7:0] C1LOWR = 8'd15, C1HIGHR = 8'd250, C2LOWR = 8'd8, C2HIGHR = 8'd145, C3LOWR = 8'd165, C3HIGHR = 8'd248;
	parameter [7:0] C1LOWG = 8'd80, C1HIGHG = 8'd243, C2LOWG = 8'd8, C2HIGHG = 8'd120, C3LOWG = 8'd8, C3HIGHG = 8'd120;
	parameter [10:0] CLICK_RECT_RADIUS = 50;

	// AVG X AND Y
	wire [10:0] avgXR, avgYR;
	wire [10:0] avgXG, avgYG;


	// RED PROCESSOR
	ImageProcessor imProcR(
		.x(VGA_X),
		.y(VGA_Y),
		.C1(C1), .C2(C2), .C3(C3),
		.clock(VGA_CLK),
		.averageX(avgXR), .averageY(avgYR),
		.oThreshed(oThreshedR),
		.C1LOW(C1LOWR), .C1HIGH(C1HIGHR), .C2LOW(C2LOWR), .C2HIGH(C2HIGHR), .C3LOW(C3LOWR), .C3HIGH(C3HIGHR)
	);
		
	// GREEN PROCESSOR
	ImageProcessor imProcG(
		.x(VGA_X),
		.y(VGA_Y),
		.C1(C1), .C2(C2), .C3(C3),
		.clock(VGA_CLK),
		.averageX(avgXG), .averageY(avgYG),
		.oThreshed(oThreshedG),
		.C1LOW(C1LOWG), .C1HIGH(C1HIGHG), .C2LOW(C2LOWG), .C2HIGH(C2HIGHG), .C3LOW(C3LOWG), .C3HIGH(C3HIGHG)
	);

	// Checks if there may be a click
	wire clickTest;
	assign clickTest = (avgXG > avgXR - CLICK_RECT_RADIUS) && (avgXG < avgXR + CLICK_RECT_RADIUS) && (avgYG > avgYR - CLICK_RECT_RADIUS) && (avgYG < avgYR + CLICK_RECT_RADIUS);

	// Stores the last known X and Y coordinate of green 
	reg [10:0] lastXG, lastYG;
	reg clicked;
	initial clicked = 0;
	initial lastXG = 0;
	initial lastYG = 0;

	// Synced with VGA_CLK
	// Must determine if green has moved or not.
	// If it has, then we may consider a click.
	// If not, then green LED is probably inactive, and click shouldn't be considered.
	always @(posedge VGA_CLK)
	begin
		// If end of frame input
		if (VGA_X == 1 && VGA_Y == 1)
		begin
			// Update lastX and lastY for green
			lastXG <= avgXG;
			lastYG <= avgYG;
			
			// If the previous equals current (ie did not change)
			if (avgXG == lastXG && avgYG == lastYG)
				clicked <= 0; // Set to zero
			else
				clicked <= clickTest; // Check if actually clicked
		end
	end

	// Set output
	assign oClicked = clicked;
	
	// Assign outputs to be the red-LED location
	assign oX = 640 - avgXR;
	assign oY = avgYR;
		
endmodule
