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

// // this is the working lab 7.1 color mapping code, use to test vram before switching layout
// // module  color_mapper ( input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
// //                        output logic [3:0]  Red, Green, Blue );
// module  color_mapper (  input logic [9:0] DrawX, DrawY, 
//                         input logic [31:0] VGA_RAM [601],
//                         output logic [3:0]  Red, Green, Blue );
    
//     // logic pixel_on;
//     logic [7:0] char_pixels_ret;
//     //EDITs:
//     // module  color_mapper ( input  logic [9:0] DrawX, DrawY, 
//                             //input logic [31:0] registers [601],       //lowkey this gotta be massive wrong,BUT is representative
//                                                                         //of what i am trying to portray, what i want is the registers 
//                                                                         //holding all the characters
//                     //    output logic [7:0]  Red, Green, Blue );

//     //DrawX                                         //gives the overall pixel x
//     //DrawY                                         //gives the overall pixel y

//     int char_row, char_col;

//     assign char_row = DrawY / 16;                       //gives the row of the character on the screen
//     assign char_col = DrawX / 8;                        //gives the col of the character on the screen

//     int pixel_row, pixel_col;

//     assign pixel_row = DrawY % 16;                      //gives the pixel row of the character
//     assign pixel_col = DrawX % 8;                       //gives the pixel col of the character

//     int reg_in_row, cur_reg, char_in_reg;

//     assign reg_in_row = DrawX / 32;                     //gives the register number of current row
//     assign cur_reg = char_row * 20 + reg_in_row;        //gives the register number
//     assign char_in_reg = char_col % 4;                  //this returns the which char of the reg it is 
//                                                         //  (REMEMBER LITTLE ENDIAN!!  04030201 on 
//                                                         //  screen if 0x01020304 in reg) 

//     logic [31:0] register;
//     logic [7:0] character;
//     logic [3:0] bkg_b, bkg_g, bkg_r, fgd_b, fgd_g, fgd_r;

//     //VGA RAM is what Zuofu called the 600 reg in lecture
//     assign register = VGA_RAM[cur_reg];                             //get the register of pixel

//     assign character = register[char_in_reg * 8 +: 8];  //get the content of the register

//     //below is the logic that grabs the collors frosm the contral register
//     logic [31:0] control_reg;

//     assign control_reg = VGA_RAM[600];
//     assign bkg_b = control_reg[4:1];
//     assign bkg_g = control_reg[8:5];
//     assign bkg_r = control_reg[12:9];
//     assign fgd_b = control_reg[16:13];
//     assign fgd_g = control_reg[20:17];
//     assign fgd_r = control_reg[24:21];

//     font_rom da_char( 
//         .addr((character[6:0] * 16) + pixel_row),
//         .data(char_pixels_ret));    // get the pixel data

//     logic pixel;

//     assign pixel = char_pixels_ret[7 - pixel_col];  // get 0 or 1 for pixel

//     always_comb
//     begin:pixel_on_proc
//         //check for inversion
//         if (character[7] == 1'b1) begin //inverted
//             if (pixel == 1'b1) begin
//                 Red = bkg_r; 
//                 Green = bkg_g;
//                 Blue = bkg_b;
//             end else begin
//                 Red = fgd_r;
//                 Green = fgd_g;
//                 Blue = fgd_b;
//             end
//         end else begin
//             if (pixel == 1'b1) begin    //normal
//                 Red = fgd_r;
//                 Green = fgd_g;
//                 Blue = fgd_b;
//             end else begin
//                 Red = bkg_r; 
//                 Green = bkg_g;
//                 Blue = bkg_b;
//             end
//         end
//      end 

// //     always_comb
// //     begin:text_mode
// //         //pixel on is foreground (normal colllor)
// //         if ((pixel_on == 1'b1)) begin 
// //             Red = fgd_r;
// //             Green = fgd_g;
// //             Blue = fgd_b;
// //         end       
// //         //pixel off is background (inverted colllor)
// //         else begin 
// //             Red = bkg_r; 
// //             Green = bkg_g;
// //             Blue = bkg_b;
// //         end      
// //     end
// endmodule












// lab7_2 code for color mapper to account for talking to the BRAM

// Bit         |   31  |   30-24   |   23-20   |   19-16   |  15  |  14-8   |   7-4    |  3-0
// Function    |   IV1 |   CODE1   |  FGD_IDX1 |  BKG_IDX1 |  IV0 |  CODE0  | FGD_IDX0 | BKG_IDX0

