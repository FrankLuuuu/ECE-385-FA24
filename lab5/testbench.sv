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
    
   // auto counting
   repeat(5) @(posedge clk);
   sw_i = 16'h009C;
       
   repeat(5) @(posedge clk);

   reset = 1;
   repeat(4) @(posedge clk);
   reset <= 0;    
    
   repeat(5) @(posedge clk);
   run_i <= 1;
    
   repeat(5) @(posedge clk);
   run_i <= 0;

///////////////////////////////////////////////////////////////////

//     // basic io 1
//    repeat(5) @(posedge clk);
//    sw_i = 16'h0003;
       
//    repeat(5) @(posedge clk);

//    reset = 1;
//    repeat(4) @(posedge clk);
//    reset <= 0;
    
//    repeat(5) @(posedge clk);
//    run_i <= 1;
    
//    repeat(5) @(posedge clk);
//    run_i <= 0;
    
//    repeat(50) @(posedge clk);
//    sw_i = 16'h0008;
    
//    repeat(50) @(posedge clk);
//    sw_i = 16'h005d;  
      
//    repeat(50) @(posedge clk);
//    sw_i = 16'h0004;

///////////////////////////////////////////////////////////////////
    
//    // basic io 2
//    repeat(5) @(posedge clk);
//    sw_i = 16'h0006;
       
//    repeat(5) @(posedge clk);

//    reset = 1;
//    repeat(4) @(posedge clk);
//    reset <= 0;    
    
//    repeat(5) @(posedge clk);
//    run_i <= 1;
    
//    repeat(5) @(posedge clk);
//    run_i <= 0;
    
//    repeat(5) @(posedge clk);
//    sw_i = 16'h0008;

//    repeat(50) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;
    
//    repeat(50) @(posedge clk);
//    sw_i = 16'h005d;  

//    repeat(50) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;
      
//    repeat(50) @(posedge clk);
//    sw_i = 16'h0004;

//    repeat(50) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;

///////////////////////////////////////////////////////////////////
    
    // // self-modifying code
    // repeat(5) @(posedge clk);
    // sw_i = 16'h000B;
       
    // repeat(5) @(posedge clk);

    // reset = 1;
    // repeat(4) @(posedge clk);
    // reset <= 0;
        
    // repeat(5) @(posedge clk);
    // run_i <= 1;
    
    // repeat(5) @(posedge clk);
    // run_i <= 0;
    
    // repeat(5) @(posedge clk);
    // sw_i = 16'h0008;

    // repeat(50) @(posedge clk);
    // continue_i <= 1;

    // repeat(5) @(posedge clk);
    // continue_i <= 0;
    
    // repeat(50) @(posedge clk);
    // led_o = 16'hdc03;  
    // repeat(50) @(posedge clk);
    // sw_i = 16'h005d;  

    // repeat(50) @(posedge clk);
    // continue_i <= 1;

    // repeat(5) @(posedge clk);
    // continue_i <= 0;
    
    // repeat(50) @(posedge clk);
    // led_o = 16'hdc04;  
    // repeat(50) @(posedge clk);
    // sw_i = 16'h0004;

    // repeat(50) @(posedge clk);
    // continue_i <= 1;

    // repeat(5) @(posedge clk);
    // continue_i <= 0;
    
    // repeat(50) @(posedge clk);
    // led_o = 16'hdc05;  
    
///////////////////////////////////////////////////////////////////
    
//    // XOR
//    repeat(5) @(posedge clk);
//    sw_i = 16'h0014;
       
//    repeat(5) @(posedge clk);

//    reset = 1;
//    repeat(4) @(posedge clk);
//    reset <= 0;    
    
//    repeat(5) @(posedge clk);
//    run_i <= 1;
    
//    repeat(5) @(posedge clk);
//    run_i <= 0;
    
//    repeat(50) @(posedge clk);
//    sw_i = 16'b0000000000001111;

//    repeat(50) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;
    
//    repeat(50) @(posedge clk);
//    sw_i = 16'b0000000000000110;

//    repeat(50) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;

///////////////////////////////////////////////////////////////////
    
   // multiplication
//    repeat(5) @(posedge clk);
//    sw_i = 16'h0031;
       
//    repeat(5) @(posedge clk);

//    reset = 1;
//    repeat(4) @(posedge clk);
//    reset <= 0;   
    
//    repeat(5) @(posedge clk);
//    run_i <= 1;
    
//    repeat(5) @(posedge clk);
//    run_i <= 0;
    
//    repeat(50) @(posedge clk);
//    sw_i = 16'b0000000000000011;

//    repeat(50) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;
    
//    repeat(50) @(posedge clk);
//    sw_i = 16'b0000000000000010;

//    repeat(50) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;

// ///////////////////////////////////////////////////////////////////
    
//    // sort
//    repeat(5) @(posedge clk);
//    sw_i = 16'h005A;
       
//    repeat(5) @(posedge clk);

//    reset = 1;
//    repeat(4) @(posedge clk);
//    reset <= 0;
    
//    repeat(5) @(posedge clk);
//    run_i <= 1;
    
//    repeat(5) @(posedge clk);
//    run_i <= 0;
    
//    repeat(15) @(posedge clk);
//    sw_i = 16'h0002;

//    repeat(15) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;
    
//    repeat(15) @(posedge clk);
//    sw_i = 16'h0003;

//    repeat(15) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;

//    repeat(15) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;

//    repeat(15) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;

//    repeat(15) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;

//    repeat(15) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;

//    repeat(15) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;

//    repeat(15) @(posedge clk);
//    continue_i <= 1;

//    repeat(5) @(posedge clk);
//    continue_i <= 0;
    
end

endmodule