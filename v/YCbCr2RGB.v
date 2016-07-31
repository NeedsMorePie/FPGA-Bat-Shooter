// ============================================================================
// Copyright (c) 2012 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//
//
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// ============================================================================
//
// Major Functions:	YCbCr to RGB Color Doamin Converter. 
//					( 10 Bits Resolution )
//
// ============================================================================
//
// Revision History :
// ============================================================================
//   Ver  :| Author            :| Mod. Date   :| Changes Made:
//   V1.0 :| Johnny Chen       :| 05/09/05    :|      Initial Revision
//   V2.0 :| Peli   Li         :| 04/19/2010  :|      revised the megacore instance
// ============================================================================


module YCbCr2RGB (	
	oRed,
	oGreen,
	oBlue,
    
	iY,
	iCb,
	iCr,
	iCLK					
);

//===========================================================================
// PARAMETER declarations
//===========================================================================


//===========================================================================
// PORT declarations
//===========================================================================
					
input [7:0] iY  ;
input [7:0] iCb ;
input [7:0] iCr ;
input 		iCLK;
output [9:0]oRed;
output [9:0]oGreen;
output [9:0]oBlue;


///////////////////////////////////////////////////////////////////
//=============================================================================
// REG/WIRE declarations
//=============================================================================

// OUTPUT RGB 10bit x 3 //
reg 	[9:0]  oRed;
reg 	[9:0]  oGreen;
reg 	[9:0]  oBlue;

// TEMP RGB 21bit x 3 //
wire 	[20:0] mR;
wire 	[20:0] mG;
wire 	[20:0] mB;


//=============================================================================
// Structural coding
//=============================================================================

/*******************************************/
/* IMPLEMENT: ( Fractional:12BITs )        */
/* R = Y+   1.402(Cr-128) 				   */
/* G = Y- 0.34414(Cb-128) -0.71212(Cr-128) */
/* B = Y+   1.772(Cb-128)				   */
/*										   */
/*******************************************/
assign mR =  iY*4096 + 4096*(iCr-128) + 1647*(iCr-128); //0.402x4096
assign mG =  iY*4096 - 1410*(iCb-128) - 2917*(iCr-128); //0.34414x4096 , 0.71212x4096
assign mB =  iY*4096 + 4096*(iCb-128) + 3162*(iCb-128); //0.772x4096 


// 0 ~ 3FF CLAMP //
always @(posedge iCLK) begin
	oRed  [9:0] =(mR[20])? 0 :( (mR >= 20'hfffff)? 10'h3FF: mR[19:10] ) ;
	oGreen[9:0] =(mG[20])? 0 :( (mG >= 20'hfffff)? 10'h3FF: mG[19:10] ) ;
	oBlue [9:0] =(mB[20])? 0 :( (mB >= 20'hfffff)? 10'h3FF: mB[19:10] ) ;
end

endmodule
