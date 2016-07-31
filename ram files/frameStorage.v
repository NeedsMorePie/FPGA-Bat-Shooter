
// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module multiFrameStorage(
	input clock,
	input [11:0] address1, address2, address3, address4, address5, address6, address7, address8, address9, address10,
	input [2:0] state1, state2, state3, state4, state5, state6, state7, state8, state9, state10,
	output reg [23:0] q1, q2, q3, q4, q5, q6, q7, q8, q9, q10);
	
	// Parameters to be changed from outside
	parameter FRAME1_IMAGE = "frame.mif";
	parameter FRAME2_IMAGE = "frame.mif";
	
	// Possible States
	parameter DEAD_S = 3'b000, DYING_S = 3'b001, ALIVE1_S = 3'b010, ALIVE2_S = 3'b011;
	
	wire [23:0] q1S1, q2S1, q3S1, q4S1, q5S1, q6S1, q7S1, q8S1, q9S1, q10S1;
	
	wire [23:0] q1S2, q2S2, q3S2, q4S2, q5S2, q6S2, q7S2, q8S2, q9S2, q10S2;
	
	// ASSIGNS OUTPUT
	
	// Target 1
	always@(*)
	begin
		case(state1)
			DEAD_S: q1 = q1S1;
			DYING_S: q1 = q1S1;
			ALIVE1_S: q1 = q1S1;
			ALIVE2_S: q1 = q1S2;
			default: q1 = q1S1;
		endcase
	end
	
	// Target 2
	always@(*)
	begin
		case(state2)
			DEAD_S: q2 = q2S1;
			DYING_S: q2 = q2S1;
			ALIVE1_S: q2 = q2S1;
			ALIVE2_S: q2 = q2S2;
			default: q2 = q2S1;
		endcase
	end
	
	// Target 3
	always@(*)
	begin
		case(state3)
			DEAD_S: q3 = q3S1;
			DYING_S: q3 = q3S1;
			ALIVE1_S: q3 = q3S1;
			ALIVE2_S: q3 = q3S2;
			default: q3 = q3S1;
		endcase
	end
	
	// Target 4
	always@(*)
	begin
		case(state4)
			DEAD_S: q4 = q4S1;
			DYING_S: q4 = q4S1;
			ALIVE1_S: q4 = q4S1;
			ALIVE2_S: q4 = q4S2;
			default: q4 = q4S1;
		endcase
	end
	
	// Target 5
	always@(*)
	begin
		case(state5)
			DEAD_S: q5 = q5S1;
			DYING_S: q5 = q5S1;
			ALIVE1_S: q5 = q5S1;
			ALIVE2_S: q5 = q5S2;
			default: q5 = q5S1;
		endcase
	end
	
	// Target 6
	always@(*)
	begin
		case(state6)
			DEAD_S: q6 = q6S1;
			DYING_S: q6 = q6S1;
			ALIVE1_S: q6 = q6S1;
			ALIVE2_S: q6 = q6S2;
			default: q6 = q6S1;
		endcase
	end
	
	// Target 7
	always@(*)
	begin
		case(state7)
			DEAD_S: q7 = q7S1;
			DYING_S: q7 = q7S1;
			ALIVE1_S: q7 = q7S1;
			ALIVE2_S: q7 = q7S2;
			default: q7 = q7S1;
		endcase
	end
	
	// Target 8
	always@(*)
	begin
		case(state8)
			DEAD_S: q8 = q8S1;
			DYING_S: q8 = q8S1;
			ALIVE1_S: q8 = q8S1;
			ALIVE2_S: q8 = q8S2;
			default: q8 = q8S1;
		endcase
	end
	
	// Target 9
	always@(*)
	begin
		case(state9)
			DEAD_S: q9 = q9S1;
			DYING_S: q9 = q9S1;
			ALIVE1_S: q9 = q9S1;
			ALIVE2_S: q9 = q9S2;
			default: q9 = q9S1;
		endcase
	end
	
	// Target 10
	always@(*)
	begin
		case(state10)
			DEAD_S: q10 = q10S1;
			DYING_S: q10 = q10S1;
			ALIVE1_S: q10 = q10S1;
			ALIVE2_S: q10 = q10S2;
			default: q10 = q10S1;
		endcase
	end
	
	// FRAME 1
	frameStorage FS1(
		.address1(address1), .address2(address2),
		.clock(clock),
		.data(0),
		.wren(0),
		.q1(q1S1), .q2(q2S1));
	defparam
		FS1.FRAME_IMAGE = FRAME1_IMAGE;
		
	frameStorage FS2(
		.address1(address3), .address2(address4),
		.clock(clock),
		.data(0),
		.wren(0),
		.q1(q3S1), .q2(q4S1));
	defparam
		FS2.FRAME_IMAGE = FRAME1_IMAGE;
		
	frameStorage FS3(
		.address1(address5), .address2(address6),
		.clock(clock),
		.data(0),
		.wren(0),
		.q1(q5S1), .q2(q6S1));
	defparam
		FS3.FRAME_IMAGE = FRAME1_IMAGE;
		
	frameStorage FS4(
		.address1(address7), .address2(address8),
		.clock(clock),
		.data(0),
		.wren(0),
		.q1(q7S1), .q2(q8S1));
	defparam
		FS4.FRAME_IMAGE = FRAME1_IMAGE;
		
	frameStorage FS5(
		.address1(address9), .address2(address10),
		.clock(clock),
		.data(0),
		.wren(0),
		.q1(q9S1), .q2(q10S1));
	defparam
		FS5.FRAME_IMAGE = FRAME1_IMAGE;
		
	// FRAME 2
	frameStorage FS6(
		.address1(address1), .address2(address2),
		.clock(clock),
		.data(0),
		.wren(0),
		.q1(q1S2), .q2(q2S2));
	defparam
		FS6.FRAME_IMAGE = FRAME2_IMAGE;
		
	frameStorage FS7(
		.address1(address3), .address2(address4),
		.clock(clock),
		.data(0),
		.wren(0),
		.q1(q3S2), .q2(q4S2));
	defparam
		FS7.FRAME_IMAGE = FRAME2_IMAGE;
		
	frameStorage FS8(
		.address1(address5), .address2(address6),
		.clock(clock),
		.data(0),
		.wren(0),
		.q1(q5S2), .q2(q6S2));
	defparam
		FS8.FRAME_IMAGE = FRAME2_IMAGE;
		
	frameStorage FS9(
		.address1(address7), .address2(address8),
		.clock(clock),
		.data(0),
		.wren(0),
		.q1(q7S2), .q2(q8S2));
	defparam
		FS9.FRAME_IMAGE = FRAME2_IMAGE;
		
	frameStorage FS10(
		.address1(address9), .address2(address10),
		.clock(clock),
		.data(0),
		.wren(0),
		.q1(q9S2), .q2(q10S2));
	defparam
		FS10.FRAME_IMAGE = FRAME2_IMAGE;