// this function definition mmgh fave to be fixed but i passed the fariables that i worked off the assumption that i had
module  color_mapper (  input logic [9:0] DrawX, DrawY, 
                        output logic [10:0] char_index,              // we do not need to pass in all of VRAM, just the specific address?
                        
                        input logic [31:0] color_palatte[8],       //pass color palated 
                        input logic [31:0]  character_word,
                        // input logic [3:0] fgd, bkg,
                        output logic [3:0]  Red, Green, Blue );     // we need access to the color pallate
    
    //EDITs:
    //  i think we need to pass in the color palate and the the vram, or at least the corresponding memeory 
    //  based on the bath, we can move the math out if we need to fix timing

    int char_row, char_col;
    assign char_row = DrawY / 16;                       //gives the row of the character on the screen
    assign char_col = DrawX / 8;                        //gives the col of the character on the screen

    assign char_index = (char_row * 80 + char_col) / 2;       //gives the index of character in rastor order

    int char_in_word;
    assign char_in_word = char_col % 2;

    logic [15:0] character_info;
    assign character_info = character_word[char_in_word*16 +:16];

    logic [6:0] character;
    assign character = character_info[14:8];

    logic [3:0] bkg, fgd;
    assign fgd = character_info[7:4];
    assign bkg = character_info[3:0];

    int pixel_row, pixel_col;
    assign pixel_row = DrawY % 16;                      //gives the pixel row of the character
    assign pixel_col = DrawX % 8;                       //gives the pixel col of the character

    // logic pixel_on;
    logic [7:0] char_pixels_ret;

    font_rom da_char( 
        .addr((character * 16) + pixel_row),
        .data(char_pixels_ret));    // get the pixel data

    logic pixel;
    assign pixel = char_pixels_ret[7 - pixel_col];  // get 0 or 1 for pixel



    // logic [15:0] character_info;
    // logic [3:0] bkg, fgd;
    // logic [7:0] character;
    logic [3:0] bkg_b, bkg_g, bkg_r, fgd_b, fgd_g, fgd_r;

    //below is the logic that grabs the collors frosm the color palatte
    logic [31:0] colorback, colorfor;
    logic [15:0] colorb, colorf;

    assign colorback = color_palatte[bkg/2];          //get the 16 bits of bkg color
    assign colorfor = color_palatte[fgd/2];          //get the 16 bits of fgd color
    assign colorb = colorback[(bkg[0])*16 +:16];          //get the 16 bits of bkg color
    assign colorf = colorfor[(fgd[0])*16 +:16];          //get the 16 bits of fgd color

//    assign colorb = color_palatte[bkg/2][(bkg[0])*16 +:16];          //get the 16 bits of bkg color
//    assign colorf = color_palatte[fgd/2][(fgd[0])*16 +:16];          //get the 16 bits of fgd color

    assign bkg_b = colorb[3:0];
    assign bkg_g = colorb[7:4];
    assign bkg_r = colorb[11:8];
    assign fgd_b = colorf[3:0];
    assign fgd_g = colorf[7:4];
    assign fgd_r = colorf[11:8];
    

    
    always_comb
    begin:pixel_on_proc    
        if (pixel == 1'b1) begin    //normal
            Red = fgd_r;
            Green = fgd_g;
            Blue = fgd_b;
        end else begin
            Red = bkg_r; 
            Green = bkg_g;
            Blue = bkg_b;
        end
    end 
endmodule







// // this is the lab 7.1 color mapping code, use to test bram before switching layout
// // module  color_mapper ( input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
// //                        output logic [3:0]  Red, Green, Blue );
// module  color_mapper (  input   logic [9:0]     DrawX, DrawY, 
//                         input   logic [31:0]    control_reg,
//                         input   logic [31:0]    register,

//                         output  logic [10:0]    cur_reg,
//                         output  logic [3:0]     Red, Green, Blue );


//     int char_row, char_col;
//     assign char_row = DrawY / 16;                       //gives the row of the character on the screen
//     assign char_col = DrawX / 8;                        //gives the col of the character on the screen

//     int reg_in_row, char_in_reg;
//     assign reg_in_row = DrawX / 32;                     //gives the register number of current row
//     assign cur_reg = char_row * 20 + reg_in_row;        //gives the register number
//     assign char_in_reg = char_col % 4;                  //this returns the which char of the reg it is 
//                                                         //  (REMEMBER LITTLE ENDIAN!!  04030201 on 
//                                                         //  screen if 0x01020304 in reg) 



//     logic [3:0] bkg_b, bkg_g, bkg_r, fgd_b, fgd_g, fgd_r;
//     assign bkg_b = control_reg[4:1];
//     assign bkg_g = control_reg[8:5];
//     assign bkg_r = control_reg[12:9];
//     assign fgd_b = control_reg[16:13];
//     assign fgd_g = control_reg[20:17];
//     assign fgd_r = control_reg[24:21];



//     int pixel_row, pixel_col;
//     assign pixel_row = DrawY % 16;                      //gives the pixel row of the character
//     assign pixel_col = DrawX % 8;                       //gives the pixel col of the character

//     logic [7:0] character;
//     assign character = register[char_in_reg * 8 +: 8];  //get the content of the register

//     // logic pixel_on;
//     logic [7:0] char_pixels_ret;
//     font_rom da_char( 
//         .addr((character[6:0] * 16) + pixel_row),
//         .data(char_pixels_ret));    // get the pixel data

//     logic pixel;
//     assign pixel = char_pixels_ret[7 - pixel_col];  // get 0 or 1 for pixel



//     always_comb
//     begin:pixel_on_proc
//         //check for inversion
//         if (character[7] == 1'b1) begin //inverted
//             if (pixel == 1'b1) begin
//                 Red = bkg_r; 
//                 Green = bkg_g;
//                 Blue = bkg_b;
//             end else begin
//                 Red = fgd_r;
//                 Green = fgd_g;
//                 Blue = fgd_b;
//             end
//         end else begin
//             if (pixel == 1'b1) begin    //normal
//                 Red = fgd_r;
//                 Green = fgd_g;
//                 Blue = fgd_b;
//             end else begin
//                 Red = bkg_r; 
//                 Green = bkg_g;
//                 Blue = bkg_b;
//             end
//         end
//      end 
// endmodule