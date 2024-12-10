module tetris_font_rom (        input  [3:0]    address,      //calculate actual needed size of the address basesd on the dimentions
                                output [59:0]	data    );

	// where address is the row of the tetris sybol to get, and the data 
        //      returned is the row of pixels
				
        parameter ADDR_WIDTH = 4;
	parameter DATA_WIDTH =  60;
	// logic [ADDR_WIDTH-1:0] addr_reg;
	
        // ROM definition
        //i can't remember what the addr width is supposed to do				
	parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] TETRIS_font = {
                60'b111111111101111111111111111111011111110000001100000011111111, // 2 **********       0000
                60'b111111111101111111111111111111011000011000001100000111111100, // 3 **********       0001
                60'b000011000001100000000000110000011000011000001100001100000000, // 4     **           0010
                60'b000011000001111111000000110000011000011000001100000111000000, // 5     **           0011
                60'b000011000001111110000000110000011111110000001100000001110000, // 6     **           0100
                60'b000011000001100000000000110000011001100000001100000000011100, // 7     **           0101
                60'b000011000001100000000000110000011000110000001100000000000110, // 8     **           0110
                60'b000011000001100000000000110000011000011000001100000000000011, // 9     **           0111
                60'b000011000001111111000000110000011000001100001100001111111110, // a     **           1000
                60'b000011000001111111100000110000011000000100001100001111111100, // b     **           1001
        };
	assign data = TETRIS_font[addr];
endmodule  

// 300m pixels left on the rifht signed
// 6 letters each w a min of 10 pixels or 60 total
// try x3 first for tetris of 180 w x 48 h

module tetris_font_color (      input  [2:0]    address,      //calculate actual needed size of the address basesd on the dimentions
                                output [11:0]	color    );

	// where address is the row of the tetris sybol to get, and the data 
        //      returned is the row of pixels
				
        parameter ADDR_WIDTH = 3;
	parameter DATA_WIDTH =  12;
	// logic [ADDR_WIDTH-1:0] addr_reg;
	
        // ROM definition
        //i can't remember what the addr width is supposed to do				
	parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] TETRIS_color = {
                12'hf00,        //red
                12'hf70,        //orange
                12'hff0,        //yellow
                12'h7f0,        //green
                12'h0df,        //light blue
                12'he5f,        //hot pink    
        };
	assign color = TETRIS_color[addr];
endmodule  

module tetris_block_rom (      input [6:0]	addr,
		        output [3:0]	data[4],   );

	parameter ADDR_WIDTH = 7;
	parameter DATA_WIDTH =  4;
	// logic [ADDR_WIDTH-1:0] addr_reg;                // don'r know if thid is needed/ whar this is for

	// BLOCK definition				
	parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] tetris_block = {
                //code 0x0 + rotate
                4'b0000,        // sideways i block
                4'b1111,
                4'b0000,
                4'b0000,
                4'b0010,        // rotate i block 1
                4'b0010,
                4'b0010,
                4'b0010,
                4'b0000,        // rotate i block 2
                4'b0000,
                4'b1111,
                4'b0000,
                4'b0100,        // rotate i block 3
                4'b0100,
                4'b0100,
                4'b0100,

                //code 0x1 + rotate
                4'b1000,        // j block
                4'b1110,
                4'b0000,
                4'b0000,
                4'b0110,        //rotate j block 1
                4'b0100,
                4'b0100,
                4'b0000,
                4'b0000,        //rotate j block 2
                4'b1110,
                4'b0010,
                4'b0000,
                4'b0100,        //rotate j block 2
                4'b0100,
                4'b1100,
                4'b0000,

                //code 0x2 + rotate
                4'b0010,        // l block
                4'b1110,
                4'b0000,
                4'b0000,
                4'b0100,        //rotate l block 1
                4'b0100,
                4'b0110,
                4'b0000,
                4'b0000,        //rotate l block 2
                4'b1110,
                4'b1000,
                4'b0000,
                4'b1100,        //rotate l block 3
                4'b0100,
                4'b0100,
                4'b0000,

                //code 0x3 + rotate
                4'b0110,        //square block
                4'b0110,
                4'b0000,
                4'b0000,
                4'b0110,        //rotate square block 1
                4'b0110,
                4'b0000,
                4'b0000,
                4'b0110,        //rotate square block 2
                4'b0110,
                4'b0000,
                4'b0000,
                4'b0110,        //rotate square block 3
                4'b0110,
                4'b0000,
                4'b0000,

                // code 0x4 + rotate
                4'b0110,        // s block
                4'b1100,
                4'b0000,
                4'b0000,
                4'b0100,        //rotate s block 1
                4'b0110,
                4'b0010,
                4'b0000,
                4'b0000,        //rotate s block 2
                4'b0110,
                4'b1100,
                4'b0000,
                4'b1000,        //rotate s block 3
                4'b1100,
                4'b0100,
                4'b0000,

                //code 0x5 + rotate
                4'b0100,        //t block
                4'b1110,
                4'b0000,
                4'b0000,
                4'b0100,        //rotate t block 1
                4'b0110,
                4'b0100,
                4'b0000,
                4'b0000,        //rotate t block 2
                4'b1110,
                4'b0100,
                4'b0000,
                4'b0100,        //rotate t block 3
                4'b1100,
                4'b0100,
                4'b0000,

                //code 0x6 + rotate
                4'b1100,        //z block
                4'b0110,
                4'b0000,
                4'b0000,
                4'b0010,        // rotate z block 1
                4'b0110,
                4'b0100,
                4'b0000,
                4'b0000,        // rotate z block 2
                4'b1100,
                4'b0110,
                4'b0000,
                4'b0100,        // rotate z block 1
                4'b1100,
                4'b1000,
                4'b0000,
        };
	assign data = tetris_block[addr +:4];
