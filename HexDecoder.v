module hexdecoder(HEX, S);
    input [3:0] S;
    output [6:0] HEX;

	reg [6:0] ssOut;

	always@(S)
		case (S)
			4'b0000 : ssOut = 7'b0111111; //0
			4'b0001 : ssOut = 7'b0000110; //1
			4'b0010 : ssOut = 7'b1011011; //2
			4'b0011 : ssOut = 7'b1001111; //3
			4'b0100 : ssOut = 7'b1100110; //4
			4'b0101 : ssOut = 7'b1101101; //5
			4'b0110 : ssOut = 7'b1111101; //6
			4'b0111 : ssOut = 7'b0000111; //7
			4'b1000 : ssOut = 7'b1111111; //8
			4'b1001 : ssOut = 7'b1100111; //9
			4'b1010 : ssOut = 7'b1110111; //A
			4'b1011 : ssOut = 7'b1111100; //b
			4'b1100 : ssOut = 7'b0111001; //C
			4'b1101 : ssOut = 7'b1011110; //d
			4'b1110 : ssOut = 7'b1111001; //E
			4'b1111 : ssOut = 7'b1110001; //F
			default: ssOut = 7'b0111111;
		endcase
	
	assign HEX[0] = ~ssOut[0];
	assign HEX[1] = ~ssOut[1];
	assign HEX[2] = ~ssOut[2];
	assign HEX[3] = ~ssOut[3];
	assign HEX[4] = ~ssOut[4];
	assign HEX[5] = ~ssOut[5];
	assign HEX[6] = ~ssOut[6];
endmodule