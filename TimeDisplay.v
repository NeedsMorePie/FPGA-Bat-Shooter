module TimeDisplayController(
	input [11:0] numSeconds,
	output reg [39:0] displayMin2, displayMin1, displaySec2, displaySec1,
	output [39:0] displayColon);

	// Each character is 5 wide and 8 tall. 
	parameter
	ONE = 40'b0010000100001000010000100001010011000100,
	TWO = 40'b1111100010001000100010000100001000101110,
	THREE = 40'b0111010001100001000001100100001000101110,
	FOUR = 40'b0100001000111110100101010010100110001000,
	FIVE = 40'b0111010001100001000001111000010001011110,
	SIX = 40'b0111010001100011000101111000011000101110,
	SEVEN = 40'b0001000010000100010000100010000100011111,
	EIGHT = 40'b0111010001100011000101110100011000101110,
	NINE = 40'b0111010001100001111010001100011000101110,
	ZERO = 40'b0111010001100011000110001100011000101110,
	COLON = 40'b0000001100011000000000000011000110000000;
	
	assign displayColon = COLON;
	
	// Minutes
	wire [5:0] numMinutes;
	assign numMinutes = numSeconds/60;
	
	wire [3:0] numMinutesFirstDigit;
	assign numMinutesFirstDigit = numMinutes%10;
	wire [3:0] numMinutesSecondDigit;
	assign numMinutesSecondDigit = (numMinutes/10)%10;
	
	// Seconds
	wire [5:0] numSecondsLeftover;
	assign numSecondsLeftover = numSeconds%60;
	
	wire [3:0] numSecondsFirstDigit;
	assign numSecondsFirstDigit = numSecondsLeftover%10;
	wire [3:0] numSecondsSecondDigit;
	assign numSecondsSecondDigit = (numSecondsLeftover/10)%10;
	
	always@(*)
	begin
		case(numMinutesFirstDigit)
			4'd0: displayMin1 = ZERO;
			4'd1: displayMin1 = ONE;
			4'd2: displayMin1 = TWO;
			4'd3: displayMin1 = THREE;
			4'd4: displayMin1 = FOUR;
			4'd5: displayMin1 = FIVE;
			4'd6: displayMin1 = SIX;
			4'd7: displayMin1 = SEVEN;
			4'd8: displayMin1 = EIGHT;
			4'd9: displayMin1 = NINE;
			default: displayMin1 = ZERO;
		endcase

		case(numMinutesSecondDigit)
			4'd0: displayMin2 = ZERO;
			4'd1: displayMin2 = ONE;
			4'd2: displayMin2 = TWO;
			4'd3: displayMin2 = THREE;
			4'd4: displayMin2 = FOUR;
			4'd5: displayMin2 = FIVE;
			4'd6: displayMin2 = SIX;
			4'd7: displayMin2 = SEVEN;
			4'd8: displayMin2 = EIGHT;
			4'd9: displayMin2 = NINE;
			default: displayMin2 = ZERO;
		endcase

		case(numSecondsFirstDigit)
			4'd0: displaySec1 = ZERO;
			4'd1: displaySec1 = ONE;
			4'd2: displaySec1 = TWO;
			4'd3: displaySec1 = THREE;
			4'd4: displaySec1 = FOUR;
			4'd5: displaySec1 = FIVE;
			4'd6: displaySec1 = SIX;
			4'd7: displaySec1 = SEVEN;
			4'd8: displaySec1 = EIGHT;
			4'd9: displaySec1 = NINE;
			default: displaySec1 = ZERO;
		endcase

		case(numSecondsSecondDigit)
			4'd0: displaySec2 = ZERO;
			4'd1: displaySec2 = ONE;
			4'd2: displaySec2 = TWO;
			4'd3: displaySec2 = THREE;
			4'd4: displaySec2 = FOUR;
			4'd5: displaySec2 = FIVE;
			4'd6: displaySec2 = SIX;
			4'd7: displaySec2 = SEVEN;
			4'd8: displaySec2 = EIGHT;
			4'd9: displaySec2 = NINE;
			default: displaySec2 = ZERO;
		endcase

	end

endmodule