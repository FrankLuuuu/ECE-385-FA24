//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

//tested BASE BACKGROUND, just the backgrond and ttris board and WORKS
// module  color_mapper ( input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
//                        output logic [3:0]  Red, Green, Blue );
    
//     logic game_on;

//     always_comb
//     begin:Background_on
//         if (DrawX >= 100 && DrawX <= 340) begin
//             game_on = 1'b1;
//         end
//         else begin 
//             game_on = 1'b0;
//         end
//         // if ( (DistX*DistX + DistY*DistY) <= (Size * Size) )
//         //     ball_on = 1'b1;
//         // else 
//         //     ball_on = 1'b0;
//     end 
       
//     //drawing tetriss sign
//     always_comb
//     begin:Draw_backgrond
//         if ((game_on == 1'b1)) begin 
//             Red = 4'h0;             //game background
//             Green = 4'h0;
//             Blue = 4'h7;
//         end       
//         else begin 
//             Red = 4'h1;             //game background
//             Green = 4'h0;
//             Blue = 4'h4;
//             // this does the gradient from lab 6.2
//             // Red = 4'hf - DrawX[9:6]; 
//             // Green = 4'hf - DrawX[9:6];
//             // Blue = 4'hf - DrawX[9:6];
//         end      
//     end 
// endmodule


// MIGHT BE A SOURCE OF ERROR, I FORGOT IF SYSTEM VERILOG IS &&/|| OR &/|