endmodule

module frameStorage (
	address1, address2,
	clock,
	data,
	wren,
	q1, q2);

	input	[11:0]  address1, address2;
	input	  clock;
	input	[23:0]  data;
	input	  wren;
	output	[23:0]  q1, q2;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri1	  clock;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	parameter FRAME_IMAGE = "frame.mif";

	wire [23:0] sub_wire0;
	wire [23:0] q1 = sub_wire0[23:0];
	
	wire [23:0] sub_wire1;
	wire [23:0] q2 = sub_wire1[23:0];

	altsyncram	altsyncram_component (
		.address_a (address1),
		.address_b (address2),
		.clock0 (clock),
		.data_a (data),
		.data_b (data),
		.wren_a (wren),
		.wren_b (wren),
		.q_a (sub_wire0),
		.q_b (sub_wire1),
		.aclr0 (1'b0),
		.aclr1 (1'b0),
		.addressstall_a (1'b0),
		.addressstall_b (1'b0),
		.byteena_a (1'b1),
		.byteena_b (1'b1),
		.clock1 (1'b1),
		.clocken0 (1'b1),
		.clocken1 (1'b1),
		.clocken2 (1'b1),
		.clocken3 (1'b1),
		.eccstatus (),
		.rden_a (1'b1),
		.rden_b (1'b1));
	defparam
		altsyncram_component.address_reg_b = "CLOCK0",
		altsyncram_component.clock_enable_input_a = "BYPASS",
		altsyncram_component.clock_enable_input_b = "BYPASS",
		altsyncram_component.clock_enable_output_a = "BYPASS",
		altsyncram_component.clock_enable_output_b = "BYPASS",
		altsyncram_component.indata_reg_b = "CLOCK0",
		altsyncram_component.intended_device_family = "Cyclone V",
		altsyncram_component.lpm_type = "altsyncram",
		altsyncram_component.numwords_a = 3280,
		altsyncram_component.numwords_b = 3280,
		altsyncram_component.operation_mode = "BIDIR_DUAL_PORT",
		altsyncram_component.outdata_aclr_a = "NONE",
		altsyncram_component.outdata_aclr_b = "NONE",
		altsyncram_component.outdata_reg_a = "UNREGISTERED",
		altsyncram_component.outdata_reg_b = "UNREGISTERED",
		altsyncram_component.power_up_uninitialized = "FALSE",
		altsyncram_component.read_during_write_mode_mixed_ports = "DONT_CARE",
		altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
		altsyncram_component.read_during_write_mode_port_b = "NEW_DATA_NO_NBE_READ",
		altsyncram_component.widthad_a = 24,
		altsyncram_component.widthad_b = 24,
		altsyncram_component.width_a = 24,
		altsyncram_component.width_b = 24,
		altsyncram_component.width_byteena_a = 1,
		altsyncram_component.width_byteena_b = 1,
		altsyncram_component.wrcontrol_wraddress_reg_b = "CLOCK0",
		altsyncram_component.INIT_FILE = FRAME_IMAGE;
		
endmodule


