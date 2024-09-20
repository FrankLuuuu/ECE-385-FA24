module fa (input logic a, b, c,
			output logic s, c_out);

	always_comb begin	//procedure block for combinational logic
			s = a ^ b ^ c;	//note: blocking assignment (=)
			c_out = (a & b) | (b & c) | (a & c);
	end

endmodule

module lookahead_adder_4 (input logic [3:0] a,
							input logic [3:0] b,
							input logic cin,
							output logic [3:0] s,
							output logic PG,
							output logic GG);

    logic [3:0] g;
    logic [3:0] p;

	always_comb begin

		g = a & b;
		p = a ^ b;
		
		PG = p[0] & p[1] & p[2] & p[3];
		GG = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]);

	end
    
    fa fa0 (.a(a[0]), .b(b[0]), 			    													 .c(cin), .s(s[0]), .c_out());
    fa fa1 (.a(a[1]), .b(b[1]), 										   			 .c((cin & p[0]) | g[0]), .s(s[1]), .c_out());
    fa fa2 (.a(a[2]), .b(b[2]), 							  .c((cin & p[0] & p[1]) | (g[0] & p[1]) | g[1]), .s(s[2]), .c_out());
    fa fa3 (.a(a[3]), .b(b[3]), .c((cin & p[0] & p[1] & p[2]) | (g[0] & p[1] & p[2]) | (g[1] & p[2]) | g[2]), .s(s[3]), .c_out());

endmodule

module lookahead_adder (
	input  logic  [15:0] a, 
    input  logic  [15:0] b,
	input  logic         cin,
	
	output logic  [15:0] s,
	output logic         cout
);

	/* TODO
		*
		* Insert code here to implement a CLA adder.
		* Your code should be completly combinational (don't use always_ff or always_latch).
		* Feel free to create sub-modules or other files. */
		
	logic [15:0] c;
	logic [3:0] P;
	logic [3:0] G;

	lookahead_adder_4 la0 (.a(a[3:0]),     .b(b[3:0]), 																	    .cin(cin),   .s(s[3:0]), .PG(P[0]), .GG(G[0]));
	lookahead_adder_4 la1 (.a(a[7:4]),     .b(b[7:4]), 													    .cin(G[0] | (cin & P[0])),   .s(s[7:4]), .PG(P[1]), .GG(G[1]));
	lookahead_adder_4 la2 (.a(a[11:8]),   .b(b[11:8]), 							     .cin(G[1] | (G[0] & P[1]) | (cin & P[0] & P[1])),  .s(s[11:8]), .PG(P[2]), .GG(G[2]));
	lookahead_adder_4 la3 (.a(a[15:12]), .b(b[15:12]), .cin(G[2] | (G[1] & P[2]) | (G[0] & P[2] & P[1]) | (cin & P[0] & P[1] & P[2])), .s(s[15:12]), .PG(P[3]), .GG(G[3]));

	always_comb begin
	
		cout = G[3] | (G[2] & P[3]) | (G[1] & P[3] & P[2]) | (G[0] & P[3] & P[2] & P[1]) | (cin & P[0] & P[1] & P[2] & P[3]);

	end

endmodule

