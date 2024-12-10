module block_rom (      input [6:0]	addr,
                        // TODO: 
                        //      ok so i have the full addr rn, but i would like to indes in by code + rotate
                        //      i have rotate as a possible input below, 
                        // input [2:0]  addr
                        // input       rotate,
		        output [3:0]	data[4],
                        // output [3:0]    red, green, blue
                        );

	parameter ADDR_WIDTH = 7;
	parameter DATA_WIDTH =  4;
	// logic [ADDR_WIDTH-1:0] addr_reg;                // don'r know if thid is needed/ whar this is for

        // int block;
        // assign block = (addr + rotate) * 4
        //logic to find assigned color of the block

	// BLOCK definition				
	parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] BLOCK = {
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
	assign data = BLOCK[addr +:4];
endmodule  



module grid (   
        // input  logic [3:0]  block[4],       //block
                
        input  logic        Reset, 
        input  logic        frame_clk,
        input  logic [7:0]  keycode,
        // TODO: 
        //      ok so i have the full addr rn, but i would like to indes in by code + rotate
        //      i have rotate as a possible input below, 
        // input [2:0]  addr
        // input       rotate,
        output [9:0]	data[20],       //grid
        // output [3:0]    red, green, blue
        );

        logic [3:0] block[4];

        //block generation
        // https://stackoverflow.com/questions/34011576/generating-random-numbers-in-verilog
        int generate_block, rotate;
        assign generate_block = $urandom % 7;
        assign rotate = 0;

        block_rom cur_block(
                .addr(generate_block + rotate),
                .data(block)
        );

	parameter ADDR_WIDTH = 7;
	parameter DATA_WIDTH =  4;
	// logic [ADDR_WIDTH-1:0] addr_reg;                // don'r know if thid is needed/ whar this is for

        // int block;
        // assign block = (addr + rotate) * 4
        //logic to find assigned color of the block

	// BLOCK definition				
	parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] BLOCK = {
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


        };
	assign data = BLOCK[addr];
endmodule  