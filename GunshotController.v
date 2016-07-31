module GunShotController(clock, trigger, oSound);
	// I/O
	input clock, trigger;
	output [31:0] oSound; // Sound controller accepts 32 bits
	
	// States
	parameter START_S = 0, PLAYSOUND_S = 1;
	
	// Current and next state variables
	reg [2:0] currentState, nextState;
	initial currentState = START_S;
	
	// Inputs to the soundstorage module
	reg [13:0] address;
	initial address = 0;
	wire [5:0] soundOutput;
	
	// Sound storage ram
	SoundStorage soundStorage1(
		.address(address),
		.clock(clock),
		.q(soundOutput));
	
	// Rate divider variables for 16kHz sampled sound
	// Assume clock is 27MHz
	parameter MAXCOUNT = 1688; // 1688
	reg [10:0] soundCount;
	initial soundCount = 0;
	
	// State table
	always@(*)
	begin
		case (currentState)
			START_S:
			begin
				if (trigger == 1) nextState = PLAYSOUND_S;
				else nextState = START_S;
			end
			PLAYSOUND_S:
			begin
				if (address >= 11541) nextState = START_S; // Restart from playsound if trigger is pressed again
				else nextState = PLAYSOUND_S;
			end
			default:
			begin
				nextState = START_S;
			end
		endcase
	end
	
	// Goes to next state
	always@(posedge clock)
	begin
		currentState <= nextState;
		
		if (currentState == START_S)
		begin
			// If state state, reset the address and soundCount
			address <= 0;
			soundCount <= 0;
		end
		else if (currentState == PLAYSOUND_S && trigger == 1)
		begin
			// Restart the sound if the trigger is fired again during sound-play
			address <= 0;
			soundCount <= 0;
		end
		else
		begin
			// Rate divider
			if (soundCount < MAXCOUNT)
				soundCount <= soundCount + 1;
			else
			begin
				// Reset the rate divider
				soundCount <= 0;
				
				// Increment address 16k times a second
				address <= address + 1;
			end
		end
	end
	
	// Assign output
	// Scaling factor to 32 bit sound is 67108864
	// 0 sound is at the halfway mark of 2^32 (2147483648)
	assign oSound = (currentState == PLAYSOUND_S) ? soundOutput * 67108864 : 2147483648; 
	
endmodule


module SoundStorage (
	address,
	clock,
	q);

	input	[13:0]  address;
	input	  clock;
	output	[5:0]  q;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri1	  clock;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire [5:0] sub_wire0;
	wire [5:0] q = sub_wire0[5:0];

	altsyncram	altsyncram_component (
				.address_a (address),
				.clock0 (clock),
				.data_a (0),
				.wren_a (1'b0),
				.q_a (sub_wire0),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.address_b (1'b1),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clock1 (1'b1),
				.clocken0 (1'b1),
				.clocken1 (1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.data_b (1'b1),
				.eccstatus (),
				.q_b (),
				.rden_a (1'b1),
				.rden_b (1'b1),
				.wren_b (1'b0));
	defparam
		altsyncram_component.clock_enable_input_a = "BYPASS",
		altsyncram_component.clock_enable_output_a = "BYPASS",
		altsyncram_component.intended_device_family = "Cyclone V",
		altsyncram_component.lpm_hint = "ENABLE_RUNTIME_MOD=NO",
		altsyncram_component.lpm_type = "altsyncram",
		altsyncram_component.numwords_a = 11542,
		altsyncram_component.operation_mode = "SINGLE_PORT",
		altsyncram_component.outdata_aclr_a = "NONE",
		altsyncram_component.outdata_reg_a = "UNREGISTERED",
		altsyncram_component.power_up_uninitialized = "FALSE",
		altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
		altsyncram_component.widthad_a = 14,
		altsyncram_component.width_a = 6,
		altsyncram_component.width_byteena_a = 1,
		altsyncram_component.init_file = "gunshot.mif";

endmodule