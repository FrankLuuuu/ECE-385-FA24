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

module block
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,

    output logic [2:0]  grid[20][10],
    output logic        startscreen
);

    logic [9:0] Ball_X_Motion;
    logic [9:0] Ball_X_Motion_next;
    logic [9:0] Ball_Y_Motion;
    logic [9:0] Ball_Y_Motion_next;

    integer i, j;
    localparam GRID_HEIGHT = 20;
    localparam GRID_WIDTH  = 10;
    
    always_comb begin
        
        for (i = 0; i < GRID_HEIGHT; i++) 
            for (j = 0; j < GRID_WIDTH; j++) 
                grid[i][j] <= j % 8;


        if (keycode == 8'h13) begin
            startscreen == 0;
        end


        // Ball_Y_Motion_next = Ball_Y_Motion; // set default motion to be same as prev clock cycle 
        // Ball_X_Motion_next = Ball_X_Motion;

        // //modify to control ball motion with the keycode
        // //these are the buttons right? I can't do w or s, so im reolcaing those with b and c
        // if (keycode == 8'h1A) 
        // begin                                               //up        W is 26
        //     Ball_Y_Motion_next = -10'd1;                    //          1 y up
        //     Ball_X_Motion_next = 10'd0;
        // end 
        // else if (keycode == 8'h16) 
        // begin                                               //down      S is 22
        //     Ball_Y_Motion_next = 10'd1;                     //          1 y down
        //     Ball_X_Motion_next = 10'd0;
        // end 
        // else if (keycode == 8'h04)  
        // begin                                               //left      A is 4   
        //     Ball_X_Motion_next = -10'd1;                    //          1 x left
        //     Ball_Y_Motion_next = 10'd0;
        // end 
        // else if (keycode == 8'h07) 
        // begin                                               //right     D is 7
        //     Ball_X_Motion_next = 10'd1;                     //          1 x right
        //     Ball_Y_Motion_next = 10'd0;
        // end 

        // if ( (BallY + BallS) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
        // begin
        //     Ball_Y_Motion_next = (~ (Ball_Y_Step) + 1'b1);  // set to -1 via 2's complement.
        // end
        // else if ( (BallY - BallS) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
        // begin
        //     Ball_Y_Motion_next = Ball_Y_Step;
        // end 

        // //fill in the rest of the motion equations here to bounce left and right
        // else if ( (BallX + BallS) >= Ball_X_Max )  // Ball is at the right edge, BOUNCE!
        // begin
        //     Ball_X_Motion_next = (~ (Ball_X_Step) + 1'b1);  // set to -1 via 2's complement.
        // end
        // else if ( (BallX - BallS) <= Ball_X_Min )  // Ball is at the left edge, BOUNCE!
        // begin
        //     Ball_X_Motion_next = Ball_X_Step;
        // end  
        //done
        /*
        TODO: how to get rid of inferrred latch? what to do in this case? would ball motion next 
        not just be ball motion next?
        */
        ////////// wont be any inferred latch bc of lines 49 & 50
    end

    // assign BallS = 16;  // default ball size
    // assign Ball_X_next = (BallX + Ball_X_Motion_next);
    // assign Ball_Y_next = (BallY + Ball_Y_Motion_next);
   
    // always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    // begin: Move_Ball
    //     if (Reset)
    //     begin 
    //         Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
	// 		Ball_X_Motion <= 10'd1; //Ball_X_Step;
            
	// 		BallY <= Ball_Y_Center;
	// 		BallX <= Ball_X_Center;
    //     end
    //     else 
    //     begin 

	// 		Ball_Y_Motion <= Ball_Y_Motion_next; 
	// 		Ball_X_Motion <= Ball_X_Motion_next; 

    //         BallY <= Ball_Y_next;  // Update ball position
    //         BallX <= Ball_X_next;
			
	// 	end  
    // end


    
      
endmodule
