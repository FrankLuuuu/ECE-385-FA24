module sprite_drawer ( 
    input clk,
    input reset,
    input [7:0] x_pos, 
    input [7:0] y_pos, 
    input [7:0] pixel_x, 
    input [7:0] pixel_y,
    input [11:0]  new_grid[22],

    output reg [7:0] pixel_data
);

    logic [9:0]  cur_grid[20];
    logic [9:0]  new_grid[20];

    typedef struct {
        string name;
        logic [3:0] red;    // 4-bit value for red
        logic [3:0] green;  // 4-bit value for green
        logic [3:0] blue;   // 4-bit value for blue
    } color_t;

    localparam color_t color[] = '{
        '{ "light blue",     4'h5, 4'h5, 4'hf },    //i block
        '{ "blue",           4'h0, 4'h0, 4'ha },    //j block
        '{ "orange",         4'hf, 4'h7, 4'h2 },    //l block
        '{ "yellow",         4'hf, 4'hf, 4'h5 },    //square
        '{ "green",          4'h0, 4'ha, 4'h0 },    //s block
        '{ "purple",         4'ha, 4'h0, 4'hc },    //t block
        '{ "red",            4'ha, 4'h0, 4'h0 },    //z block
        '{ "cyan",           4'h0, 4'ha, 4'ha },
        '{ "light gray",     4'ha, 4'ha, 4'ha },
        '{ "dark gray",      4'h5, 4'h5, 4'h5 },
        '{ "black",          4'h0, 4'h0, 4'h0 },
        '{ "light green",    4'h5, 4'hf, 4'h5 },
        '{ "light cyan",     4'h5, 4'hf, 4'hf },
        '{ "light red",      4'hf, 4'h5, 4'h5 },
        '{ "light magenta",  4'hf, 4'h5, 4'hf },
        '{ "white",          4'hf, 4'hf, 4'hf },    //tetris outline
        '{ "dark blue",      4'h0, 4'h0, 4'h5 },    //background
    };

    localparam logic [11:0] grid [22] = { 
        // ... Pixel data for your sprite here ... 
        //starting location of the grid
        
    };

    // Sprite data (assume a simple 8x8 sprite)
    localparam logic [7:0] sprite_data [0:63] = { 
        // ... Pixel data for your sprite here ... 
    };


    always_comb begin
        if (pixel_x >= x_pos && pixel_x < (x_pos + 8) && pixel_y >= y_pos && pixel_y < (y_pos + 8)) begin
            pixel_data = sprite_data[(pixel_y - y_pos) * 8 + (pixel_x - x_pos)]; 
        end else begin
            pixel_data = 0; // Blank pixel
        end
    end
endmodule