// //shorter just for showing the background
module color_mapper (   input logic [9:0]   DrawX, DrawY, 
                        input logic         paused,
                        input logic [2:0]   next_block,
                        input logic [9:0]   score,
                        input logic [2:0]   grid[20][10],

                        output logic [3:0]  Red, Green, Blue);
    
    // logic game_on;
    
    //logic for the tetris sign
    int tetris_sign_X, tetris_sign_Y, score_time_X;
    assign tetris_sign_X = 400; //9'h190;     //400 in dec
    assign tetris_sign_Y = 80;  //9'h50;      //80 in dec
    // assign score_time_X = 400;  //9'h50;      //80 in dec

    //not entirely sure if this is correct, but i did this to get the row and color but i didn't know how to
    //  call a function in the if statement but i needed the color and row but didn't know how to do an if
    //  statement outside of the always__
    logic [9:0] loc_in_sign_X, loc_in_sign_Y;
    assign loc_in_sign_X = DrawX - tetris_sign_X;    //real
    assign loc_in_sign_Y = DrawY - tetris_sign_Y;    //real
    
    logic [9:0] loc_in_sign_X_scaled, loc_in_sign_Y_scaled;
    assign loc_in_sign_X_scaled = loc_in_sign_X / 3;   //caled doen
    assign loc_in_sign_Y_scaled = loc_in_sign_Y / 3;    //scled down

    logic [9:0] color_index;
    assign color_index = loc_in_sign_X / 30;        // divide by 10 for letter, divide by 3 for scale

    logic [59:0] char_pixels_ret;
    tetris_font_rom da_row( 
        .addr(loc_in_sign_Y_scaled[3:0]),      //this might be wrong, got confused with int v logic and slicing
        .data(char_pixels_ret));    // get the pixel data
	 
    logic [11:0] color_pixels_ret;
    tetris_font_color da_color(
        .addr(color_index[2:0]),
        .color(color_pixels_ret));


    //score sign logic
    logic [3:0] loc_in_score_Y;
    // assign loc_in_score_time_X = DrawX - score_time_X;    //real
    assign loc_in_score_Y = DrawY - 150;    //real

    logic [55:0] score_pixels_ret;
    score_font_rom da_score(
        .addr(loc_in_score_Y[3:0]),
        .data(score_pixels_ret));


    //time sign logic
    logic [9:0] loc_in_time_Y;
    // assign loc_in_time_X = DrawX - tetris_sign_X;    //real
    assign loc_in_time_Y = DrawY - 168;    //real

    logic [47:0] time_pixels_ret;
    time_font_rom da_time(
        .addr(loc_in_time_Y[3:0]),
        .data(time_pixels_ret));


   //next block sign logic
    logic [9:0] loc_in_next_block_Y;
    // assign loc_in_time_X = DrawX - tetris_sign_X;    //real
    assign loc_in_next_block_Y = DrawY - 186;    //real

    logic [95:0] next_block_pixels_ret;
    next_block_font_rom da_next(
        .addr(loc_in_next_block_Y[3:0]),
        .data(next_block_pixels_ret));

    //block boundry logic
    int block_boundry_X, block_boundry_Y;
    assign block_boundry_X = (DrawX - 100) % 24;    //blck size is 24
    assign block_boundry_Y = DrawY % 24;

    //block boundry logic (next block)
    int block_boundry_X_next, block_boundry_Y_next;
    assign block_boundry_X_next = (DrawX - 400) % 30;    //blck size is 24
    assign block_boundry_Y_next = (DrawY - 220) % 30;

    
    //mach anc logic for the tetris grid
    //what we need, the block x and y coordinate
    int tetris_block_x, tetris_block_y;
    assign tetris_block_x = (DrawX - 100) / 24;
    assign tetris_block_y = DrawY / 24;

    int block_index;
    assign block_index = grid[tetris_block_y][tetris_block_x];

    //get the color
    int block_color_ret;
    tetris_block_color da_block_color(
        .addr(block_index[2:0]),
        .color(block_color_ret)
    );

    //////////////////////////////////////////////////////////////////////////////

    //LOGIC FOR THE SCORE NUMBERS 
    // logic [9:0] loc_in_score_num_Y;
    // // assign loc_in_score_time_X = DrawX - score_time_X;    //real
    // assign loc_in_score_Y = DrawY - 150;    //real
    //assume that score is passed into collor mapper
    int thousand, hundred, ten, one;
    assign thousand = score / 1000;
    assign hundred = score / 100;
    assign ten = score / 10;
    assign one = score % 10;

    int thousandplace, hundredplace, tenplace, oneplace;
    assign thousandplace    = DrawX - 456;
    assign hundredplace     = DrawX - 464;
    assign tenplace         = DrawX - 472;
    assign oneplace         = DrawX - 480;

    int score_row;
    assign score_row = DrawY -150;



    logic [7:0] score_thousand_pixels_ret;
    number_font_rom da_thousand_score(
        .addr((thousand*10)+score_row),
        .data(score_thousand_pixels_ret));
    
    logic [7:0] score_hundred_pixels_ret;
    number_font_rom da_hundred_score(
        .addr((hundred*10)+score_row),
        .data(score_hundred_pixels_ret));

    logic [7:0] score_ten_pixels_ret;
    number_font_rom da_ten_score(
        .addr((ten*10)+score_row),
        .data(score_ten_pixels_ret));

    logic [7:0] score_one_pixels_ret;
    number_font_rom da_one_score(
        .addr((one*10)+score_row),
        .data(score_one_pixels_ret));

    //bext bloxk actual block 
    // logic [9:0] color_next_block_index;
    // assign color_next_block_index = D;        // divide by 10 for letter, divide by 3 for scale
    logic [9:0] real_loc_in_next_block_X, real_loc_in_next_block_Y;
    assign real_loc_in_next_block_X = DrawX -430;   //loc based on top left corner
    assign real_loc_in_next_block_Y = DrawY -250;


    logic [3:0] char_block_pixels_ret;
    tetris_block_rom da_block_row( 
        .addr((BLOCK_NEXT_ID*10) +(real_loc_in_next_block_Y / 30)),     //TODO: must add block next next id
        .data(char_block_pixels_ret));    // get the pixel data
	 
    logic [11:0] color_block_pixels_ret;
    tetris_block_color da_block_color(
        .addr(BLOCK_NEXT_ID),            //TODO: this must change into the next block index
        .color(color_block_pixels_ret));

    // // coordinats of tetris sign
    // int start_x, start_y;
    // assign start_x = 140;
    // assign start_y = 140;

    // //lock in tetris sign
    // logic [9:0] start_loc_x, start_loc_y;
    // assign start_loc_x = DrawX - start_x;
    // assign start_loc_y = DrawY - start_y;

    // // pixel locatecion in sign
    // logic [9:0] loc_in_start_X_scaled, loc_in_start_Y_scaled;
    // assign loc_in_start_X_scaled = start_loc_x / 6;   //caled doen
    // assign loc_in_start_Y_scaled = start_loc_y / 6;    //scled down

    // logic [9:0] color_index;
    // assign color_index = start_loc_x / 60;        // divide by 10 for letter, divide by 3 for scale

    // logic [59:0] start_char_pixels_ret;
    // tetris_font_rom da_start_row( 
    //     .addr(loc_in_start_Y_scaled[3:0]),      //this might be wrong, got confused with int v logic and slicing
    //     .data(start_char_pixels_ret));    // get the pixel data
	 
    // logic [11:0] start_color_pixels_ret;
    // tetris_font_color da_start_color(
    //     .addr(color_index[2:0]),
    //     .color(start_color_pixels_ret));


    // logic [9:0] start_press_x, start_press_y;
    // assign start_press_x = DrawX - 252; 
    // assign start_press_y = DrawY - 275;

    // logic [135:0] press_p_pixels_ret;
    // tetris_font_rom da_start_row( 
    //     .addr(start_press_y[3:0]),      //this might be wrong, got confused with int v logic and slicing
    //     .data(press_p_pixels_ret));    // get the pixel data
	 

    //game over math
    int pause_x, pause_y;
    assign pause_x = 104;
    assign pause_y = 140;

    //loc in GameOver sign
    logic [9:0] pause_loc_x, pause_loc_y;
    assign pause_loc_x = DrawX - pause_x;
    assign pause_loc_y = DrawY - pause_y;

    // pixel locatecion in sign
    logic [9:0] loc_in_pause_X_scaled, loc_in_pause_Y_scaled;
    assign loc_in_pause_X_scaled = pause_loc_x / 6;   //caled doen
    assign loc_in_pause_Y_scaled = pause_loc_y / 6;    //scled down

    // logic [9:0] color_index;
    // assign color_index = pause_loc_x / 60;        // divide by 10 for letter, divide by 3 for scale

    logic [71:0] pause_char_pixels_ret;
    tetris_font_rom da_pause_row( 
        .addr(loc_in_pause_Y_scaled[3:0]),      //this might be wrong, got confused with int v logic and slicing
        .data(pause_char_pixels_ret));    // get the pixel data
	 


    logic [9:0] pause_press_x, pause_press_y;
    assign pause_press_x = DrawX - 252; 
    assign pause_press_y = DrawY - 275;

    logic [135:0] press_p_pixels_ret;
    press_p_font_rom da_pause_row( 
        .addr(pause_press_y[3:0]),      //this might be wrong, got confused with int v logic and slicing
        .data(press_p_pixels_ret));    // get the pixel data
	 



    // always_comb
    // begin:Draw_startscreen
    //     //#TODO: comment out all hardcodin for the game background, it is now in the block color palatee, so if we 
    //     //  assign it directly it is hard coding or doing extra work

    // end 



    always_comb
    begin
        //#TODO: comment out all hardcodin for the game background, it is now in the block color palatee, so if we 
        //  assign it directly it is hard coding or doing extra work
        
        // if (startscreen == 1) begin:Draw_startscreen
        //     //tetris sign
        //     if ((DrawX >=140 && DrawX < 500) && (DrawY >=140 && DrawY < 200) && start_char_pixels_ret[59-loc_in_start_X_scaled]) begin 
        //         Red = start_color_pixels_ret[11:8];   //tetris sign
        //         Green = start_color_pixels_ret[7:4];
        //         Blue = start_color_pixels_ret[3:0];
        //     end 
            
        //     //outline tetris blcok
        //     else if (((DrawX == 100 || DrawX == 540) && (DrawY >=100 && DrawY <= 240)) || ((DrawX >= 100 && DrawX <= 540) && (DrawY == 100 || DrawY == 240))) begin
        //         Red = 4'h0;                     // aoutline the tetris
        //         Green = 4'h8;
        //         Blue = 4'hf;
        //     end

        //     //draw prss p to play
        //     else if ((DrawX >= 252 && DrawX < 388) && DrawY >=140 && DrawY < 200 && press_p_pixels_ret[135-start_press_x]) begin
        //         Red = 4'hf;
        //         Green = 4'hf;
        //         Blue = 4'hf;
        //     end
        //     // boxw = 440, tetrisw = 360 (x6) tetrish = 60, boxh = 140
            
        //     //add logic for "press P to play"
        // end
        if (paused) begin:game_over_screen
            // Game over sign is 432 pixels
            if ((DrawX >=104 && DrawX < 536) && (DrawY >=140 && DrawY < 200) && pause_char_pixels_ret[71-pause_press_x]) begin 
                Red = 4'hf;   //tetris sign
                Green = 4'hf;
                Blue = 4'hf;
            end 
            
            // //outline tetris blcok
            // else if (((DrawX == 100 || DrawX == 540) && (DrawY >=100 && DrawY <= 240)) || ((DrawX >= 100 && DrawX <= 540) && (DrawY == 100 || DrawY == 240))) begin
            //     Red = 4'h0;                     // aoutline the tetris
            //     Green = 4'h8;
            //     Blue = 4'hf;
            // end

            //draw prss p to play
            else if ((DrawX >= 252 && DrawX < 388) && DrawY >=275 && DrawY < 285 && press_p_pixels_ret[135-start_press_x]) begin
                Red = 4'hf;
                Green = 4'hf;
                Blue = 4'hf;
            end
            else begin
                Red = 4'h0;                     // aoutline the game
                Green = 4'h8;
                Blue = 4'hf;
            end

        end
        else begin:Draw_game_screen
            if (DrawX >= 100 && DrawX < 340) begin  
                //block boundry logic
                if (block_boundry_X == 0 || block_boundry_Y == 0) begin
                    Red     = 4'h0;                     // aoutline the blocks
                    Green   = 4'h2;
                    Blue    = 4'hf;
                end

                //extra, not needed, done by the following block
                // //outline the game
                // if (DrawY == 0 || DrawY == 479) begin
                //     Red = 4'h0;                     // aoutline the game
                //     Green = 4'h8;
                //     Blue = 4'hf;
                // end

                //draw block
                else begin
                    Red     = block_color_ret[11:8];                     //game background
                    Green   = block_color_ret[7:4];
                    Blue    = block_color_ret[3:0];
                end
            end

            //game logic here
        
            //outline the game
            else if (DrawX == 99 || DrawX == 100 || DrawX == 340 || DrawX == 341 || DrawY == 0 || DrawY == 479 || DrawX == 639) begin
                Red = 4'h0;                     // aoutline the game
                Green = 4'h8;
                Blue = 4'hf;
            end

            else if ((DrawX >=400 && DrawX < 580) && (DrawY >=80 && DrawY < 128) && char_pixels_ret[59-loc_in_sign_X_scaled]) begin 
                Red = color_pixels_ret[11:8];   //tetris sign
                Green = color_pixels_ret[7:4];
                Blue = color_pixels_ret[3:0];
            end  

            else if ((DrawX >=400 && DrawX < 456) && (DrawY >=150 && DrawY < 170) && score_pixels_ret[55-loc_in_sign_X]) begin 
                Red = 4'hf;   //Score sign
                Green = 4'hf;
                Blue = 4'hf;
            end  

            ///////////////////////////////

            else if ((DrawX >=456 && DrawX < 464) && (DrawY >=150 && DrawY < 160) && score_thousand_pixels_ret[7-thousandplace]) begin 
                Red = 4'hf;   //Score thousand sign
                Green = 4'hf;
                Blue = 4'hf;
            end 
            else if ((DrawX >=464 && DrawX < 472) && (DrawY >=150 && DrawY < 160) && score_hundred_pixels_ret[7-hundredplace]) begin 
                Red = 4'hf;   //Score hundred sign
                Green = 4'hf;
                Blue = 4'hf;
            end 
            else if ((DrawX >=472 && DrawX < 480) && (DrawY >=150 && DrawY < 160) && score_ten_pixels_ret[7-tenplace]) begin 
                Red = 4'hf;   //Score ten sign
                Green = 4'hf;
                Blue = 4'hf;
            end 
            else if ((DrawX >=480 && DrawX < 488) && (DrawY >=150 && DrawY < 160) && score_one_pixels_ret[7-oneplace]) begin 
                Red = 4'hf;   //Score one sign
                Green = 4'hf;
                Blue = 4'hf;
            end 

            ///////////////////////////////

            // else if ((DrawX >=400 && DrawX < 448) && (DrawY >=168 && DrawY < 188) && time_pixels_ret[47-loc_in_sign_X]) begin 
            //     Red = 4'hf;   //Time sign
            //     Green = 4'hf;
            //     Blue = 4'hf;
            // end  

            else if ((DrawX >=400 && DrawX < 496) && (DrawY >=186 && DrawY < 206) && next_block_pixels_ret[95-loc_in_sign_X]) begin 
                Red = 4'hf;   //next block sign
                Green = 4'hf;
                Blue = 4'hf;
            end  

            else if (((DrawX > 400 && DrawX < 580) && (DrawY > 220 && DrawY < 400))) begin
                if ((DrawX >= 430 && DrawX < 550) && (DrawY >= 250 && DrawY < 370) && (char_block_pixels_ret[3 - (real_loc_in_next_block_X / 30)])) begin
                    Red     = color_block_pixels_ret[11:8];
                    Green   = color_block_pixels_ret[7:4];
                    Blue    = color_block_pixels_ret[3:0];
                end
                else if (block_boundry_X_next == 0 || block_boundry_Y_next == 0) begin
                    Red = 4'h0;                     // aoutline the blocks
                    Green = 4'h2;
                    Blue = 4'hf;
                end
                else begin
                    //#TODO: comment out all hardcodin for the game background, it is now in the block color 
                    //  palatee, so if we assign it directly it is hard coding or doing extra work
                    //
                    Red = 4'h0;                     //game background
                    Green = 4'h0;
                    Blue = 4'h7;
                end
            end

            else if (((DrawX == 400 || DrawX == 580) && (DrawY >= 220 && DrawY <= 400)) || ((DrawX >= 400 && DrawX <= 580) && (DrawY == 220 || DrawY == 400))) begin
                Red = 4'h0;                     // aoutline the game
                Green = 4'h8;
                Blue = 4'hf;
            end

            else begin 
                Red = 4'h1;                     // background
                Green = 4'h0;
                Blue = 4'h4;
            end
        end
    end 


// want the tetris sign to be centered in the 300, 340+60 = 400 -580

// 300m pixels left on the rifht signed
// 6 letters each w a min of 10 pixels or 60 total
// try x3 first for tetris of 180 w x 48 h

endmodule