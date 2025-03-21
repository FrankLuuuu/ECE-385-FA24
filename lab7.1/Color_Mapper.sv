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


// module  color_mapper ( input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
//                        output logic [3:0]  Red, Green, Blue );
module  color_mapper (  input logic [9:0] DrawX, DrawY, 
                        input logic [31:0] VGA_RAM [601],
                        output logic [3:0]  Red, Green, Blue );
    
    // logic pixel_on;
    logic [7:0] char_pixels_ret;
    //EDITs:
    // module  color_mapper ( input  logic [9:0] DrawX, DrawY, 
                            //input logic [31:0] registers [601],       //lowkey this gotta be massive wrong,BUT is representative
                                                                        //of what i am trying to portray, what i want is the registers 
                                                                        //holding all the characters
                    //    output logic [7:0]  Red, Green, Blue );

    //DrawX                                         //gives the overall pixel x
    //DrawY                                         //gives the overall pixel y

    int char_row, char_col;

    assign char_row = DrawY / 16;                       //gives the row of the character on the screen
    assign char_col = DrawX / 8;                        //gives the col of the character on the screen

    int pixel_row, pixel_col;

    assign pixel_row = DrawY % 16;                      //gives the pixel row of the character
    assign pixel_col = DrawX % 8;                       //gives the pixel col of the character

    int reg_in_row, cur_reg, char_in_reg;

    assign reg_in_row = DrawX / 32;                     //gives the register number of current row
    assign cur_reg = char_row * 20 + reg_in_row;        //gives the register number
    assign char_in_reg = char_col % 4;                  //this returns the which char of the reg it is 
                                                        //  (REMEMBER LITTLE ENDIAN!!  04030201 on 
                                                        //  screen if 0x01020304 in reg) 

    logic [31:0] register;
    logic [7:0] character;
    logic [3:0] bkg_b, bkg_g, bkg_r, fgd_b, fgd_g, fgd_r;

    //VGA RAM is what Zuofu called the 600 reg in lecture
    assign register = VGA_RAM[cur_reg];                             //get the register of pixel

    assign character = register[char_in_reg * 8 +: 8];  //get the content of the register

    //below is the logic that grabs the collors frosm the contral register
    logic [31:0] control_reg;

    assign control_reg = VGA_RAM[600];
    assign bkg_b = control_reg[4:1];
    assign bkg_g = control_reg[8:5];
    assign bkg_r = control_reg[12:9];
    assign fgd_b = control_reg[16:13];
    assign fgd_g = control_reg[20:17];
    assign fgd_r = control_reg[24:21];

    font_rom da_char( 
        .addr((character[6:0] * 16) + pixel_row),
        .data(char_pixels_ret));    // get the pixel data

    logic pixel;

    assign pixel = char_pixels_ret[7 - pixel_col];  // get 0 or 1 for pixel

    always_comb
    begin:pixel_on_proc
        //check for inversion
        if (character[7] == 1'b1) begin //inverted
            if (pixel == 1'b1) begin
                Red = bkg_r; 
                Green = bkg_g;
                Blue = bkg_b;
            end else begin
                Red = fgd_r;
                Green = fgd_g;
                Blue = fgd_b;
            end
        end else begin
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
     end 

//     always_comb
//     begin:text_mode
//         //pixel on is foreground (normal colllor)
//         if ((pixel_on == 1'b1)) begin 
//             Red = fgd_r;
//             Green = fgd_g;
//             Blue = fgd_b;
//         end       
//         //pixel off is background (inverted colllor)
//         else begin 
//             Red = bkg_r; 
//             Green = bkg_g;
//             Blue = bkg_b;
//         end      
//     end
endmodule
