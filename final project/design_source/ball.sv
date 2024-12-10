//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf     03-01-2006                           --
//                                  03-12-2007                           --
//    Translated by Joe Meng        07-07-2013                           --
//    Modified by Zuofu Cheng       08-19-2023                           --
//    Modified by Satvik Yellanki   12-17-2023                           --
//    Fall 2024 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI Lab                                --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


// module  ball 
// ( 
//     input  logic        Reset, 
//     input  logic        frame_clk,
//     input  logic [7:0]  keycode,

//     output logic [9:0]  BallX, 
//     output logic [9:0]  BallY, 
//     output logic [9:0]  BallS 
// );


//this module determines the MOVEMENT of the sprite / block only
//  color will still be determined in the color mapper file
module block(
    //for timing reset and keyboard input
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,

    //this is used to determine the current sprite (block)
    input  logic [2:0]  block_index,
    input  logic [1:0]  rotate,
    input  logic [11:0] grid,

    //
    output logic [9:0]  BlockX, 
    output logic [9:0]  BlockY, 
);
    
    //colors:
    //https://studio.code.org/projects/applab/qiyLvNCBDuOYbaBB8oe0isTwNDYTOeGA5cpWlhHNTzM
    //referred to types.sv from lab5.2
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

    //keycodes:
    typedef enum logic [] {
        //this is where i store the keycodes for readability
        move_left  = 8'h1A,     //W, up
        move_right = 8'h16,     //S, down  
        move_down  = 8'h04,     //A, left
        rotate     = 8'h07,     //D, right
        //add more codes for the pause (p), continue (c)
        // pause      = 
    }


    //find out if variables reset or if the value is the same even as things change
    //  aka, does the value of rotate get reset each time?
	// 

    parameter [9:0] grid[20];
    parameter [9:0] 


    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    logic [9:0] Ball_X_Motion;
    logic [9:0] Ball_X_Motion_next;
    logic [9:0] Ball_Y_Motion;
    logic [9:0] Ball_Y_Motion_next;

    logic [9:0] Ball_X_next;
    logic [9:0] Ball_Y_next;

    //i think this sets to always in motion, how to set to move once and only once?
    //instead of motion, make place position
    always_comb begin
        Ball_Y_Motion_next = Ball_Y_Motion; // set default motion to be same as prev clock cycle 
        Ball_X_Motion_next = Ball_X_Motion;

        //modify to control ball motion with the keycode
        //these are the buttons right? I can't do w or s, so im reolcaing those with b and c
        if (keycode == 8'h1A) 
        begin                                               //up        W is 26
            Ball_Y_Motion_next = -10'd1;                    //          1 y up
            Ball_X_Motion_next = 10'd0;
        end 
        else if (keycode == 8'h16) 
        begin                                               //down      S is 22
            Ball_Y_Motion_next = 10'd1;                     //          1 y down
            Ball_X_Motion_next = 10'd0;
        end 
        else if (keycode == 8'h04)  
        begin                                               //left      A is 4   
            Ball_X_Motion_next = -10'd1;                    //          1 x left
            Ball_Y_Motion_next = 10'd0;
        end 
        else if (keycode == 8'h07) 
        begin                                               //right     D is 7
            Ball_X_Motion_next = 10'd1;                     //          1 x right
            Ball_Y_Motion_next = 10'd0;
        end 
        

        if ( (BallY + BallS) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
        begin
            Ball_Y_Motion_next = (~ (Ball_Y_Step) + 1'b1);  // set to -1 via 2's complement.
        end
        else if ( (BallY - BallS) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
        begin
            Ball_Y_Motion_next = Ball_Y_Step;
        end 

        //fill in the rest of the motion equations here to bounce left and right
        else if ( (BallX + BallS) >= Ball_X_Max )  // Ball is at the right edge, BOUNCE!
        begin
            Ball_X_Motion_next = (~ (Ball_X_Step) + 1'b1);  // set to -1 via 2's complement.
        end
        else if ( (BallX - BallS) <= Ball_X_Min )  // Ball is at the left edge, BOUNCE!
        begin
            Ball_X_Motion_next = Ball_X_Step;
        end  
        //done
        /*
        TODO: how to get rid of inferrred latch? what to do in this case? would ball motion next 
        not just be ball motion next?
        */
        ////////// wont be any inferred latch bc of lines 49 & 50
    end

    assign BallS = 16;  // default ball size
    assign Ball_X_next = (BallX + Ball_X_Motion_next);
    assign Ball_Y_next = (BallY + Ball_Y_Motion_next);
   
    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (Reset)
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd1; //Ball_X_Step;
            
			BallY <= Ball_Y_Center;
			BallX <= Ball_X_Center;
        end
        else 
        begin 

			Ball_Y_Motion <= Ball_Y_Motion_next; 
			Ball_X_Motion <= Ball_X_Motion_next; 

            BallY <= Ball_Y_next;  // Update ball position
            BallX <= Ball_X_next;
			
		end  
    end


    
      
endmodule
