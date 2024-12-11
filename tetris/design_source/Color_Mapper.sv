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
    logic [9:0] loc_in_score_Y;
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
        .addr(block_index),
        .color(block_color_ret)
    );



    always_comb
    begin:Draw_backgrond
        //#TODO: comment out all hardcodin for the game background, it is now in the block color palatee, so if we 
        //  assign it directly it is hard coding or doing extra work
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

        else if ((DrawX >=400 && DrawX < 448) && (DrawY >=168 && DrawY < 188) && time_pixels_ret[47-loc_in_sign_X]) begin 
            Red = 4'hf;   //Time sign
            Green = 4'hf;
            Blue = 4'hf;
        end  

        else if ((DrawX >=400 && DrawX < 496) && (DrawY >=186 && DrawY < 206) && next_block_pixels_ret[95-loc_in_sign_X]) begin 
            Red = 4'hf;   //next block sign
            Green = 4'hf;
            Blue = 4'hf;
        end  

        else if (((DrawX > 400 && DrawX < 580) && (DrawY > 220 && DrawY < 400))) begin
            if (block_boundry_X_next == 0 || block_boundry_Y_next == 0) begin
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
endmodule

// want the tetris sign to be centered in the 300, 340+60 = 400 -580

// 300m pixels left on the rifht signed
// 6 letters each w a min of 10 pixels or 60 total
// try x3 first for tetris of 180 w x 48 h