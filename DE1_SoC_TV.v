
//`define ENABLE_HPS

module DE1_SoC_TV(

      // ADC 
      inout ADC_CS_N,
      output ADC_DIN,
      input ADC_DOUT,
      output ADC_SCLK,

      // AUD 
      input AUD_ADCDAT,
      inout AUD_ADCLRCK,
      inout AUD_BCLK,
      output AUD_DACDAT,
      inout AUD_DACLRCK,
      output AUD_XCK,

      // CLOCK2 
      input CLOCK2_50,

      // CLOCK3 
      input CLOCK3_50,

      // CLOCK4 
      input CLOCK4_50,

      // CLOCK 
      input CLOCK_50,

      // DRAM 
      output [12:0] DRAM_ADDR,
      output [1:0]  DRAM_BA,
      output DRAM_CAS_N,
      output DRAM_CKE,
      output DRAM_CLK,
      output DRAM_CS_N,
      inout [15:0] DRAM_DQ,
      output DRAM_LDQM,
      output DRAM_RAS_N,
      output DRAM_UDQM,
      output DRAM_WE_N,

      // FPGA 
      output FPGA_I2C_SCLK,
      inout FPGA_I2C_SDAT,

      // HEX 
      output [6:0] HEX0,
      output [6:0] HEX1,
      output [6:0] HEX2,
      output [6:0] HEX3,
      output [6:0] HEX4,
      output [6:0] HEX5,

      // IRDA 
      input IRDA_RXD,
      output IRDA_TXD,

      // KEY 
      input [3:0] KEY,

      // LEDR 
      output [9:0] LEDR,

      // PS2 
      inout PS2_CLK,
      inout PS2_CLK2,
      inout PS2_DAT,
      inout PS2_DAT2,

      // SW 
      input [9:0] SW,

      // TD 
      input TD_CLK27,
      input [7:0] TD_DATA,
      input TD_HS,
      output TD_RESET_N,
      input TD_VS,

      // VGA 
      output [7:0] VGA_B,
      output VGA_BLANK_N,
      output VGA_CLK,
      output [7:0] VGA_G,
      output VGA_HS,
      output [7:0] VGA_R,
      output VGA_SYNC_N,
      output VGA_VS
);

//------------------------------------------------
//  REG/WIRE declarations
//------------------------------------------------

wire CLK_18_4;
wire CLK_25;

//	For Audio CODEC
wire AUD_CTRL_CLK;	//	For Audio Controller

//	For ITU-R 656 Decoder
wire [15:0]	YCbCr;
wire [9:0]	TV_X;
wire TV_DVAL;

//	For VGA Controller
wire [9:0] mRed;
wire [9:0] mGreen;
wire [9:0]	mBlue;
wire [10:0]	VGA_X;
wire [10:0]	VGA_Y;
wire VGA_Read;	//	VGA data request
wire m1VGA_Read;	//	Read odd field
wire m2VGA_Read;	//	Read even field

//	For YUV 4:2:2 to YUV 4:4:4
wire [7:0]	mY;
wire [7:0]	mCb;
wire [7:0]	mCr;

//	For field select
wire [15:0]	mYCbCr;
wire [15:0]	mYCbCr_d;
wire [15:0]	m1YCbCr;
wire [15:0]	m2YCbCr;
wire [15:0]	m3YCbCr;

//	For Delay Timer
wire TD_Stable;
wire DLY0;
wire DLY1;
wire DLY2;

//	For Down Sample
wire [3:0]	Remain;
wire [9:0]	Quotient;

wire mDVAL;

wire [15:0]	m4YCbCr;
wire [15:0]	m5YCbCr;
wire [8:0]	Tmp1,Tmp2;
wire [7:0]	Tmp3,Tmp4;

wire NTSC;
wire PAL;

//------------------------------------------------
// Structural coding
//------------------------------------------------

//	All inout port turn to tri-state 
assign	AUD_ADCLRCK	=	AUD_DACLRCK;

//	Turn On TV Decoder
assign	TD_RESET_N	=	1'b1;

assign	AUD_XCK	=	AUD_CTRL_CLK;

assign	LED	=	VGA_Y;


