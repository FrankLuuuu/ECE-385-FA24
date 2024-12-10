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


// module  color_mapper ( input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size,     location of the ballcenter and the radius
//                        output logic [3:0]  Red, Green, Blue );
    
// module  color_mapper (  input logic [9:0] DrawX, DrawY, 
//                             output logic [10:0] char_index,              // we do not need to pass in all of VRAM, just the specific address?
                        
//                         input logic [31:0] color_palatte[8],       //pass color palated 
//                         input logic [31:0]  character_word,
//                         // input logic [3:0] fgd, bkg,
//                         output logic [3:0]  Red, Green, Blue );     // we need access to the color pallate
    

module  color_mapper ( input  logic [9:0] BlockX, BlockY, DrawX, DrawY, Ball_size,

                       output logic [3:0]  Red, Green, Blue );

        //blockX and blockY are the topleft corner of the block
        //drawX and drawY are the location of the current pixel being drawn
    logic ball_on;
	 
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

    // block_rom cur_block(
    //     .addr(),
    //     .data()
    // );

    // font_rom da_char( 
    //     .addr((character * 16) + pixel_row),
    //     .data(char_pixels_ret));    // get the pixel data
  
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
    
endmodule
