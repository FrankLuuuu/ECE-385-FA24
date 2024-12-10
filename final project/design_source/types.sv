// modeled after types.sv from lab 5.2

// TO USE: Include this file in your project, and paste the following 2 lines
//   (uncommented) into whatever file needs to reference the functions &
//   constants included in this file, just after the usual library references:
// `include "types.sv"
// import SLC3_TYPES::*;

`ifndef _SLC3_TYPES__SV 
`define _SLC3_TYPES__SV

package SLC3_TYPES;

// block colors TYPES   
   // Useful constants
    typedef enum logic [2:0] {
        //where color is stored as 4 bits/color red, green, blue
        i_block_color = 12'h55f,         //i block, light blue 
        j_block_color = 12'h00a,         //j block, blue
        j_block_color = 12'hf72,         //l block, orange
        square_color  = 12'hff5,         //square,  yellow
        s_block_color = 12'h0a0,         //s blcok, green
        t_block_color = 12'ha0c,         //t block, purple
        z_block_color = 12'ha00,         //z blcok, red
        bckgnd_color  = 12'h005
   } block_color_t;




endpackage

`endif 