assign	m1VGA_Read = VGA_Y[0] ?	1'b0 : VGA_Read;
assign	m2VGA_Read = VGA_Y[0] ?	VGA_Read : 1'b0;
assign	mYCbCr_d = !VGA_Y[0] ? m1YCbCr : m2YCbCr;
assign	mYCbCr = m5YCbCr;

assign	Tmp1 = m4YCbCr[7:0] + mYCbCr_d[7:0];
assign	Tmp2 = m4YCbCr[15:8] + mYCbCr_d[15:8];
assign	Tmp3 = Tmp1[8:2] + m3YCbCr[7:1];
assign	Tmp4 = Tmp2[8:2] + m3YCbCr[15:9];
assign	m5YCbCr	= {Tmp4, Tmp3};

//	TV Decoder Stable Check
TD_Detect u2(
	.oTD_Stable(TD_Stable),
	.oNTSC(NTSC),
	.oPAL(PAL),
	.iTD_VS(TD_VS),
	.iTD_HS(TD_HS),
	.iRST_N(KEY[0]));

//	Reset Delay Timer
Reset_Delay u3(
	.iCLK(CLOCK_50),
	.iRST(TD_Stable),
	.oRST_0(DLY0),
	.oRST_1(DLY1),
	.oRST_2(DLY2));

