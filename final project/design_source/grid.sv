//-------------------------------------------------------------------------
//    grid.sv                                                            --
//    Kathryn Thompson And Frank Lu                                      --
//    Fall 2024                                                          --
//                                                                       --
//                                                                       --
//    Tetris Grid                                                        --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  grid 
( 
    input  logic [3:0]  block[4],       //instantiate the whole block 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,
    input  logic [9:0]  cur_grid[20],

    // output logic [9:0]  BallX, 
    output logic [9:0]  new_grid[20],
);
    

	 
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
