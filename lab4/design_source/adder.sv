// change
module fa (input logic a, b, c,
			output logic s, c_out);

	always_comb begin	//procedure block for combinational logic
			s = a ^ b ^ c;	//note: blocking assignment (=)
			c_out = (a & b) | (b & c) | (a & c);
	end

endmodule

module adder(input logic [7:0] a, s,
				input logic subtract,
				output logic [7:0] s_out,
				output logic x);
    
    logic [8:0] a_shift, s_multiplicand, s_complement;
    
    logic c1, c2, c3, c4, c5, c6, c7, c8;
    logic overflow;
    
    always_comb
    begin
		a_shift[8] = a[7]; // sign extended to 9 bits
		s_multiplicand[8] = s[7];
		a_shift[7:0] = a;
		s_multiplicand[7:0] = s;

        s_complement = s_multiplicand ^ {9{subtract}}; // two's complement
    end

	fa fa0 (.a(a_shift[0]), .b(s_complement[0]), .c(subtract), .s(s_out[0]), .c_out(c1));
    fa fa1 (.a(a_shift[1]), .b(s_complement[1]),       .c(c1), .s(s_out[1]), .c_out(c2));
    fa fa2 (.a(a_shift[2]), .b(s_complement[2]),       .c(c2), .s(s_out[2]), .c_out(c3));
    fa fa3 (.a(a_shift[3]), .b(s_complement[3]),       .c(c3), .s(s_out[3]), .c_out(c4));
    fa fa4 (.a(a_shift[4]), .b(s_complement[4]),       .c(c4), .s(s_out[4]), .c_out(c5));
    fa fa5 (.a(a_shift[5]), .b(s_complement[5]),       .c(c5), .s(s_out[5]), .c_out(c6));
    fa fa6 (.a(a_shift[6]), .b(s_complement[6]),       .c(c6), .s(s_out[6]), .c_out(c7));
    fa fa7 (.a(a_shift[7]), .b(s_complement[7]),       .c(c7), .s(s_out[7]), .c_out(c8));
    fa fa8 (.a(a_shift[8]), .b(s_complement[8]),       .c(c8), .s(overflow),  .c_out(x));

endmodule