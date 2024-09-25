module fa (input logic a, b, c,
			output logic s, c_out);

	always_comb begin	//procedure block for combinational logic
			s = a ^ b ^ c;	//note: blocking assignment (=)
			c_out = (a & b) | (b & c) | (a & c);
	end

endmodule

module select_adder_4 (input logic [3:0] a, b,
						input logic c_in,
						output logic [3:0] s,
						output logic c_out);

    logic c1, c2, c3;
    
    fa fa0 (.a(a[0]), .b(b[0]), .c(c_in),  .s(s[0]),   .c_out(c1));
    fa fa1 (.a(a[1]), .b(b[1]),  .c(c1),  .s(s[1]),   .c_out(c2));
    fa fa2 (.a(a[2]), .b(b[2]),  .c(c2),  .s(s[2]),   .c_out(c3));
    fa fa3 (.a(a[3]), .b(b[3]),  .c(c3),  .s(s[3]), .c_out(c_out));
    
endmodule

module mux (input logic [3:0] s_a,
			input logic [3:0] s_b,
			input logic c_in,
			input logic c_a,
			input logic c_b,
			output logic [3:0] s);

	always_comb begin
		s[0] = (c_in & s_b[0]) | (~c_in & s_a[0]);
		s[1] = (c_in & s_b[1]) | (~c_in & s_a[1]);
		s[2] = (c_in & s_b[2]) | (~c_in & s_a[2]);
		s[3] = (c_in & s_b[3]) | (~c_in & s_a[3]);
	end

endmodule

module select_adder (
	input  logic  [15:0] a, 
    input  logic  [15:0] b,
	input  logic         cin,
	
	output logic  [15:0] s,
	output logic         cout
);

	/* TODO
		*
		* Insert code here to implement a CSA adder.
		* Your code should be completly combinational (don't use always_ff or always_latch).
		* Feel free to create sub-modules or other files. */

	logic c4;
	logic [2:0] c_a;
	logic [2:0] c_b;
	logic [15:0] s_a;
	logic [15:0] s_b;
	
	select_adder_4 sa4_0 (   .a(a[3:0]),   .b(b[3:0]),  .c_in(cin),     .s(s[3:0]),     .c_out(c4));
	select_adder_4 sa4_1a (  .a(a[7:4]),   .b(b[7:4]), .c_in(1'b0),   .s(s_a[7:4]), .c_out(c_a[0]));
	select_adder_4 sa4_1b (  .a(a[7:4]),   .b(b[7:4]), .c_in(1'b1),   .s(s_b[7:4]), .c_out(c_b[0]));
	select_adder_4 sa4_2a ( .a(a[11:8]),  .b(b[11:8]), .c_in(1'b0),  .s(s_a[11:8]), .c_out(c_a[1]));
	select_adder_4 sa4_2b ( .a(a[11:8]),  .b(b[11:8]), .c_in(1'b1),  .s(s_b[11:8]), .c_out(c_b[1]));
	select_adder_4 sa4_3a (.a(a[15:12]), .b(b[15:12]), .c_in(1'b0), .s(s_a[15:12]), .c_out(c_a[2]));
	select_adder_4 sa4_3b (.a(a[15:12]), .b(b[15:12]), .c_in(1'b1), .s(s_b[15:12]), .c_out(c_b[2]));
	
	mux m0 (  .s_a(s_a[7:4]),   .s_b(s_b[7:4]), 					   		     		  .c_in(c4), .c_a(c_a[0]), .c_b(c_b[0]),   .s(s[7:4]));
	mux m1 ( .s_a(s_a[11:8]),  .s_b(s_b[11:8]), 		 			  .c_in((c4 & c_b[0]) | c_a[0]), .c_a(c_a[1]), .c_b(c_b[1]),  .s(s[11:8]));
	mux m2 (.s_a(s_a[15:12]), .s_b(s_b[15:12]), .c_in((((c4 & c_b[0]) | c_a[0]) & c_b[1]) | c_a[1]), .c_a(c_a[2]), .c_b(c_b[2]), .s(s[15:12]));

	always_comb begin
		cout = ((((c4 & c_b[0]) | c_a[0] & c_b[1]) | c_a[1]) & c_b[2]) | c_a[2];
	end

endmodule
