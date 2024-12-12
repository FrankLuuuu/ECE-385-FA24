//-------------------------------------------------------------------------
//    Block.sv                                                            --
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

//things to check if there are bugs:
//  grid should never be accessed without BlockX or BlockY (i and j a always relatime)
//  conditionals should never be just i and j, like above they need BlockX and BlockY to not be relative
//  check bounds, if grid access unaviailable values, like grid[20][1], 20 is out of bounds
//  SYNTAX ._.

//thngs to change:
//  I never set block ID to stationary if down no longer works              DONE
//      NOTE: this only occurs on down otherwise it can still work
//  i have no game logic (frank has) like score, time, line clearing 
//  I do not have pause implemented, nor have i tested the start screen
//      NOTE: pause will simple be a new keycodes (P for pause, R for 
//              resume) that set the time to freeze, and block moving to
//              not be active
//      NOTE: Resume muste be differet as it makes logic easier to resume
//              unless there is a variable that toggles when paused or 
//              played



module  Block 
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,

    output logic [9:0]  BlockX,     //x cordinage
    output logic [9:0]  BlockY,     //y coordinate
    output logic [9:0]  BlockID,    //index of block
    output logic [1:0]  BlockR,      //block rotation      

    output logic [3:0]  grid[20][10]
    
);
    
    //grab the current block
    logic [3:0] block_ret[4];
    tetris_block_rom cur_block(
        .addr((BlockID[2:0]*4)+BlockR),
        .data(block_ret)
    );

    //grab the rotated block
    logic [3:0] block_rot1_ret[4];
    tetris_block_rom rot1_block(
        .addr((BlockID[2:0]*4)+(BlockR+1)%4),
        .data(block_rot1_ret)
    );
	 
    parameter [9:0] Block_X_Center=320;  // Center position on the X axis
    parameter [9:0] Block_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Block_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Block_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Block_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Block_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Block_X_Step=1;      // Step size on the X axis
    parameter [9:0] Block_Y_Step=1;      // Step size on the Y axis
    parameter [9:0] Block_Y_Step_Fast=1;      // Step size when s presed



    logic [9:0] Block_X_Motion;
    logic [9:0] Block_X_Motion_next;
    logic [9:0] Block_Y_Motion;
    logic [9:0] Block_Y_Motion_next;

    logic [9:0] Block_X_next;
    logic [9:0] Block_Y_next;

    logic valid_move;
    assign valid_move = 1;

    always_comb begin
        // Block_Y_Motion_next = Block_Y_Motion; // set default motion to be same as prev clock cycle 
        // Block_X_Motion_next = Block_X_Motion;

        //modify to control Block motion with the keycode
        //these are the buttons right? I can't do w or s, so im reolcaing those with b and c
        if (keycode == 8'h1A) 
        begin                                               //up        W is 26
            // Block_Y_Motion_next = -10'd1;                    //          1 y up
            // Block_X_Motion_next = 10'd0;

            //check if valid rotaion
            for (i = 0; i < 4; i++) 
                for (j = 0; j < 4; j++) 
                    if (rot1_block[i][j] == 1) begin
                        //rotate puts block out of bounds
                        if (BlockX +i <0 || BlockX+i >19 || BlockY +j <0 || BlockY+j >19)
                            valid_move = 0;
                        //collition
                        else if (grid[BlockY+i][BlockX+j] >= 8)
                            valid_move = 0;
                    end

            if (valid_move) begin    //still =1
                BlockR = BlockR + 1;
                for (i = 0; i < 4; i++) 
                    for (j = 0; j < 4; j++) begin
                        //clear what was in the space
                        if (block_ret[i][j] == 1)
                            grid[BlockY+i][BlockX+j] = 7;
                        //if a new block goes there, place the block
                        if (rot1_block[i][j] == 1)
                            grid[BlockY+i][BlockX+j] = BlockID;
                    end
            end

        end 
        else if (keycode == 8'h16) 
        begin                                               //down      S is 22
            // Block_Y_Motion_next = 10'd1;                     //          1 y down
            // Block_X_Motion_next = 10'd0;
            for (i = 0; i < 4; i++) 
                for (j = 0; j < 4; j++) 
                    //onky care if there is actually a block
                    if (block_ret[i][j] == 1) begin
                        //check boundry
                        if ((BlockY + i + Block_Y_Step_Fast) >= 20) begin
                            valid_move = 0;      //out of Y boundary
                            grid[BlockY+i][BlockX+j] = grid[BlockY+i][BlockX+j]+8;
                        end

                        // else if ((BlockY + i + Block_Y_Step_Fast) < 20) && (grid[BlockY+i+Block_Y_Step_Fast][BlockX+j]>= 8 && block_ret[i][j] == 1)
                        //     valid_move = 0      //in Y boundary but blcok there
                        else if ((BlockY + i + Block_Y_Step_Fast) < 20) && (grid[BlockY+i+Block_Y_Step_Fast][BlockX+j]>= 8) begin
                            valid_move = 0;      //in Y boundary but block there
                            grid[BlockY+i][BlockX+j] = grid[BlockY+i][BlockX+j]+8;
                        end
                    end
            if (valid_move) begin
                for (i = 3; i > -1; i--) 
                    for (j = 0; j < 4; j++) 
                        if (block_ret[i][j] == 1) begin
                            //set old location empth
                            grid[BlockY+i][BlockX+j] = 7;
                            //fill new spot
                            grid[BlockY+i+Block_Y_Step_Fast][BlockX+j] = BlockID;
                            BlockY = BlockY + Block_Y_Step_Fast;
                        end
            end
        end 
        else if (keycode == 8'h04)  
        begin                                               //left      A is 4   
            // Block_X_Motion_next = -10'd1;                    //          1 x left
            // Block_Y_Motion_next = 10'd0;
            for (i = 0; i < 4; i++) 
                for (j = 0; j < 4; j++) 
                    //can only be invalid if there is a blcok there
                    if (block_ret[i][j] == 1) begin
                        //outside to the left
                        if (BlockX+ j-1 <0 )
                            valid_move = 0;
                        //in bounds but theres a block
                        else if ((BlockX+j-1 >=0) && grid[BlockY+i][BlockX+j - 1] >= 8)
                            valid_move = 0;
                    end

            if valid_move
                for (i = 0; i < 4; i++) 
                    for (j = 0; j < 4; j++) begin
                        grid[BlockY+i][BlockX+j] = 7;     //clear old
                        grid[BlockY+i][BlockX+j-1] = BlockID;
                        BlockX = BlockX - 1;
                    end
                    
        end 
        else if (keycode == 8'h07) 
        begin                                               //right     D is 7
            // Block_X_Motion_next = 10'd1;                     //          1 x right
            // Block_Y_Motion_next = 10'd0;

            for (i = 0; i < 4; i++) 
                for (j = 0; j < 4; j++) 
                    //can only be invalid if there is a blcok there
                    if (block_ret[i][j] == 1) begin
                        //outside to the left
                        if (BlockX+j+1 >= 20 )
                            valid_move = 0;
                        //in bounds but theres a block
                        else if ((BlockX+j+1 < 20) && grid[BlockY+i][BlockX+j + 1] >= 8)
                            valid_move = 0;
                    end

            if valid_move
                for (i = 0; i < 4; i++) 
                    for (j = 3; j > -1; j--) begin
                        grid[BlockY+i][BlockX+j] = 7;     //clear old
                        grid[BlockY+i][BlockX+j-1] = BlockID;
                        BlockX = BlockX + 1;
                    end

        end 

        else if (keycode == 8'h13) begin
            startscreen == 0;
        end
        

        // if ( (BlockY + BlockS) >= Block_Y_Max )  // Block is at the bottom edge, BOUNCE!
        // begin
        //     Block_Y_Motion_next = (~ (Block_Y_Step) + 1'b1);  // set to -1 via 2's complement.
        // end
        // else if ( (BlockY - BlockS) <= Block_Y_Min )  // Block is at the top edge, BOUNCE!
        // begin
        //     Block_Y_Motion_next = Block_Y_Step;
        // end 

        // //fill in the rest of the motion equations here to bounce left and right
        // else if ( (BlockX + BlockS) >= Block_X_Max )  // Block is at the right edge, BOUNCE!
        // begin
        //     Block_X_Motion_next = (~ (Block_X_Step) + 1'b1);  // set to -1 via 2's complement.
        // end
        // else if ( (BlockX - BlockS) <= Block_X_Min )  // Block is at the left edge, BOUNCE!
        // begin
        //     Block_X_Motion_next = Block_X_Step;
        // end  
        //done
        /*
        TODO: how to get rid of inferrred latch? what to do in this case? would Block motion next 
        not just be Block motion next?
        */
        ////////// wont be any inferred latch bc of lines 49 & 50
    end

    // assign BlockS = 16;  // default Block size
    // assign Block_X_next = (BlockX + Block_X_Motion_next);
    // assign Block_Y_next = (BlockY + Block_Y_Motion_next);
   
    // always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    // begin: Move_Block
    //     if (Reset)
    //     begin 
    //         Block_Y_Motion <= 10'd0; //Block_Y_Step;
	// 		Block_X_Motion <= 10'd1; //Block_X_Step;
            
	// 		BlockY <= Block_Y_Center;
	// 		BlockX <= Block_X_Center;
    //     end
    //     else 
    //     begin 

	// 		Block_Y_Motion <= Block_Y_Motion_next; 
	// 		Block_X_Motion <= Block_X_Motion_next; 

    //         BlockY <= Block_Y_next;  // Update Block position
    //         BlockX <= Block_X_next;
			
	// 	end  
    // end


    
      
endmodule
