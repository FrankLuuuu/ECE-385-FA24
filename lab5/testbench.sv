module testbench();

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic reset;
logic run_i;
logic continue_i;
logic [15:0] sw_i;

logic [15:0] led_o;
logic [7:0]  hex_seg_left;
logic [3:0]  hex_grid_left;
logic [7:0]  hex_seg_right;
logic [3:0]  hex_grid_right;

always begin: CLOCK_GENERATION
    #1 clk = ~clk;
end

initial begin: CLOCK_INITIALIZATION
    clk = 1;
end

processor_top test_lc3(.*);

initial begin: TEST
    
    reset = 1;
    repeat(150) @(posedge clk);
    reset <= 0;
    
    repeat(150) @(posedge clk);
    sw_i = 16'h000b;
    
    repeat(150) @(posedge clk);
    run_i <= 1;
    
    repeat(150) @(posedge clk);
    run_i <= 0;
    
    repeat(150) @(posedge clk);
    // sw_i = 16'h1357;
    
    repeat(1000000) @(posedge clk);
    continue_i <= 1;
    
    repeat(1000000) @(posedge clk);
    continue_i <= 0;
    
    repeat(1000000) @(posedge clk);
    continue_i <= 1;
    
    repeat(1000000) @(posedge clk);
    continue_i <= 0;
    
end

endmodule