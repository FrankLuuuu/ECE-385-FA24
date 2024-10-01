// done
//Two-always example for state machine

module control (
	input  logic Clk, 
	input  logic RAB,					// this button is for clear A, load B and reset
	input  logic Run,					// execute equivalent
	input  logic M1,					// last bit of B (LSB)
	input  logic M,

	output logic Clear_Load,			// is this needed? this should be covered by RAB
	output logic Shift,
	output logic Add,					// signaled by if m = 1 and index < 7
	output logic Sub					// signaled by if index = 7
);

// Declare signals curr_state, next_state of type enum
// with enum values of s_start, s_count0, ..., s_done as the state values
// Note that the length implies a max of 8 states, so you will need to bump this up for 8-bits
	enum logic [4:0] {
		s_start, 
		s_add1, s_add2, s_add3, s_add4, 
		s_add5, s_add6, s_add7, s_sub,
		s_shift1, s_shift2, s_shift3, s_shift4, 
		s_shift5, s_shift6, s_shift7, s_shift8, 
		s_clear, s_done
	} curr_state, next_state; 

	//updates flip flop, current state is the only one
	always_ff @(posedge Clk)  
	begin
		if (RAB)
			curr_state <= s_start;
		else 
			curr_state <= next_state;
	end

	always_comb
	begin
	// Assign outputs based on state
		next_state  = curr_state;	//required because I haven't enumerated all possibilities below. Synthesis would infer latch without this
		unique case (curr_state) 
		
			s_start: 
                if (Run)
                    next_state = s_clear;
                else
                    next_state = curr_state;

			s_add1: 
				next_state = s_shift1;

			s_add2: 
				next_state = s_shift2;

			s_add3: 
				next_state = s_shift3;

			s_add4: 
				next_state = s_shift4;

			s_add5: 
				next_state = s_shift5;

			s_add6: 
				next_state = s_shift6;

			s_add7: 
				next_state = s_shift7;

			s_sub: 
				next_state = s_shift8;

			s_shift1:
                if (M)
                    next_state = s_add2;
                else
                    next_state = s_shift2;

			s_shift2:
                if (M)
                    next_state = s_add3;
                else
                    next_state = s_shift3;

			s_shift3:
                if (M)
                    next_state = s_add4;
                else
                    next_state = s_shift4;

			s_shift4:
                if (M)
                    next_state = s_add5;
                else
                    next_state = s_shift5;

			s_shift5:
                if (M)
                    next_state = s_add6;
                else
                    next_state = s_shift6;

			s_shift6:
                if (M)
                    next_state = s_add7;
                else
                    next_state = s_shift7;

			s_shift7:
                if (M)
                    next_state = s_sub;
                else
                    next_state = s_shift8;

			s_shift8:
				next_state = s_done;

			s_clear: 
                if (M1)
                    next_state = s_add1;
                else
                    next_state = s_shift1;

			s_done: 
				if (~Run)
                    next_state = s_start;
                else
                    next_state = curr_state;

		endcase
	end

// Assign outputs based on 'state'
	always_comb
	begin

		case (curr_state)  
			
			s_add1, s_add2, s_add3, s_add4, s_add5, s_add6, s_add7:
			begin
				Clear_Load = 0;
                Shift = 0;
                Add = 1;
                Sub = 0;
            end

			s_sub:
			begin
				Clear_Load = 0;
                Shift = 0;
                Add = 0;
                Sub = 1;
            end
            
			s_shift1, s_shift2, s_shift3, s_shift4, s_shift5, s_shift6, s_shift7, s_shift8:
			begin
				Clear_Load = 0;
                Shift = 1;
                Add = 0;
                Sub = 0;
            end
            
			s_clear:
			begin
				Clear_Load = 1;
                Shift = 0;
                Add = 0;
                Sub = 0;
			end
			
			default:
            begin
                Clear_Load = 0;
                Shift = 0;
                Add = 0;
                Sub = 0;
			end	
		endcase
	end

endmodule
