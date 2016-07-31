module ImageProcessor (x, y, C1, C2, C3, clock, averageX, averageY, oThreshed, isRed,
C1LOW, C1HIGH, C2LOW, C2HIGH, C3LOW, C3HIGH);
input [10:0] x, y;
input [7:0] C1, C2, C3;
input clock;
output oThreshed;
	
// THRESH PARAMETERS
//parameter [7:0] C1LOW = 8'd15, C1HIGH = 8'd250, C2LOW = 8'd8, C2HIGH = 8'd145, C3LOW = 8'd165, C3HIGH = 8'd248;
input [7:0] C1LOW, C1HIGH, C2LOW, C2HIGH, C3LOW, C3HIGH;

// WHETHER OR NOT RED IS FOUND
output reg isRed;
initial isRed = 0;

// MAYBE USELESS
reg [10:0] numX, numY;
initial numX = 0;
initial numY = 0;

reg [17:0] sumX, sumY;
initial sumX = 0;
initial sumY = 0;

// STORES OUTPUT
output reg [10:0] averageX, averageY;
initial averageX = 0;
initial averageY = 0;	
	
// REGs FOR FINDING BLOB
reg [10:0] currHorLength;
reg [10:0] maxHorLength;
reg [10:0] bestX, bestY;
reg prevPixThreshed;
initial prevPixThreshed = 0;
initial currHorLength = 0;
initial maxHorLength = 0;

// PREVIOUS AVERAGES
reg [10:0] prevAvgX1;
reg [10:0] prevAvgY1;
reg [10:0] prevAvgX2;
reg [10:0] prevAvgY2;
reg [10:0] prevAvgX3;
reg [10:0] prevAvgY3;
reg [10:0] prevAvgX4;
reg [10:0] prevAvgY4;
reg [10:0] prevAvgX5;
reg [10:0] prevAvgY5;
initial prevAvgX1 = 0;
initial prevAvgX2 = 0;
initial prevAvgX3 = 0;
initial prevAvgX4 = 0;
initial prevAvgX5 = 0;
initial prevAvgY1 = 0;
initial prevAvgY2 = 0;
initial prevAvgY3 = 0;
initial prevAvgY4 = 0;
initial prevAvgY5 = 0;
	
wire threshed;
assign threshed = ((C1 > C1LOW && C1 < C1HIGH) && (C2 > C2LOW && C2 < C2HIGH) && (C3 > C3LOW && C3 < C3HIGH)) ? 1 : 0;
	
assign oThreshed = threshed;
	
always @(posedge clock)
begin
	if(x == 0 && y == 0 && numX != 0 && numY != 0)
		begin 
			//averageX <= sumX / numX;
			//averageY <= sumY / numY;
			
			// NEW VALUE
			prevAvgX1 <= bestX;
			prevAvgY1 <= bestY;
			
			prevAvgX2 <= prevAvgX1;
			prevAvgY2 <= prevAvgY1;
			
			prevAvgX3 <= prevAvgX2;
			prevAvgY3 <= prevAvgY2;
			
			prevAvgX4 <= prevAvgX3;
			prevAvgY4 <= prevAvgY3;
			
			prevAvgX5 <= prevAvgX4;
			prevAvgY5 <= prevAvgY4;

			averageX <= (prevAvgX1 + prevAvgX2 + prevAvgX3 + prevAvgX4 + prevAvgX5)/5;
			averageY <= (prevAvgY1 + prevAvgY2 + prevAvgY3 + prevAvgY4 + prevAvgY5)/5;
			
			numX <= 0;
			numY <= 0;
			
			sumX <= 0;
			sumY <= 0;
			
			maxHorLength <= 0;
			currHorLength <= 0;
		end
	else
		begin 
			if(threshed == 1 && y < 410)
			begin
				if (!prevPixThreshed)
					currHorLength <= 0;
				else
				begin
					currHorLength <= currHorLength + 1;
					if (currHorLength > maxHorLength)
					begin
						maxHorLength <= currHorLength;
						bestX <= x;
						bestY <= y;
					end
				end
				
				// Keeps the thresh of the previous pixel
				prevPixThreshed <= threshed;
			
				sumX <= sumX + x;
				sumY <= sumY + y;
				
				numX <= numX + 1;
				numY <= numY + 1;
			end
		end
end
		
endmodule
