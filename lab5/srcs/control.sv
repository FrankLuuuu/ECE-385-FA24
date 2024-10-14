//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Given Code - Incomplete ISDU for SLC-3
// Module Name:    Control - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//    Revised 07-25-2023
//    Xilinx Vivado
//	  Revised 12-29-2023
// 	  Spring 2024 Distribution
// 	  Revised 6-22-2024
//	  Summer 2024 Distribution
//	  Revised 9-27-2024
//	  Fall 2024 Distribution
//------------------------------------------------------------------------------

module control (
	input logic			clk, 
	input logic			reset,

	input logic  [15:0]	ir,
	input logic			ben,

	input logic 		continue_i,
	input logic 		run_i,

	output logic		ld_mar,
	output logic		ld_mdr,
	output logic		ld_ir,
	output logic		ld_pc,
	output logic        ld_led,
						
	output logic		gate_pc,
	output logic		gate_mdr,
						
	output logic [1:0]	pcmux,


	output logic 		mio_en,
	
	//You should add additional control signals according to the SLC-3 datapath design
	// output logic 		gate_alu,
	output logic 		gate_marmux,

	output logic		mem_mem_ena, // Mem Operation Enable
	output logic		mem_wr_ena,  // Mem Write Enable

	output logic		sr1muxcontrol,
	output logic		sr2muxcontrol,
	output logic [1:0] 	aluk,
	output logic		ld_cc,
	output logic		gate_alu,
	output logic 		drmux_control,
	output logic		load_reg,
	output logic [1:0]	addr2mux,
	output logic		addr1mux,
);

	
	enum logic [4:0] {
		halted, 
		pause_ir1,
		pause_ir2, 
		s_18, 		//top steps that fetch
		s_33_1,		//provided
		s_33_2,
		s_33_3,
		s_35,

		//new states
		s_32,		//decode step

		s_add,		//1 sr2
		s_add_i,	//second add imm5
		s_and,		//5 sr2
		s_and_i, 	//second and imm5
		s_not, 		//9

		s_ldr_1,	//6
		s_ldr_2,	//25
		s_ldr_3,	//27

		s_str_1,	//7
		s_str_2,	//23
		s_str_3,	//16

		s_jsr_1,	//4
		s_jsr_2,	//21

		s_jmp,		//12

		s_br_1,		//0
		s_br_2,		//22

		//scratch that theyre provided
		// s_ps_1,		//continue pressed
		// s_ps_2,		//continue released

		//end of added sstates
	} state, state_nxt;   // Internal state logic


	always_ff @ (posedge clk)
	begin
		if (reset) 
			state <= halted;
		else 
			state <= state_nxt;
	end
   
	always_comb
	begin 
		
		// Default controls signal values so we don't have to set each signal
		// in each state case below (If we don't set all signals in each state,
		// we can create an inferred latch)
		ld_mar = 1'b0;
		ld_mdr = 1'b0;
		ld_ir = 1'b0;
		ld_pc = 1'b0;
		ld_led = 1'b0;
		
		gate_pc = 1'b0;
		gate_mdr = 1'b0;
		 
		pcmux = 2'b00;


		mio_en = 1'b0;					
		mem_mem_ena = 1'b0;

		
		//IMPORTANT: NEED TO SET OTHER GATES TO ZERO AFRER uSEr, NOT IMPLEMENTED
		// Assign relevant control signals based on current state
		case (state)
			halted: ; 
			s_18 : 
				begin 
					gate_pc = 1'b1;
					ld_mar = 1'b1;
					pcmux = 2'b00;
					ld_pc = 1'b1;
				end
			s_33_1, s_33_2, s_33_3 : //you may have to think about this as well to adapt to ram with wait-states
				begin
					mem_mem_ena = 1'b1;
					ld_mdr = 1'b1;
				end
			s_35 : 
				begin 
					gate_mdr = 1'b1;
					ld_ir = 1'b1;
				end
			pause_ir1: ld_led = 1'b1; 
			pause_ir2: ld_led = 1'b1; 
			// you need to finish the rest of state output logic..... 
			s_add:
				sr1muxcontrol = 1'b0;
				sr2muxcontrol = 1'b1;
				aluk = 2'b00;
				ld_cc = 1'b1;				//ASSUMING THAT LOAD SHOUDL BE HIGH TO LOAD
				gate_alu = 1'b1;
				drmux_control = 1'b1;
				ld_reg = 1'b1;
			s_add_i:
				sr1muxcontrol = 1'b0;
				sr2muxcontrol = 1'b0;
				aluk = 2'b00;
				ld_cc = 1'b1;
				gate_alu = 1'b1;
				drmux_control =  1'b1;
				ld_reg = 1'b1;
			s_and:
				sr1muxcontrol = 1'b0;
				sr2muxcontrol = 1'b1;
				aluk = 2'b01;
				ld_cc = 1'b1;				//ASSUMING THAT LOAD SHOUDL BE HIGH TO LOAD
				gate_alu = 1'b1;
				drmux_control = 1'b1;
				ld_reg = 1'b1;				
			s_and_i:
				sr1muxcontrol = 1'b0;
				sr2muxcontrol = 1'b0;
				aluk = 2'b01;
				ld_cc = 1'b1;				//ASSUMING THAT LOAD SHOUDL BE HIGH TO LOAD
				gate_alu = 1'b1;
				drmux_control = 1'b1;
				ld_reg = 1'b1;	
			s_not:
				sr1muxcontrol = 1'b0;
				aluk = 2'b10;
				ld_cc = 1'b1;				//ASSUMING THAT LOAD SHOUDL BE HIGH TO LOAD
				gate_alu = 1'b1;
				drmux_control = 1'b1;
				ld_reg = 1'b1;	
			s_ldr_1:
				addr2mux = 2'b01;
				addr1mux = 1'b1;
				sr1muxcontrol = 1'b0;
				gate_marmux = 1'b1;
				ld_mar = 1'b1;
			s_ldr_2:
				ld_mdr = 1'b1;
				mio_en = 1'b1;

			//pick up on s_ldr_2

			default : ;
		endcase
	end 


	always_comb
	begin
		// default next state is staying at current state
		state_nxt = state;

		unique case (state):
			halted: 
				if (run_i) 
					state_nxt = s_18;
			s_18 : 
				state_nxt = s_33_1; //notice that we usually have 'r' here, but you will need to add extra states instead 
			s_33_1 :                 //e.g. s_33_2, etc. how many? as a hint, note that the bram is synchronous, in addition, 
				state_nxt = s_33_2;   //it has an additional output register. 
			s_33_2 :
				state_nxt = s_33_3;
			s_33_3 : 
				state_nxt = s_35;
			s_35 : 
				state_nxt = pause_ir1;
			// pause_ir1 and pause_ir2 are only for week 1 such that TAs can see 
			// the values in ir.

			//EDITED TO REMOVE INFERRED LATCH
			pause_ir1 : 
				if (continue_i) 
					state_nxt = pause_ir2;
				else
					state_nxt = pause_ir1;
			pause_ir2 : 
				if (~continue_i)
					state_nxt = s_18;
				else
					state_nxt = pause_ir2;
			// you need to finish the rest of state transition logic.....
			
			//edited past this line:
			s_32:		//decode step
				// state_nxt = s_18;		//fetchagain
			//THIS IS WRONG IMPLEMENT DECODE HErE
				// if (ir[15:12] == 4'b0001)
				// 	state_nxt = s_add;
				// if (ir[15:12] == 4'b0101)
				// 	state_nxt = s_and;
				// if (ir[15:12] == 4'b1001)
				// 	state_nxt = s_not;
				// if (ir[15:12] == 4'b0000)
				// 	state_nxt = s_not;
				// if (ir[15:12] == 4'b0000)
				// 	state_nxt = s_not;
				// 	if (ir[15:12] == 4'b1001)
				// 	state_nxt = s_not;
				// 	if (ir[15:12] == 4'b1001)
				// 	state_nxt = s_not;
				// 	if (ir[15:12] == 4'b1001)
				// 	state_nxt = s_not;
				// 	if (ir[15:12] == 4'b1001)
				// 	state_nxt = s_not;
				// 	if (ir[15:12] == 4'b1001)
				// 	state_nxt = s_not;
				unique case (ir[15:12]):
					op_add: 
						if(~ir[5]):
							state_nxt = s_add;
						else:
							state_nxt = s_add_i;
					op_and: 
						if(~ir[5]):
							state_nxt = s_and;
						else:
							state_nxt = s_and_i;
					op_not: state_nxt = s_not;
					op_ldr: state_nxt = s_ldr_1;
					op_str: state_nxt = s_str_1;
					op_jsr: state_nxt = s_jsr_1;
					op_jmp: state_nxt = s_jmp;
					op_br: 	state_nxt = s_br_1;
					op_pse: state_nxt = s_ps_1;
				endcase

			//i send based on the first 4 to add or and, need to add logic to check bit ir[5]
			s_add:		//1 sr2

				state_nxt = s_18;		//fetchagain
			s_add_i:	//second add imm5
				state_nxt = s_18;		//fetchagain
			s_and:		//5 sr2
				state_nxt = s_18;		//fetchagain
			s_and_i: 	//second and imm5
				state_nxt = s_18;		//fetchagain
			s_not: 		//9
				state_nxt = s_18;		//fetchagain


			//**might have to add extra states whiile waiting for r signal
			//like, i think that instead of waiting for r we find the number of states we need to add instead
			s_ldr_1:	//6
				state_nxt = s_ldr_2;	//25

			//added 2 extra states to accomodate for clock for synchronous memeory
			//because it is not overwritten in current clock cycle, must wait for another
			s_ldr_2:	//25
				state_nxt = s_ldr_22;	//wait cycle
			s_ldr_22:	//25
				state_nxt = s_ldr_23;	//wait cycle
			s_ldr_23:	//25
				state_nxt = s_ldr_3;	//27
			//end of state 25

			s_ldr_3:	//27
				state_nxt = s_18;		//fetchagain


			//**might have to add extra states whiile waiting for r signal
			//like, i think that instead of waiting for r we find the number of states we need to add instead
			s_str_1:	//7
				state_nxt = s_str_2;

			//added 2 extra states to accomodate for clock for synchronous memeory
			s_str_2:	//23
				state_nxt = s_str_22;	//wait cycle
			s_str_22:	//23
				state_nxt = s_str_23;	//wait cycle
			s_str_23:	//23
				state_nxt = s_str_3;
			//end of  state 23

			s_str_3:	//16
				state_nxt = s_18;		//fetchagain

			s_jsr_1:	//4
				state_nxt = s_jsr_2;
			s_jsr_2:	//21
				state_nxt = s_18;		//fetchagain

			s_jmp:		//12
				state_nxt = s_18;		//fetchagain

			s_br_1:		//0
				if (ben)
					state_nxt = s_br_2;	
				else	
					state_nxt = s_18;
			s_br_2:		//22
				state_nxt = s_18;		//fetchagain


			default :
			state_nxt = s_18;
			//end of edits
		endcase
	end
	
endmodule
