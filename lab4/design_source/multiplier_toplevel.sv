// change, multiplier_toplevel() module done
//Top level for ECE 385 adders lab
//modified for Spring 2024

//Note: lowest 2 HEX digits will reflect lower 8 bits of switch input
//Upper 4 HEX digits will reflect value in the accumulator


module multiplier_toplevel   (
	input  logic 		clk, 
	input  logic		rab, 		//reset, clear A, load B
	input  logic 		run, 		//equivalent of execute
	input  logic [7:0] 	sw_input,

	output logic [7:0]  hex_seg,
	output logic [3:0]  hex_grid,
	output logic [7:0] 	A,
	output logic [7:0] 	B,
	output logic 		X
);


// wires for in betweeen models
// **REGISTER UNIT**
	logic xa;			//shift x to a
	logic ab;			//shift a to b
	logic [7:0] reg_a_dout;
	logic [7:0] reg_b_dout;
// **CONTROL UNIT**
	logic RAB_s;			//wire from rab button to control unit
	logic run_s;			//wire from run button to control unit

// **RIPPLE ADDER UNIT**
	logic [7:0] sw_input_s;
	logic [7:0] adder_out;

	logic add_wire;
	logic sub_wire;
	logic clear_wire;
	logic shift_wire;

	logic bout;

	always_comb begin	
		A = reg_a_dout;
		B = reg_b_dout;	
		X = xa;
	end
    
	// Allows the register to load once, and not during full duration of button press
	// ie. converts an active low button press to a single clock cycle active high event
	
	// Register unit that holds the accumulated sum

	// done
	reg_8 reg_a (
		.Clk		(clk),
		.Reset		(clear_wire | RAB_s),
		.Shift_In	(xa),
		.Load		(add_wire | sub_wire),
		.Shift 		(shift_wire),
		.D 			(adder_out),
		
		.Shift_Out	(ab),
		.Data_Out	(reg_a_dout)
	);

	// done
	reg_8 reg_b (
		.Clk		(clk),
		.Reset		(1'b0),
		.Shift_In	(ab),
		.Load		(RAB_s),
		.Shift 		(shift_wire),
		.D 			(sw_input_s),
		
		.Shift_Out	(bout),
		.Data_Out	(reg_b_dout)
	);	

	// done
	adder shift_adder (
		.a 			(reg_a_dout),
		.s 			(sw_input_s),
		.subtract 	(sub_wire),

		.s_out		(adder_out),
		.x 			(xa)
	);

	// 
	control control_unit (
		.Clk		(clk),
		.RAB		(RAB_s),
		.Run		(run_s),
		.M1			(reg_b_dout[0]),
		.M 			(reg_b_dout[1]),
		
		.Clear_Load (clear_wire),
		.Shift		(shift_wire),
		.Add		(add_wire),
		.Sub		(sub_wire)
	);

	// done
	// Hex units that display contents of sw and sum register in hex
	hex_driver hex_a (
		.clk		(clk),
		.reset		(reset_s),
		.in			({reg_a_dout[7:4], reg_a_dout[3:0], reg_b_dout[7:4], reg_b_dout[3:0]}),
		
		.hex_seg	(hex_seg),
		.hex_grid	(hex_grid)
	);
	
	// done
	// Synchchronizers/debouncers
	sync_debounce button_sync [1:0] (
	   .clk    (clk),
	   
	   .d      ({rab, run}),
	   .q      ({RAB_s, run_s})
	);

	// done
	sync_debounce switch_sync [7:0] (
	   .clk    (clk),
	   
	   .d      (sw_input),
	   .q      (sw_input_s)
	);
		
endmodule