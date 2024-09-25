// change
module fa (input logic a, b, c,
			output logic s, c_out);

	always_comb begin	//procedure block for combinational logic
			s = a ^ b ^ c;	//note: blocking assignment (=)
			c_out = (a & b) | (b & c) | (a & c);
	end

endmodule

module ripple_adder_4 (input logic [3:0] a, b, 
						input logic c_in,
						output logic [3:0] s,
						output logic c_out);

	logic c1, c2, c3; 	//the "wire" that connects in between the adders

	fa fa0 (.a(a[0]), .b(b[0]), .c(c_in), .s(s[0]), .c_out(c1));
	fa fa1 (.a(a[1]), .b(b[1]), .c(c1), .s(s[1]), .c_out(c2));
	fa fa2 (.a(a[2]), .b(b[2]), .c(c2), .s(s[2]), .c_out(c3));
	fa fa3 (.a(a[3]), .b(b[3]), .c(c3), .s(s[3]), .c_out(c_out));

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

	logic c4, c8, c12; //the "wire" that connects in between the adders

	ripple_adder_4 ra4_0 (  .a(a[3:0]),   .b(b[3:0]), .c_in(cin),   .s(s[3:0]),   .c_out(c4));
	ripple_adder_4 ra4_1 (  .a(a[7:4]),   .b(b[7:4]),  .c_in(c4),   .s(s[7:4]),   .c_out(c8));
	ripple_adder_4 ra4_2 ( .a(a[11:8]),  .b(b[11:8]),  .c_in(c8),  .s(s[11:8]),  .c_out(c12));
	ripple_adder_4 ra4_3 (.a(a[15:12]), .b(b[15:12]), .c_in(c12), .s(s[15:12]), .c_out(cout));

endmodule