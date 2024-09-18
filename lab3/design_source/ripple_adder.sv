module fa (input logic a, b, c
			output logic s, c_out
			);

	always_comb begin	//procedure block for combinational logic
			s = a ^ b ^ c;	//note: blocking assignment (=)
			c_out = (a & b) | (b | c) | (a & c);
	end

endmodule


module ripple_adder (
	input  logic  [15:0] a, 
    input  logic  [15:0] b,
	input  logic         cin,
	
	output logic  [15:0] s,
	output logic         cout
);

	/* TODO
		*
		* Insert code here to implement a ripple adder.
		* Your code should be completly combinational (don't use always_ff or always_latch).
		* Feel free to create sub-modules or other files. */
    
endmodule