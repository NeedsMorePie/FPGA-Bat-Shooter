`timescale 1ns / 1ns // `timescale time_unit/time_precision

module Shooter(CLOCK, cursorX, cursorY, clicked,
oT1Data, oT2Data, oT3Data, oT4Data, oT5Data, oT6Data, oT7Data, oT8Data, oT9Data, oT10Data,
oGameState, oNumSeconds);
	
	// Inputs
	input CLOCK;
	input clicked;
	input [9:0] cursorX, cursorY;
	
	// Outputs
	output [26:0] oT1Data;
	output [26:0] oT2Data;
	output [26:0] oT3Data;
	output [26:0] oT4Data;
	output [26:0] oT5Data;
	output [26:0] oT6Data;
	output [26:0] oT7Data;
	output [26:0] oT8Data;
	output [26:0] oT9Data;
	output [26:0] oT10Data;
	output [2:0] oGameState;
	output reg [11:0] oNumSeconds;

	// For Rate dividing
	parameter [23:0] MAXTIME = 24'd19240;
	
	parameter START_S = 3'b000, PLAY_S = 3'b001, END_S = 3'b010, LOSE_S = 3'b011;
	reg [2:0] currentState, nextState;
	initial currentState = START_S;
	assign oGameState = currentState;
	
	//------------------------------------------------
	// TARGET INSTANTIATIONS
	//------------------------------------------------
	
	// For reference
	parameter DEAD_S = 3'b000, DYING_S = 3'b001, ALIVE1_S = 3'b010, ALIVE2_S = 3'b011;
	parameter TARGET_WIDTH = 82, TARGET_HEIGHT = 40;
	
	// TARGET 1
	wire [26:0] T1Data;
	reg T1Shot;
	initial T1Shot = 0;
	reg T1Reset;
	initial T1Reset = 0;
	Target T1(
		.CLOCK(CLOCK),
		.shot(T1Shot),
		.isGood(1'b0),
		.targetData(T1Data[26:0]),
		.seed(13'd17),
		.reset(T1Reset));
	defparam
		T1.MAXTIME = 24'd700000,
		T1.FLAP_RATE = 24'd24;
		
	// TARGET 2
	wire [26:0] T2Data;
	reg T2Shot;
	initial T2Shot = 0;
	reg T2Reset;
	initial T2Reset = 0;
	Target T2(
		.CLOCK(CLOCK),
		.shot(T2Shot),
		.isGood(1'b0),
		.targetData(T2Data[26:0]),
		.seed(13'd19),
		.reset(T2Reset));
	defparam
		T2.MAXTIME = 24'd400000,
		T2.FLAP_RATE = 24'd26;
		
	// TARGET 3
	wire [26:0] T3Data;
	reg T3Shot;
	initial T3Shot = 0;
	reg T3Reset;
	initial T3Reset = 0;
	Target T3(
		.CLOCK(CLOCK),
		.shot(T3Shot),
		.isGood(1'b0),
		.targetData(T3Data[26:0]),
		.seed(13'd27),
		.reset(T3Reset));
	defparam
		T3.MAXTIME = 24'd500000,
		T3.FLAP_RATE = 24'd24;
		
	// TARGET 4
	wire [26:0] T4Data;
	reg T4Shot;
	initial T4Shot = 0;
	reg T4Reset;
	initial T4Reset = 0;
	Target T4(
		.CLOCK(CLOCK),
		.shot(T4Shot),
		.isGood(1'b0),
		.targetData(T4Data[26:0]),
		.seed(13'd7),
		.reset(T4Reset));
	defparam
		T4.MAXTIME = 24'd600000,
		T4.FLAP_RATE = 24'd20;
		
	// TARGET 5
	wire [26:0] T5Data;
	reg T5Shot;
	initial T5Shot = 0;
	reg T5Reset;
	initial T5Reset = 0;
	Target T5(
		.CLOCK(CLOCK),
		.shot(T5Shot),
		.isGood(1'b1), // ISGOOD
		.targetData(T5Data[26:0]),
		.seed(13'd13),
		.reset(T5Reset));
	defparam
		T5.MAXTIME = 24'd650000,
		T5.FLAP_RATE = 24'd14;
		
	// TARGET 6
	wire [26:0] T6Data;
	reg T6Shot;
	initial T6Shot = 0;
	reg T6Reset;
	initial T6Reset = 0;
	Target T6(
		.CLOCK(CLOCK),
		.shot(T6Shot),
		.isGood(1'b0), 
		.targetData(T6Data[26:0]),
		.seed(13'd237),
		.reset(T6Reset));
	defparam
		T6.MAXTIME = 24'd420000,
		T6.FLAP_RATE = 24'd20;
	
	// TARGET 7	
	wire [26:0] T7Data;
	reg T7Shot;
	initial T7Shot = 0;
	reg T7Reset;
	initial T7Reset = 0;
	Target T7(
		.CLOCK(CLOCK),
		.shot(T7Shot),
		.isGood(1'b0),
		.targetData(T7Data[26:0]),
		.seed(13'd137),
		.reset(T7Reset));
	defparam
		T7.MAXTIME = 24'd450000,
		T7.FLAP_RATE = 24'd20;
		
	// TARGET 8
	wire [26:0] T8Data;
	reg T8Shot;
	initial T8Shot = 0;
	reg T8Reset;
	initial T8Reset = 0;
	Target T8(
		.CLOCK(CLOCK),
		.shot(T8Shot),
		.isGood(1'b0),
		.targetData(T8Data[26:0]),
		.seed(13'd131),
		.reset(T8Reset));
	defparam
		T8.MAXTIME = 24'd730000,
		T8.FLAP_RATE = 24'd25;
		
	// TARGET 9
	wire [26:0] T9Data;
	reg T9Shot;
	initial T9Shot = 0;
	reg T9Reset;
	initial T9Reset = 0;
	Target T9(
		.CLOCK(CLOCK),
		.shot(T9Shot),
		.isGood(1'b0),
		.targetData(T9Data[26:0]),
		.seed(13'd511),
		.reset(T9Reset));
	defparam
		T9.MAXTIME = 24'd580000,
		T9.FLAP_RATE = 24'd21;
		
	// TARGET 10
	wire [26:0] T10Data;
	reg T10Shot;
	initial T10Shot = 0;
	reg T10Reset;
	initial T10Reset = 0;
	Target T10(
		.CLOCK(CLOCK),
		.shot(T10Shot),
		.isGood(1'b0),
		.targetData(T10Data[26:0]),
		.seed(13'd391),
		.reset(T10Reset));
	defparam
		T10.MAXTIME = 24'd462000,
		T10.FLAP_RATE = 24'd21;
		
	// Assign output data
	assign oT1Data[26:0] = T1Data[26:0];
	assign oT2Data[26:0] = T2Data[26:0];
	assign oT3Data[26:0] = T3Data[26:0];
	assign oT4Data[26:0] = T4Data[26:0];
	assign oT5Data[26:0] = T5Data[26:0];
	assign oT6Data[26:0] = T6Data[26:0];
	assign oT7Data[26:0] = T7Data[26:0];
	assign oT8Data[26:0] = T8Data[26:0];
	assign oT9Data[26:0] = T9Data[26:0];
	assign oT10Data[26:0] = T10Data[26:0];
		
	//------------------------------------------------
	// GAME LOGIC
	//------------------------------------------------

	// Counter until go back to start state
	reg [23:0] startCounter;
	initial startCounter = 0;
	
	// State Table
	always@(*)
	begin
		case(currentState)
			START_S:
			begin
				if (clicked == 1) nextState = PLAY_S;
				else nextState = START_S;
			end
			PLAY_S:
			begin
				// Check to see if the good target was killed
				if (T5Data[26:24] == DEAD_S) nextState = LOSE_S;
				// Check to see if all bad targets are dead
				else if (
					T1Data[26:24] == DEAD_S &&
					T2Data[26:24] == DEAD_S &&
					T3Data[26:24] == DEAD_S &&
					T4Data[26:24] == DEAD_S &&
					T6Data[26:24] == DEAD_S &&
					T7Data[26:24] == DEAD_S && 
					T8Data[26:24] == DEAD_S && 
					T9Data[26:24] == DEAD_S && 
					T10Data[26:24] == DEAD_S)
					// If all good targets dead
					nextState = END_S;
				// Otherwise, continue playing
				else nextState = PLAY_S;
			end
			END_S:
			begin
				if (startCounter > 6000) nextState = START_S;
				else nextState = END_S;
			end
			LOSE_S:
			begin
				if (startCounter > 6000) nextState = START_S;
				else nextState = LOSE_S;
			end
			default:
			begin
				nextState = START_S;
			end
		endcase
	end

	// Rate divided move-to-next-state
	reg [23:0] rateDivider;
	initial rateDivider = 0;
	
	// One second rate divider
	reg [25:0] secondsCounter;
	
	//------------------------------------------------
	// DATA MANIPULATOR
	//------------------------------------------------
	
	always@(posedge CLOCK)
	begin
		//////// TIME-COUNTER CODE ////////
		
		if (currentState == PLAY_S)
		begin
			// Increment every second if playing
			if (secondsCounter == 26999998)
				oNumSeconds <= oNumSeconds + 1;
		end
		else if (currentState == START_S) 
			// Set to zero at start screen
			oNumSeconds <= 0;
		else
			// Otherwise at any other state, do nothing
			oNumSeconds <= oNumSeconds;
	
		// Resets this rate divider to zero after 1 second
		if (secondsCounter >= 26999999)
			secondsCounter <= 0;
		else 
			secondsCounter <= secondsCounter + 1;
	
		//////// STATE-RELATED CODE ////////
	
		if (rateDivider == MAXTIME)
		begin
			rateDivider <= 0;
			
			// Goes to next state
			currentState <= nextState;
			
			// Once game has ended, reset all the targets
			if (currentState == LOSE_S || currentState == END_S) 
			begin
				startCounter <= startCounter + 1;
				// Reset everything
				T1Reset <= 1;
				T2Reset <= 1;
				T3Reset <= 1;
				T4Reset <= 1;
				T5Reset <= 1;
				T6Reset <= 1;
				T7Reset <= 1;
				T8Reset <= 1;
				T9Reset <= 1;
				T10Reset <= 1;
			end
			else
			begin
				// Don't reset when the game is playing
				startCounter <= 0;
				T1Reset <= 0;
				T2Reset <= 0;
				T3Reset <= 0;
				T4Reset <= 0;
				T5Reset <= 0;
				T6Reset <= 0;
				T7Reset <= 0;
				T8Reset <= 0;
				T9Reset <= 0;
				T10Reset <= 0;
			end
		end
		else
			rateDivider <= rateDivider + 1;
	end
	
	//------------------------------------------------
	// SHOOTING MECHANICS 
	//------------------------------------------------
	
	// Check if anything is shot
	// If shot, stay shot to make sure the target goes to the dying state
	reg hasShot, allowChange;
	initial hasShot = 0;
	initial allowChange = 0;
	always@(posedge CLOCK)
	begin
		if (currentState == START_S)
		begin
			// Set all shot to 0 at the start screen
			T10Shot <= 0;
			T9Shot <= 0;
			T8Shot <= 0;
			T7Shot <= 0;
			T6Shot <= 0;
			T5Shot <= 0;
			T4Shot <= 0;
			T3Shot <= 0;
			T2Shot <= 0;
			T1Shot <= 0;
		end
		else
		begin
			allowChange <= ~clicked;
			// Only change hasShot to 1 if the previous value of allowChange was 1
			if (clicked == 1 && allowChange == 1)
				hasShot <= 1;	
			// Only allows one shot
			else if (hasShot && allowChange == 0)
			begin
				hasShot <= 0;
				
				// Repeated code for each target
				
				if (clicked && currentState == PLAY_S && 
					cursorX > T10Data[20:11] && cursorX < T10Data[20:11] + TARGET_WIDTH && 
					cursorY > T10Data[10:1] && cursorY < T10Data[10:1] + TARGET_HEIGHT)
					T10Shot <= 1;
				else T10Shot <= T10Shot;
				
				if (clicked && currentState == PLAY_S && 
					cursorX > T9Data[20:11] && cursorX < T9Data[20:11] + TARGET_WIDTH && 
					cursorY > T9Data[10:1] && cursorY < T9Data[10:1] + TARGET_HEIGHT)
					T9Shot <= 1;
				else T9Shot <= T9Shot;
				
				if (clicked && currentState == PLAY_S && 
					cursorX > T8Data[20:11] && cursorX < T8Data[20:11] + TARGET_WIDTH && 
					cursorY > T8Data[10:1] && cursorY < T8Data[10:1] + TARGET_HEIGHT)
					T8Shot <= 1;
				else T8Shot <= T8Shot;
				
				if (clicked && currentState == PLAY_S && 
					cursorX > T7Data[20:11] && cursorX < T7Data[20:11] + TARGET_WIDTH && 
					cursorY > T7Data[10:1] && cursorY < T7Data[10:1] + TARGET_HEIGHT)
					T7Shot <= 1;
				else T7Shot <= T7Shot;
				
				if (clicked && currentState == PLAY_S && 
					cursorX > T6Data[20:11] && cursorX < T6Data[20:11] + TARGET_WIDTH && 
					cursorY > T6Data[10:1] && cursorY < T6Data[10:1] + TARGET_HEIGHT)
					T6Shot <= 1;
				else T6Shot <= T6Shot;
				
				if (clicked && currentState == PLAY_S && 
					cursorX > T5Data[20:11] && cursorX < T5Data[20:11] + TARGET_WIDTH && 
					cursorY > T5Data[10:1] && cursorY < T5Data[10:1] + TARGET_HEIGHT)
					T5Shot <= 1;
				else T5Shot <= T5Shot;
					
				if (clicked && currentState == PLAY_S && 
					cursorX > T4Data[20:11] && cursorX < T4Data[20:11] + TARGET_WIDTH && 
					cursorY > T4Data[10:1] && cursorY < T4Data[10:1] + TARGET_HEIGHT)
					T4Shot <= 1;
				else T4Shot <= T4Shot;
					
				if (clicked && currentState == PLAY_S && 
					cursorX > T3Data[20:11] && cursorX < T3Data[20:11] + TARGET_WIDTH && 
					cursorY > T3Data[10:1] && cursorY < T3Data[10:1] + TARGET_HEIGHT)
					T3Shot <= 1;
				else T3Shot <= T3Shot;
					
				if (clicked && currentState == PLAY_S && 
					cursorX > T2Data[20:11] && cursorX < T2Data[20:11] + TARGET_WIDTH && 
					cursorY > T2Data[10:1] && cursorY < T2Data[10:1] + TARGET_HEIGHT)
					T2Shot <= 1;
				else T2Shot <= T2Shot;
					
				if (clicked && currentState == PLAY_S && 
					cursorX > T1Data[20:11] && cursorX < T1Data[20:11] + TARGET_WIDTH && 
					cursorY > T1Data[10:1] && cursorY < T1Data[10:1] + TARGET_HEIGHT)
					T1Shot <= 1;
				else T1Shot <= T1Shot;

			end
		end
	end
	
endmodule 

module Target(CLOCK, shot, isGood, targetData, seed, reset);
	// Inputs
	input CLOCK, shot, isGood;
	input [12:0] seed;
	input reset;
	
	// For Rate dividing
	parameter [23:0] MAXTIME = 24'd1000000;//24'd19240;
	parameter [23:0] FLAP_RATE = 24'd10;
	
	// Outputs
	output [26:0] targetData;
	
	// State definitions
	parameter DOWNRIGHT_S = 3'b000, UPRIGHT_S = 3'b001, UPLEFT_S = 3'b010, DOWNLEFT_S = 3'b011;
	parameter DEAD_S = 3'b000, DYING_S = 3'b001, ALIVE1_S = 3'b010, ALIVE2_S = 3'b011;
	
	parameter XMAX = 10'd558, YMAX = 10'd400;
	
	// Directions
	reg [2:0] currentDir, nextDir;
	initial currentDir = DOWNRIGHT_S;
	
	// States
	reg [2:0] currentState, nextState;
	initial currentState = ALIVE1_S;
	
	// Position
	reg [9:0] X, Y;
	initial X = 0;
	initial Y = 0;
	
	// Assign encoded outputs
	assign targetData[0] = isGood;
	assign targetData[10:1] = Y[9:0];
	assign targetData[20:11] = X[9:0];
	assign targetData[23:21] = currentDir[2:0];
	assign targetData[26:24] = currentState[2:0];
	
	//------------------------------------------------
	// RANDOM NUMBERS 
	//------------------------------------------------
	
	wire [12:0] randomNumber1, randomNumber2;
	wire [2:0] randomNextDirection;
	assign randomNextDirection = randomNumber1 % 4;
	wire [3:0] randomDirectionChange;
	assign randomDirectionChange = randomNumber2 % 53;
	
	LFSR randomGenerator1(
		.seed(seed),
		.out(randomNumber1[12:0]),
		.enable(1'b1),
		.clk(CLOCK),
		.reset(1'b0));
		
	LFSR randomGenerator2(
		.seed(seed/3),
		.out(randomNumber2[12:0]),
		.enable(1'b1),
		.clk(CLOCK),
		.reset(1'b0));
	
	//------------------------------------------------
	// STATE 
	//------------------------------------------------
	
	// State Table
	always@(*)
	begin
		case(currentState)
			DEAD_S:
			begin
				nextState = DEAD_S;
			end
			DYING_S:
			begin
				if (Y > 640) nextState = DEAD_S;
				else nextState = DYING_S;
			end
			ALIVE1_S:
			begin
				if (shot == 1) nextState = DYING_S;
				else nextState = ALIVE2_S;
			end
			ALIVE2_S:
			begin
				if (shot == 1) nextState = DYING_S;
				else nextState = ALIVE1_S;
			end
			default:
			begin
				nextState = ALIVE2_S;
			end
		endcase
	end
	
	// State rate divider
	reg [23:0] stateRateDivide;
	initial stateRateDivide = 0;
	reg [23:0] stateFrameCount;
	initial stateFrameCount = 0;
	always@(posedge CLOCK)
	begin
		if (reset == 1)
		begin
			currentState <= ALIVE1_S;
		end
		else // Not reset
		begin
			// Nested rate divider in rate divider
			// Counts clock ticks
			if (stateRateDivide == MAXTIME)
			begin
				stateRateDivide <= 0;
				
				// Counts frames
				if (stateFrameCount == FLAP_RATE)
				begin
					stateFrameCount <= 0;
					
					// Goes to next state once every 60 frames
					currentState <= nextState;
				end
				else
					stateFrameCount <= stateFrameCount + 1;
			end
			else
				stateRateDivide <= stateRateDivide + 1;
		end
	end
	
	//------------------------------------------------
	// DIRECTION  
	//------------------------------------------------
	
	// Direction state table
	always@(*)
	begin 
		case(currentDir)
			DOWNRIGHT_S:
			begin
				if(Y >= YMAX) nextDir = UPRIGHT_S;
				else if(X >= XMAX) nextDir = DOWNLEFT_S;
				else if (randomDirectionChange == 13) nextDir = randomNextDirection;
				else nextDir = DOWNRIGHT_S;
			end
			UPRIGHT_S:
			begin
				if(Y <= 2) nextDir = DOWNRIGHT_S;
				else if(X >= XMAX) nextDir = UPLEFT_S;
				else if (randomDirectionChange == 13) nextDir = randomNextDirection;
				else nextDir = UPRIGHT_S;
			end
			UPLEFT_S:
			begin
				if(Y <= 2) nextDir = DOWNLEFT_S;
				else if(X <= 2) nextDir = UPRIGHT_S;
				else if (randomDirectionChange == 13) nextDir = randomNextDirection;
				else nextDir = UPLEFT_S;
			end
			DOWNLEFT_S:
			begin
				if(Y >= YMAX) nextDir = UPLEFT_S;
				else if(X <= 2) nextDir = DOWNRIGHT_S;
				else if (randomDirectionChange == 13) nextDir = randomNextDirection;
				else nextDir = DOWNLEFT_S;
			end
		endcase
	end

	// State rate divider
	reg [23:0] directionRateDivide;
	initial directionRateDivide = 0;
	always@(posedge CLOCK)
	begin
		if (reset == 1)
		begin
			X <= 5;
			Y <= 5;
			currentDir <= DOWNRIGHT_S;
		end
		else // Not reset
		begin
			if (directionRateDivide == MAXTIME)
			begin
				directionRateDivide <= 0;
			
				// Goes to next direction
				currentDir <= nextDir;
				
				// Moves X and Y coordinate
				if (currentState == DEAD_S)
				begin
					// Do nothing if dead
					X <= X;
					Y <= Y;
				end
				else if (currentState == DYING_S)
				begin
					X <= X;
					Y <= Y + 4;
				end
				else
				begin
					// Actually move X and Y if not dead or dying
					case(currentDir)
						DOWNRIGHT_S:
						begin
							X <= X + 1;
							Y <= Y + 1;
						end
						UPRIGHT_S:
						begin
							X <= X + 1;
							Y <= Y - 1;
						end
						UPLEFT_S:
						begin
							X <= X - 1;
							Y <= Y - 1;
						end
						DOWNLEFT_S:
						begin
							X <= X - 1;
							Y <= Y + 1;
						end
					endcase
				end
			end
			else
				directionRateDivide <= directionRateDivide + 1;
		end
	end
	
endmodule

// Decent random number generator outputs every 13 clock ticks
module LFSR(seed, out, enable, clk, reset);
	// Output
	output reg [12:0] out;
	initial out = 0;
	
	// Inputs
	input [12:0] seed;
	input enable, clk, reset;
	
	// Shift Register reg
	reg [12:0] shiftReg;
	initial shiftReg = 13'b0;

	// Feedback logic reg
	reg linear_feedback;
	initial linear_feedback = 0;
	
	// Other reg's
	reg hasInitialized;
	initial hasInitialized = 0;
	reg [4:0] count;
	initial count = 0;

	// Always block
	always@(posedge clk)
	begin
		// active high reset
		if (reset)
		begin 
			shiftReg <= 13'b0;
		end
		else if (enable)
		begin
			// Initialize with a seed
			if (shiftReg == 13'b0 && hasInitialized == 0)
			begin
				shiftReg <= seed;
				hasInitialized <= 1;
			end
			else
			begin
				// Feedback xors bit [7] and [3]
				linear_feedback <= (shiftReg[7] ^ shiftReg[3]);
				// Does shift
				shiftReg <= {shiftReg[11:0], linear_feedback};
				// Update the output every 13 shifts
				if (count == 12)
				begin
					out <= shiftReg;
					count <= 0;
				end
				else
					count <= count + 1;
			end
		end 
	end

endmodule