endmodule  














// 0            // 0          // 0          // 0            // 0            // 0            
// 1            // 1          // 1          // 1            // 1            // 1            
// 2 ********** // 2  ********// 2 ******** // 2  *******   // 2    **      // 2   ******** 
// 3 ********** // 3  ********// 3 ******** // 3  **    **  // 3    **      // 3  *******   
// 4     **     // 4  **      // 4    **    // 4  **    **  // 4    **      // 4 **         
// 5     **     // 5  ******  // 5    **    // 5  **    **  // 5    **      // 5  ***       
// 6     **     // 6  *****   // 6    **    // 6  *******   // 6    **      // 6    ***     
// 7     **     // 7  **      // 7    **    // 7  **  **    // 7    **      // 7      ***   
// 8     **     // 8  **      // 8    **    // 8  **   **   // 8    **      // 8        **  
// 9     **     // 9  **      // 9    **    // 9  **    **  // 9    **      // 9         ** 
// a     **     // a  ******* // a    **    // a  **     ** // a    **      // a *********   
// b     **     // b  ********// b    **    // b  **      * // b    **      // b ********   
// c            // c          // c          // c            // c            // c            
// d            // d          // d          // d            // d            // d            
// e            // e          // e          // e            // e            // e            
// f            // f          // f          // f            // f            // f            
         
          
                // //address 001
                // 8'b0000000000, // 0
                // 8'b0000000000, // 1
                // 8'b0111111111, // 2  ********
                // 8'b0111111111, // 3  ********
                // 8'b0110000000, // 4  **   
                // 8'b0111111100, // 5  ******
                // 8'b0111111000, // 6  *****
                // 8'b0110000000, // 7  ** 
                // 8'b0110000000, // 8  **
                // 8'b0110000000, // 9  **   
                // 8'b0111111100, // a  *******
                // 8'b0111111110, // b  ********
                // 8'b0000000000, // c
                // 8'b0000000000, // d
                // 8'b0000000000, // e
                // 8'b0000000000, // f
                // //address 010
                // 8'b0000000000, // 0         
                // 8'b0000000000, // 1         
                // 8'b1111111111, // 2 ********
                // 8'b1111111111, // 3 ********
                // 8'b0000110000, // 4    **   
                // 8'b0000110000, // 5    **   
                // 8'b0000110000, // 6    **   
                // 8'b0000110000, // 7    **   
                // 8'b0000110000, // 8    **   
                // 8'b0000110000, // 9    **   
                // 8'b0000110000, // a    **             
                // 8'b0000110000, // b    **             
                // 8'b0000000000, // c          
                // 8'b0000000000, // d          
                // 8'b0000000000, // e          
                // 8'b0000000000, // f          
                // //address 011
                // 8'b0000000000, // 0             
                // 8'b0000000000, // 1             
                // 8'b0111111100, // 2  *******   
                // 8'b0110000110, // 3  **    **  
                // 8'b0110000110, // 4  **    **  
                // 8'b0110000110, // 5  **    **   
                // 8'b0111111100, // 6  *******    
                // 8'b0110011000, // 7  **  **    
                // 8'b0110001100, // 8  **   **    
                // 8'b0110000110, // 9  **    **  
                // 8'b0110000011, // a  **     ** 
                // 8'b0110000001, // b  **      *
                // 8'b0000000000, // c             
                // 8'b0000000000, // d             
                // 8'b0000000000, // e             
                // 8'b0000000000, // f             
                // //address 100
                // 8'b0000000000, // 0              
                // 8'b0000000000, // 1              
                // 8'b0000110000, // 2    **              
                // 8'b0000110000, // 3    **              
                // 8'b0000110000, // 4    **              
                // 8'b0000110000, // 5    **              
                // 8'b0000110000, // 6    **              
                // 8'b0000110000, // 7    **              
                // 8'b0000110000, // 8    **              
                // 8'b0000110000, // 9    **              
                // 8'b0000110000, // a    **              
                // 8'b0000110000, // b    **              
                // 8'b0000000000, // c              
                // 8'b0000000000, // d              
                // 8'b0000000000, // e              
                // 8'b0000000000, // f              
                // //address 101
                // 8'b0000000000, // 0             
                // 8'b0000000000, // 1             
                // 8'b0011111111, // 2   ********   
                // 8'b0111111100, // 3  *******      
                // 8'b1100000000, // 4 **                
                // 8'b0111000000, // 5  ***             
                // 8'b0001110000, // 6    ***             
                // 8'b0000011100, // 7      ***             
                // 8'b0000000110, // 8        **             
                // 8'b0000000011, // 9         **
                // 8'b1111111110, // a *********             
                // 8'b1111111100, // b ********             
                // 8'b0000000000, // c             
                // 8'b0000000000, // d             
                // 8'b0000000000, // e             
                // 8'b0000000000, // f       