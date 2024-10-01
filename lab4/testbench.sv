module testbench();

timeunit 1ns;
timeprecision 1ns;

logic rab, run;
logic [7:0] sw_input;

bit clk;

logic [7:0] hex_seg;
logic [3:0] hex_grid;
logic [7:0] A, B;
logic X;

// logic [7:0] ans_a;
// logic [7:0] ans_b;
always #1ns clk = ~clk;

multiplier_toplevel test_multiplier(
    .clk(clk),
    .rab(rab),
    .run(run),
    .sw_input(sw_input),
    .hex_seg(hex_seg),
    .hex_grid(hex_grid),
    .A(A),
    .B(B),
    .X(X)
);

//initial begin: CLOCK_INITIALIZATION
//    clk = 1;
//end

//always begin: CLOCK_GENERATION
//    #1 clk = ~clk;
//end

initial begin: TEST_VECTORS
    
    rab <= 1;
    sw_input = 8'h02;
    run = 1'b0;
    X = 1'b0;
    
    @(posedge clk);
    
    rab = 1'b0;
    
    @(posedge clk);
    rab = 1'b1;
    
    repeat (4) @(posedge clk);
    rab = 1'b0;
    
    repeat (6) @(posedge clk);
    
    sw_input = 8'h02;
    
    repeat (2) @(posedge clk);
    run = 1'b1;
    
    repeat (4) @(posedge clk);
    run = 1'b0;
    
    repeat (24) @(posedge clk);
    sw_input = 8'hFE;
    
    repeat (4) @(posedge clk);
    run = 1'b1;
    
    repeat (4) @(posedge clk);
    run = 1'b0;
    
    repeat (24) @(posedge clk);
    sw_input = 8'h02;
    
    repeat (4) @(posedge clk);
    run = 1'b1;
    
    repeat (4) @(posedge clk);
    run = 1'b0;
    
    repeat (24) @(posedge clk);
    sw_input = 8'hFE;
    
    repeat (4) @(posedge clk);
    run = 1'b1;
    
    repeat (4) @(posedge clk);
    run = 1'b0;

end

endmodule