//	ITU-R 656 to YUV 4:2:2
ITU_656_Decoder u4(	// TV Decoder Input
	.iTD_DATA(TD_DATA),
	// Position Output
	.oTV_X(TV_X),
	// YUV 4:2:2 Output
	.oYCbCr(YCbCr),
	.oDVAL(TV_DVAL),
	// Control Signals
	.iSwap_CbCr(Quotient[0]),
	.iSkip(Remain==4'h0),
	.iRST_N(DLY1),
	.iCLK_27(TD_CLK27));

//	For Down Sample 720 to 640
DIV u5 (
	.aclr(!DLY0),	
	.clock(TD_CLK27),
	.denom(4'h9),
	.numer(TV_X),
	.quotient(Quotient),
	.remain(Remain));

//	SDRAM frame buffer
Sdram_Control_4Port	u6	(	//	HOST Side
	.REF_CLK(TD_CLK27),
	.CLK_18(AUD_CTRL_CLK),
	.RESET_N(DLY0),
	//	FIFO Write Side 1
	.WR1_DATA(YCbCr),
	.WR1(TV_DVAL),
	.WR1_FULL(WR1_FULL),
	.WR1_ADDR(0),
	.WR1_MAX_ADDR(NTSC ? 640*507 : 640*576),		//	525-18
	.WR1_LENGTH(9'h80),
	.WR1_LOAD(!DLY0),
	.WR1_CLK(TD_CLK27),
	//	FIFO Read Side 1
	.RD1_DATA(m1YCbCr),
	.RD1(m1VGA_Read),
	.RD1_ADDR(NTSC ? 640*13 : 640*22),			//	Read odd field and bypess blanking
	.RD1_MAX_ADDR(NTSC ? 640*253 : 640*262),
	.RD1_LENGTH(9'h80),
	.RD1_LOAD(!DLY0),
	.RD1_CLK(TD_CLK27),
	//	FIFO Read Side 2
	.RD2_DATA(m2YCbCr),
	.RD2(m2VGA_Read),
	.RD2_ADDR(NTSC ? 640*267 : 640*310),			//	Read even field and bypess blanking
	.RD2_MAX_ADDR(NTSC ? 640*507 : 640*550),
	.RD2_LENGTH(9'h80),
	.RD2_LOAD(!DLY0),
	.RD2_CLK(TD_CLK27),
	//	SDRAM Side
	.SA(DRAM_ADDR),
	.BA(DRAM_BA),
	.CS_N(DRAM_CS_N),
	.CKE(DRAM_CKE),
	.RAS_N(DRAM_RAS_N),
	.CAS_N(DRAM_CAS_N),
	.WE_N(DRAM_WE_N),
	.DQ(DRAM_DQ),
	.DQM({DRAM_UDQM,DRAM_LDQM}),
	.SDR_CLK(DRAM_CLK)	);

//	YUV 4:2:2 to YUV 4:4:4
YUV422_to_444 u7(	//	YUV 4:2:2 Input
	.iYCbCr(mYCbCr),
	//	YUV	4:4:4 Output
	.oY(mY),
	.oCb(mCb),
	.oCr(mCr),
	//	Control Signals
	.iX(VGA_X-160),
	.iCLK(TD_CLK27),
	.iRST_N(DLY0));

//	OLD YCbCr 8-bit to RGB-10 bit 
/*
YCbCr2RGB u8(	//	Output Side
	.Red(mRed),
	.Green(mGreen),
	.Blue(mBlue),
	.oDVAL(mDVAL),
	//	Input Side
	.iY(mY),
	.iCb(mCb),
	.iCr(mCr),
	.iDVAL(VGA_Read),
	//	Control Signal
	.iRESET(!DLY2),
	.iCLK(TD_CLK27));
	*/

YCbCr2RGB u8(	
	// Output
	.oRed(mRed),
	.oGreen(mGreen),
	.oBlue(mBlue),
	// Input
	.iY(mY),
	.iCb(mCb),
	.iCr(mCr),
	.iCLK(TD_CLK27));

//	VGA Controller
wire [9:0] vga_r10;
wire [9:0] vga_g10;
wire [9:0] vga_b10;
assign VGA_R = vga_r10[9:2];
assign VGA_G = vga_g10[9:2];
assign VGA_B = vga_b10[9:2];

wire [10:0] X, Y;
wire isClicked;
wire threshedR, threshedG;

wire [10:0] red; 
assign red = threshedR * 255;
wire [10:0] green; 
assign green = threshedG * 255;

reg [10:0] outputR, outputG, outputB;

// Gets the cursor coordinates
Cursor Cursor1(
	.VGA_X(VGA_X),
	.VGA_Y(VGA_Y),
	.VGA_CLK(VGA_CLK),
	.C1(mY),
	.C2(mCb),
	.C3(mCr),
	.oX(X),
	.oY(Y),
	.oClicked(isClicked),
	.oThreshedR(threshedR),
	.oThreshedG(threshedG));

wire [26:0] tarData1, tarData2, tarData3, tarData4, tarData5, tarData6, tarData7, tarData8, tarData9, tarData10;
wire [2:0] currentGameState;
wire [11:0] numSeconds;
	
// Gets game logic	
Shooter gameLogic(
	.CLOCK(VGA_CLK), 
	.cursorX(X), 
	.cursorY(Y), 
	.clicked(isClicked),
	.oT1Data(tarData1), 
	.oT2Data(tarData2), 
	.oT3Data(tarData3), 
	.oT4Data(tarData4), 
	.oT5Data(tarData5),
	.oT6Data(tarData6),
	.oT7Data(tarData7),
	.oT8Data(tarData8),
	.oT9Data(tarData9),
	.oT10Data(tarData10),
	.oGameState(currentGameState),
	.oNumSeconds(numSeconds));		


// Timer Display Logic
wire [39:0] displayMin2, displayMin1, displaySec2, displaySec1, displayColon;
TimeDisplayController timeController(
	.numSeconds(numSeconds),
	.displayMin2(displayMin2),
	.displayMin1(displayMin1),
	.displayColon(displayColon),
	.displaySec2(displaySec2),
	.displaySec1(displaySec1));

parameter cursorSize = 12;
parameter TARGET_WIDTH = 82, TARGET_HEIGHT = 40;
parameter START_S = 3'b000, PLAY_S = 3'b001, END_S = 3'b010, LOSE_S = 3'b011;
parameter DEAD_S = 3'b000, DYING_S = 3'b001, ALIVE1_S = 3'b010, ALIVE2_S = 3'b011;
parameter WHITE = 24'b111111111111111111111111;

parameter FRAME_SIZE = 3280;

// IMAGE DRAWING

wire [11:0] frame1Tar1Address;
wire [23:0] oFrame1Tar1;
assign frame1Tar1Address = (FRAME_SIZE/40)*(VGA_Y - tarData1[10:1]) + (VGA_X - tarData1[20:11]);

wire [11:0] frame1Tar2Address;
wire [23:0] oFrame1Tar2;
assign frame1Tar2Address = (FRAME_SIZE/40)*(VGA_Y - tarData2[10:1]) + (VGA_X - tarData2[20:11]);

wire [11:0] frame1Tar3Address;
wire [23:0] oFrame1Tar3;
assign frame1Tar3Address = (FRAME_SIZE/40)*(VGA_Y - tarData3[10:1]) + (VGA_X - tarData3[20:11]);

wire [11:0] frame1Tar4Address;
wire [23:0] oFrame1Tar4;
assign frame1Tar4Address = (FRAME_SIZE/40)*(VGA_Y - tarData4[10:1]) + (VGA_X - tarData4[20:11]);

wire [11:0] frame1Tar5Address;
wire [23:0] oFrame1Tar5;
assign frame1Tar5Address = (FRAME_SIZE/40)*(VGA_Y - tarData5[10:1]) + (VGA_X - tarData5[20:11]);

wire [11:0] frame1Tar6Address;
wire [23:0] oFrame1Tar6;
assign frame1Tar6Address = (FRAME_SIZE/40)*(VGA_Y - tarData6[10:1]) + (VGA_X - tarData6[20:11]);

wire [11:0] frame1Tar7Address;
wire [23:0] oFrame1Tar7;
assign frame1Tar7Address = (FRAME_SIZE/40)*(VGA_Y - tarData7[10:1]) + (VGA_X - tarData7[20:11]);

wire [11:0] frame1Tar8Address;
wire [23:0] oFrame1Tar8;
assign frame1Tar8Address = (FRAME_SIZE/40)*(VGA_Y - tarData8[10:1]) + (VGA_X - tarData8[20:11]);

wire [11:0] frame1Tar9Address;
wire [23:0] oFrame1Tar9;
assign frame1Tar9Address = (FRAME_SIZE/40)*(VGA_Y - tarData9[10:1]) + (VGA_X - tarData9[20:11]);

wire [11:0] frame1Tar10Address;
wire [23:0] oFrame1Tar10;
assign frame1Tar10Address = (FRAME_SIZE/40)*(VGA_Y - tarData10[10:1]) + (VGA_X - tarData10[20:11]);

multiFrameStorage frame1(.clock(VGA_CLK),
	// Address inputs
	.address1(frame1Tar1Address),
	.address2(frame1Tar2Address),
	.address3(frame1Tar3Address),
	.address4(frame1Tar4Address),
	.address5(frame1Tar5Address),
	.address6(frame1Tar6Address),
	.address7(frame1Tar7Address),
	.address8(frame1Tar8Address),
	.address9(frame1Tar9Address),
	.address10(frame1Tar10Address),
	// State inputs
	.state1(tarData1[26:24]),
	.state2(tarData2[26:24]),
	.state3(tarData3[26:24]),
	.state4(tarData4[26:24]),
	.state5(tarData5[26:24]),
	.state6(tarData6[26:24]),
	.state7(tarData7[26:24]),
	.state8(tarData8[26:24]),
	.state9(tarData9[26:24]),
	.state10(tarData10[26:24]),
	// Pixel colour outputs
	.q1(oFrame1Tar1),
	.q2(oFrame1Tar2),
	.q3(oFrame1Tar3),
	.q4(oFrame1Tar4),
	.q5(oFrame1Tar5),
	.q6(oFrame1Tar6),
	.q7(oFrame1Tar7),
	.q8(oFrame1Tar8),
	.q9(oFrame1Tar9),
	.q10(oFrame1Tar10));
defparam
	frame1.FRAME1_IMAGE = "batF1.mif",
	frame1.FRAME2_IMAGE = "batF2.mif";

// Background image
wire [16:0] backgroundAddress;
wire [11:0] oBackgroundColour;
assign backgroundAddress = (320)*(VGA_Y/2) + (VGA_X/2);
Background2 background(
	.address(backgroundAddress),
	.clock(VGA_CLK),
	.q(oBackgroundColour));

//title screen image
parameter [8:0] startX = 256, endX = 385, startY = 164, endY = 196;
wire [16:0] titleAddress;
wire [11:0] oTitleColour;
assign titleAddress = ((VGA_Y-startY)*64/2+(VGA_X-startX)/2);
TScreen title(
	.address(titleAddress),
	.clock(VGA_CLK),
	.q(oTitleColour));
	
// Reticle image
wire [9:0] reticleAddress;
wire [23:0] oReticleColour;
assign reticleAddress = (25)*(VGA_Y - Y + 12) + (VGA_X - X + 12);
Reticle reticle(
	.address(reticleAddress),
	.clock(VGA_CLK),
	.q(oReticleColour));
	
// DRAWING
always@ (posedge VGA_CLK)
begin
	if(VGA_X > X - cursorSize && VGA_X <= X + cursorSize + 1 && VGA_Y >= Y - cursorSize && VGA_Y <= Y + cursorSize
		&& oReticleColour != WHITE)
		begin
			outputR <= isClicked ? 255 : 255;
			outputG <= isClicked ? 0 : 255;
			outputB <= isClicked ? 0 : 255;
		end
	else if(SW[1] == 1) //debugging mode, SW[0] = 1 for thresher, SW[0] = 0 for camera view
		begin
			outputR <= (SW[0] == 1 ? mRed : red);
			outputG <= (SW[0] == 1 ? mGreen : green);
			outputB <= (SW[0] == 1 ? mBlue : 0); 
		end
	// Start Screen
	else if (currentGameState == START_S)
		begin
			if(VGA_X > startX && VGA_X < endX && VGA_Y > startY && VGA_Y < endY && oTitleColour[0] == 1)
				begin
					outputR <= 255;//oTitleColour[11:8];
					outputG <= 255;//oTitleColour[7:4];
					outputB <= 255;//oTitleColour[3:0];
				end
			else
				begin
					outputR <= 0;
					outputG <= 0;
					outputB <= 0;
				end
			
		end
	// Draw first digit of seconds
	else if (VGA_X >= 623 && VGA_Y >= 450 && VGA_X < 623 + 15 && VGA_Y < 450 + 24
		&& displaySec1[5*((VGA_Y-450)/3) + (VGA_X-623)/3] == 1)
		begin
			outputR <= displaySec1[5*((VGA_Y-450)/3) + (VGA_X-623)/3] * 255;
			outputG <= displaySec1[5*((VGA_Y-450)/3) + (VGA_X-623)/3] * 255;
			outputB <= displaySec1[5*((VGA_Y-450)/3) + (VGA_X-623)/3] * 255;
		end
	// Draw second digit of seconds
	else if (VGA_X >= 606 && VGA_Y >= 450 && VGA_X < 606 + 15 && VGA_Y < 450 + 24
		&& displaySec2[5*((VGA_Y-450)/3) + (VGA_X-606)/3] == 1)
		begin
			outputR <= displaySec2[5*((VGA_Y-450)/3) + (VGA_X-606)/3] * 255;
			outputG <= displaySec2[5*((VGA_Y-450)/3) + (VGA_X-606)/3] * 255;
			outputB <= displaySec2[5*((VGA_Y-450)/3) + (VGA_X-606)/3] * 255;
		end
	// Draw colon
	else if (VGA_X >= 589 && VGA_Y >= 450 && VGA_X < 589 + 15 && VGA_Y < 450 + 24
		&& displayColon[5*((VGA_Y-450)/3) + (VGA_X-589)/3] == 1)
		begin
			outputR <= displayColon[5*((VGA_Y-450)/3) + (VGA_X-589)/3] * 255;
			outputG <= displayColon[5*((VGA_Y-450)/3) + (VGA_X-589)/3] * 255;
			outputB <= displayColon[5*((VGA_Y-450)/3) + (VGA_X-589)/3] * 255;
		end
	// Draw first digit of minutes
	else if (VGA_X >= 572 && VGA_Y >= 450 && VGA_X < 572 + 15 && VGA_Y < 450 + 24
		&& displayMin1[5*((VGA_Y-450)/3) + (VGA_X-572)/3] == 1)
		begin
			outputR <= displayMin1[5*((VGA_Y-450)/3) + (VGA_X-572)/3] * 255;
			outputG <= displayMin1[5*((VGA_Y-450)/3) + (VGA_X-572)/3] * 255;
			outputB <= displayMin1[5*((VGA_Y-450)/3) + (VGA_X-572)/3] * 255;
		end
	// Draw second digit of minutes
	else if (VGA_X >= 555 && VGA_Y >= 450 && VGA_X < 555 + 15 && VGA_Y < 450 + 24
		&& displayMin2[5*((VGA_Y-450)/3) + (VGA_X-555)/3] == 1)
		begin
			outputR <= displayMin2[5*((VGA_Y-450)/3) + (VGA_X-555)/3] * 255;
			outputG <= displayMin2[5*((VGA_Y-450)/3) + (VGA_X-555)/3] * 255;
			outputB <= displayMin2[5*((VGA_Y-450)/3) + (VGA_X-555)/3] * 255;
		end
	else if (currentGameState == END_S || currentGameState == LOSE_S)
		begin
			outputR <= currentGameState == END_S ? 0 : 255;
			outputG <= currentGameState == END_S ? 255 : 0;
			outputB <= 0;
		end
	// Draw Targets
	else if(VGA_X > tarData1[20:11] && VGA_X < tarData1[20:11] + TARGET_WIDTH && VGA_Y > tarData1[10:1] && VGA_Y < tarData1[10:1] + TARGET_HEIGHT
		&& oFrame1Tar1 != WHITE) 					
		begin 
			outputR <= oFrame1Tar1[23:16];
			outputG <= oFrame1Tar1[15:8];
			outputB <= oFrame1Tar1[7:0];
		end
	else if(VGA_X > tarData2[20:11] && VGA_X < tarData2[20:11] + TARGET_WIDTH && VGA_Y > tarData2[10:1] && VGA_Y < tarData2[10:1] + TARGET_HEIGHT
		&& oFrame1Tar2 != WHITE) 					
		begin 
			outputR <= oFrame1Tar2[23:16];
			outputG <= oFrame1Tar2[15:8];
			outputB <= oFrame1Tar2[7:0];
		end
	else if(VGA_X > tarData3[20:11] && VGA_X < tarData3[20:11] + TARGET_WIDTH && VGA_Y > tarData3[10:1] && VGA_Y < tarData3[10:1] + TARGET_HEIGHT
		&& oFrame1Tar3 != WHITE) 					
		begin 
			outputR <= oFrame1Tar3[23:16];
			outputG <= oFrame1Tar3[15:8];
			outputB <= oFrame1Tar3[7:0];
		end
	else if(VGA_X > tarData4[20:11] && VGA_X < tarData4[20:11] + TARGET_WIDTH && VGA_Y > tarData4[10:1] && VGA_Y < tarData4[10:1] + TARGET_HEIGHT
		&& oFrame1Tar4 != WHITE) 					
		begin 
			outputR <= oFrame1Tar4[23:16];
			outputG <= oFrame1Tar4[15:8];
			outputB <= oFrame1Tar4[7:0];
		end
	else if(VGA_X > tarData5[20:11] && VGA_X < tarData5[20:11] + TARGET_WIDTH && VGA_Y > tarData5[10:1] && VGA_Y < tarData5[10:1] + TARGET_HEIGHT
		&& oFrame1Tar5 != WHITE) 					
		begin 
			// Draws the target slightly brighter if it's a "good" target
			outputR <= ((oFrame1Tar5[23:16] + 50) <= 255) ? oFrame1Tar5[23:16] + 50 : 255;
			outputG <= ((oFrame1Tar5[15:8] + 50) <=255) ? oFrame1Tar5[15:8] + 50 : 255;
			outputB <= ((oFrame1Tar5[7:0] + 50) <= 255) ? oFrame1Tar5[7:0] + 50 : 255;
		end
	else if(VGA_X > tarData6[20:11] && VGA_X < tarData6[20:11] + TARGET_WIDTH && VGA_Y > tarData6[10:1] && VGA_Y < tarData6[10:1] + TARGET_HEIGHT
		&& oFrame1Tar6 != WHITE) 					
		begin 
			outputR <= oFrame1Tar6[23:16];
			outputG <= oFrame1Tar6[15:8];
			outputB <= oFrame1Tar6[7:0];
		end
	else if(VGA_X > tarData7[20:11] && VGA_X < tarData7[20:11] + TARGET_WIDTH && VGA_Y > tarData7[10:1] && VGA_Y < tarData7[10:1] + TARGET_HEIGHT
		&& oFrame1Tar7 != WHITE) 					
		begin 
			outputR <= oFrame1Tar7[23:16];
			outputG <= oFrame1Tar7[15:8];
			outputB <= oFrame1Tar7[7:0];
		end
	else if(VGA_X > tarData8[20:11] && VGA_X < tarData8[20:11] + TARGET_WIDTH && VGA_Y > tarData8[10:1] && VGA_Y < tarData8[10:1] + TARGET_HEIGHT
		&& oFrame1Tar8 != WHITE) 					
		begin 
			outputR <= oFrame1Tar8[23:16];
			outputG <= oFrame1Tar8[15:8];
			outputB <= oFrame1Tar8[7:0];
		end
	else if(VGA_X > tarData9[20:11] && VGA_X < tarData9[20:11] + TARGET_WIDTH && VGA_Y > tarData9[10:1] && VGA_Y < tarData9[10:1] + TARGET_HEIGHT
		&& oFrame1Tar9 != WHITE) 					
		begin 
			outputR <= oFrame1Tar9[23:16];
			outputG <= oFrame1Tar9[15:8];
			outputB <= oFrame1Tar9[7:0];
		end
	else if(VGA_X > tarData10[20:11] && VGA_X < tarData10[20:11] + TARGET_WIDTH && VGA_Y > tarData10[10:1] && VGA_Y < tarData10[10:1] + TARGET_HEIGHT
		&& oFrame1Tar10 != WHITE) 					
		begin 
			outputR <= oFrame1Tar10[23:16];
			outputG <= oFrame1Tar10[15:8];
			outputB <= oFrame1Tar10[7:0];
		end
	else //draw background
		begin
			outputR <= oBackgroundColour[11:8]*16;
			outputG <= oBackgroundColour[7:4]*16;
			outputB <= oBackgroundColour[3:0]*16;
		end
end

VGA_Ctrl u9(	//	Host Side
	.iRed(outputR), // mRed
	.iGreen(outputG), // mGreen
	.iBlue(outputB), // mBlue
	.oCurrent_X(VGA_X),
	.oCurrent_Y(VGA_Y),
	.oRequest(VGA_Read),
	//	VGA Side
	.oVGA_R(vga_r10 ),
	.oVGA_G(vga_g10 ),
	.oVGA_B(vga_b10 ),
	.oVGA_HS(VGA_HS),
	.oVGA_VS(VGA_VS),
	.oVGA_SYNC(VGA_SYNC_N),
	.oVGA_BLANK(VGA_BLANK_N),
	.oVGA_CLOCK(VGA_CLK),
	//	Control Signal
	.iCLK(TD_CLK27),
	.iRST_N(DLY2));

//	Line buffer, delay one line
Line_Buffer u10(
	.aclr(!DLY0),
	.clken(VGA_Read),
	.clock(TD_CLK27),
	.shiftin(mYCbCr_d),
	.shiftout(m3YCbCr));

Line_Buffer u11(
	.aclr(!DLY0),
	.clken(VGA_Read),
	.clock(TD_CLK27),
	.shiftin(m3YCbCr),
	.shiftout(m4YCbCr));

AUDIO_DAC u12(	//	Audio Side
	.oAUD_BCK(AUD_BCLK),
	.oAUD_DATA(AUD_DACDAT),
	.oAUD_LRCK(AUD_DACLRCK),
	//	Control Signals
	.iSrc_Select(2'b01),
	.iCLK_18_4(AUD_CTRL_CLK),
	.iRST_N(DLY1));

//	Audio CODEC and video decoder setting
I2C_AV_Config u1(	//	Host Side
	.iCLK(CLOCK_50),
	.iRST_N(KEY[0]),
	//	I2C Side
	.I2C_SCLK(FPGA_I2C_SCLK),
	.I2C_SDAT(FPGA_I2C_SDAT));	

endmodule
