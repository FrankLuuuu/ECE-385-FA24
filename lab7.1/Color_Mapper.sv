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


module  color_mapper ( input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
                       output logic [3:0]  Red, Green, Blue );
    
    logic pixel_on;
    logic char_pixels_ret;
    //EDITs:
    // module  color_mapper ( input  logic [9:0] DrawX, DrawY, 
                            //input logic [31:0] registers [601],       //lowkey this gotta be massive wrong,BUT is representative
                                                                        //of what i am trying to portray, what i want is the registers 
                                                                        //holding all the characters
                    //    output logic [7:0]  Red, Green, Blue );





    // OLD AND PROBALBLY DELTEABLE
    """
    /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))
       )

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 120 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size;
    assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
  
    always_comb
    begin:Ball_on_proc
        if ( (DistX*DistX + DistY*DistY) <= (Size * Size) )
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 

    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1)) begin 
            Red = 4'hf;
            Green = 4'h7;
            Blue = 4'h0;
        end       
        else begin 
            Red = 4'hf - DrawX[9:6]; 
            Green = 4'hf - DrawX[9:6];
            Blue = 4'hf - DrawX[9:6];
        end      
    end     


    FOR THIS WEEK's LAB:
        take DRAWx and DRAWy and map to a text mode charater, 
        map the registers
        map the pixils 
        use the forn_rom


    """

    //DrawX                                         //gives the overall pixel x
    //DrawY                                         //gives the overall pixel y

    assign char_row = DrawY / 16                    //gives the row of the character in textmode
    assign char_col = DrawX / 8                     //gives the col of the character in textmode

    assign pixel_row = DrawY % 16                   //gives the pixel row within the character
    assign pixel_col = DrawX % 8                    //gives the pixel col within the character

    assign reg_in_row = DrawX / 32                  //this returns the cur reg in the row
    assign cur_reg = char_row * 20 + reg_in_row     //text mode char (int)

    assign char_in_reg = 3 - (char_col % 4)         //this returns the which char of the reg it is 
                                                    //  (REMEMBER LITTLE ENDIAN!!  04030201 on 
                                                    //  screen if 0x01020304 in reg) 

    //VGA RAM is what Zuofu called the 600 reg in lecture
    assign register = VGA_RAM[cur_reg]              //the [::-1] revers the order of the 
                                                            //  contendts in the register to 
                                                            //  account for little endian

    assign character = (register >> (char_in_reg * 8 )) & 8'hFF


    //below is the logic that grabs the collors frosm the contral register
    assign control_reg = VGA_RAM[601]
    assign bkg_b = (control_reg >> 1) & 32'h000F
    assign bkg_g = (control_reg >> 5) & 32'h000F
    assign bkg_r = (control_reg >> 9) & 32'h000F
    assign fgd_b = (control_reg >> 13) & 32'h000F
    assign fgd_g = (control_reg >> 17) & 32'h000F
    assign fgd_r = (control_reg >> 21) & 32'h000F


    font_rom da_char( 
        .addr((character * 16) + pixel_row), 
        .data(char_pixels_ret));

    assign pixel = (char_pixels_ret >> pixel_col) & 8'h01

    always_comb
    begin:pixel_on_proc
        //check for inversion
        if (character >> 7 == 1'b1) begin
            if (pixel == 1'b1) begin
                pixel_on = 1'b0
            end else begin
                pixel_on = 1'b1
            end
        end else begin
            if (pixel == 1'b1) begin
                pixel_on = 1'b1
            end else begin
                pixel_on = 1'b0
            end
        end
     end 

    always_comb
    begin:text_mode
        //pixel on is foreground (normal colllor)
        if ((pixel_on == 1'b1)) begin 
            Red = fgd_r;
            Green = fgd_g;
            Blue = fgd_b;
        end       
        //pixel off is background (inverted colllor)
        else begin 
            Red = bkg_r; 
            Green = bkg_g;
            Blue = bkg_b;
        end      
    end
endmodule
