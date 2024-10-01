module testbench();

timeunit 1ns;
timeprecision 1ns;

logic 		clk;
logic		reset;
logic 		run_i; 
logic [15:0] sw_i;

logic 		sign_led;
logic [7:0]  hex_seg_a;
logic [3:0]  hex_grid_a;
logic [7:0]  hex_seg_b;
logic [3:0]  hex_grid_b;

always #1ns clk = ~clk;

adder_toplevel test_adder(.*);

initial begin: TEST_VECTORS
    reset = 1;
    sw_i <= 16'h0000;
    run_i <= 1'b0;
    
    @(posedge clk);

    reset <= 1'b0;
    
    @(posedge clk);
    reset <= 1;
    
    repeat (4) @(posedge clk);
    reset <= 0;
    
    repeat (10) @(posedge clk);
    sw_i <= 16'h0002;
    
    repeat (3) @(posedge clk);
    run_i <= 1'b1;

    repeat (3) @(posedge clk);
    run_i <= 1'b0;
    
    repeat (3) @(posedge clk);
    run_i <= 1'b1;

    repeat (3) @(posedge clk);
    run_i <= 1'b0;
    
    @(posedge clk);
    sw_i <= 16'h0005;
    
    repeat (3) @(posedge clk);
    run_i <= 1'b1;

    repeat (3) @(posedge clk);
    run_i <= 1'b0;

end

endmodule
