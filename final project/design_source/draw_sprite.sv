module sprite_drawer ( 

    input clk, 

    input reset,

    input [7:0] x_pos, 

    input [7:0] y_pos, 

    input [7:0] pixel_x, 

    input [7:0] pixel_y,

    output reg [7:0] pixel_data

);



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