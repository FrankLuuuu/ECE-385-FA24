//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf     03-01-2006                           --
//                                  03-12-2007                           --
//    Translated by Joe Meng        07-07-2013                           --
//    Modified by Zuofu Cheng       08-19-2023                           --
//    Modified by Satvik Yellanki   12-17-2023                           --
//    Fall 2024 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI Lab                                --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------

//how scoring normally works:
//  1 line cleared is worth 100 points
//  tetris is 800 points
//  back to back tetris is 1200

//how we will implement scoring:
//  1 line cleared  is 1 points
//  tetris is 8 points
//  back to back tetris is 12


module block
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,

    output logic [9:0]  score,
    output logic [2:0]  next_block,
    output logic [2:0]  grid[20][10]
);

    logic [9:0] Ball_X_Motion;
    logic [9:0] Ball_X_Motion_next;
    logic [9:0] Ball_Y_Motion;
    logic [9:0] Ball_Y_Motion_next;

    logic [7:0] keycode_prev;
    logic [2:0] grid_next[20][10];
    logic [2:0] grid_temp[20][10];
    logic [4:0] move, timer;
    logic [4:0] x, y, x_next, y_next;
    logic [1:0] rotation, rotation_next;
    logic [4:0] id, id_next;
    logic [9:0] score_next;
    logic start, start_next;
    logic dropping;
    logic drop_it, drop_it_next;
    logic new_block;
    logic clear_row;
    logic moved;
    logic valid;

    // integer i, j;
    localparam GRID_HEIGHT = 20;
    localparam GRID_WIDTH  = 10;
    
    always_comb begin
        grid_next = grid;

        start_next = start;
        score_next = score;
        drop_it_next = drop_it;
        rotation_next = rotation;

        x_next = x;
        y_next = y;

        id_next = id;
        next_block = id_next;

        new_block = 0;
        moved = 0;

        // check if the block can be dropped
        dropping = 1;
        for (int i = 0; i < GRID_HEIGHT; i++) begin
            for (int j = 0; j < GRID_WIDTH; j++) begin
                if (grid[i][j] < 6) begin
                    if (i >= 19) begin
                        dropping = 0;
                    end else if (grid[i + 1][j] != 7 && grid[i + 1][j] != grid[i][j]) begin
                        dropping = 0;
                    end
                end
            end
        end

        // initial state
        if (start) begin
            start_next = 0;
            new_block = 1;
        end

        // grid index: 0-6 = blocks, 7 = none, 8+ = stationary blocks
        // block dropping
        if (timer == move || drop_it) begin
            drop_it_next = 0;
            if (dropping) begin
                moved = 1;
                y_next = y + 1;
                for (int i = 0; i < GRID_HEIGHT; i++) begin
                    for (int j = 0; j < GRID_WIDTH; j++) begin
                        if (grid[i][j] == 6) begin
                            grid_next[i][j] = grid[i][j];
                        end else if (i == 0) begin
                            grid_next[i][j] = 7;
                        end else if (grid[i - 1][j] < 6) begin
                            grid_next[i][j] = grid[i - 1][j];
                        end else begin
                            grid_next[i][j] = 7;
                        end
                    end
                end
                
            // make current block stationary and create new block
            end else begin
                drop_it_next = 0;
                for (int i = 0; i < GRID_HEIGHT; i++) begin
                    for (int j = 0; j < GRID_WIDTH; j++) begin
                        if (grid[i][j] < 6) begin
                            grid_next[i][j] = 6;
                        end
                    end
                end
                new_block = 1;
            end
        end

        // when current block stops moving
        if (new_block) begin
            // clear full rows
            for (int i = 0; i < GRID_HEIGHT; i++) begin
                grid_temp = grid_next;
                clear_row = 1;
                for (int j = 0; j < GRID_WIDTH; j++) begin
                    if (grid_temp[i][j] != 6) begin
                        clear_row = 0;
                    end
                end
                if (clear_row) begin
                    score_next = score_next + 1;
                    for (int k = 0; k < GRID_WIDTH; k++) begin
                        for (int l = 0; l <= i; l++) begin
                            if (l != 0) begin
                                grid_next[l][k] = grid_temp[l - 1][k];
                            end else begin
                                grid_next[l][k] = 7;
                            end
                        end
                    end
                end
            end
            
            // generate next block
            if (id >= 5) begin
                id_next = id % 5;
                next_block = id_next;
            end else begin
                id_next = id + 1;
                next_block = id_next + 1;
            end
            
            // i block
            if (id_next == 0) begin
                grid_next[1][3] = 0;
                grid_next[1][4] = 0;
                grid_next[1][5] = 0;
                grid_next[1][6] = 0;
                x_next = 3;
                y_next = 1;
                rotation_next = 0;
            // j block
            end else if (id_next == 1) begin
                grid_next[0][4] = 1;
                grid_next[1][4] = 1;
                grid_next[1][5] = 1;
                grid_next[1][6] = 1;
                x_next = 4;
                y_next = 0;
                rotation_next = 0;
            // l block
            end else if (id_next == 2) begin
                grid_next[1][4] = 2;
                grid_next[1][5] = 2;
                grid_next[1][6] = 2;
                grid_next[0][6] = 2;
                x_next = 4;
                y_next = 1;
                rotation_next = 0;
            // square block
            end else if (id_next == 3) begin
                grid_next[0][4] = 3;
                grid_next[0][5] = 3;
                grid_next[1][4] = 3;
                grid_next[1][5] = 3;
                x_next = 4;
                y_next = 0;
                rotation_next = 0;
            // s block
            end else if (id_next == 4) begin
                grid_next[1][4] = 4;
                grid_next[1][5] = 4;
                grid_next[0][5] = 4;
                grid_next[0][6] = 4;
                x_next = 4;
                y_next = 1;
                rotation_next = 0;
            // t block
            end else if (id_next == 5) begin
                grid_next[1][4] = 5;
                grid_next[1][5] = 5;
                grid_next[0][5] = 5;
                grid_next[1][6] = 5;
                x_next = 4;
                y_next = 1;
                rotation_next = 0;
            // z block
            // end else if (id_next == 6) begin
            //     grid_next[0][4] = 6;
            //     grid_next[0][5] = 6;
            //     grid_next[1][5] = 6;
            //     grid_next[1][6] = 6;
            //     x_next = 4;
            //     y_next = 0;
            //     rotation_next = 0;
            end
        end

        // keycodes
        else if (keycode != 8'h00 && keycode_prev == 8'h00 && !moved) begin
            // w (rotate))
            if (keycode == 8'h1A) begin
                id_next = id + 1;
                // i block
                if (grid[y][x] == 0) begin
                    if (rotation[0] == 0) begin
                        if (y <= 0 || y >= 18 || grid[y - 1][x + 1] == 6 || grid[y + 1][x + 1] == 6 || grid[y + 2][x + 1] == 6) begin
                            // do nothing
                        end else begin
                            rotation_next = rotation + 1;
                            grid_next[y][x] = 7;
                            grid_next[y][x + 2] = 7;
                            grid_next[y][x + 3] = 7;
                            grid_next[y - 1][x + 1] = 0;
                            grid_next[y + 1][x + 1] = 0;
                            grid_next[y + 2][x + 1] = 0;
                            x_next = x + 1;
                            y_next = y - 1;
                        end
                    end else begin
                        if (x <= 0 || x >= 8 || grid[y + 1][x - 1] == 6 || grid[y + 1][x + 1] == 6 || grid[y + 1][x + 2] == 6) begin
                             // do nothing
                        end else begin
                            rotation_next = rotation - 1;
                            grid_next[y][x] = 7;
                            grid_next[y + 2][x] = 7;
                            grid_next[y + 3][x] = 7;
                            grid_next[y + 1][x - 1] = 0;
                            grid_next[y + 1][x + 1] = 0;
                            grid_next[y + 1][x + 2] = 0;
                            x_next = x - 1;
                            y_next = y + 1;
                        end
                    end
                end
                        
                // s block
                else if (grid[y][x] == 4) begin
                    if (rotation[0] == 0) begin
                        if (y >= 19 || grid[y - 1][x] == 6 || grid[y + 1][x + 1] == 6) begin
                            // do nothing
                        end else begin
                            rotation_next = rotation + 1;
                            grid_next[y - 1][x + 1] = 7;
                            grid_next[y - 1][x + 2] = 7;
                            grid_next[y - 1][x] = 4;
                            grid_next[y + 1][x + 1] = 4;
                            x_next = x;
                            y_next = y - 1;
                        end
                    end else begin
                        if (x >= 8 || grid[y - 1][x + 1] == 6 || grid[y - 1][x + 2] == 6) begin
                            // do nothing
                        end else begin
                            rotation_next = rotation - 1;
                            grid_next[y][x] = 7;
                            grid_next[y + 2][x + 1] = 7;
                            grid_next[y][x + 1] = 4;
                            grid_next[y][x + 2] = 4;
                            x_next = x;
                            y_next = y + 1;
                        end
                    end
                end
                
                // // z block
                // else if (grid[y][x] == 6) begin
                //     if (rotation[0] == 0) begin
                //         if (y >= 18 || x >= 8 || grid[y][x + 2] == 6 || grid[y + 2][x + 1] == 6) begin
                //             // do nothing
                //         end else begin
                //             rotation_next = rotation + 1;
                //             grid_next[y][x] = 7;
                //             grid_next[y][x + 1] = 7;
                //             grid_next[y][x + 2] = 6;
                //             grid_next[y + 2][x + 1] = 6;
                //             x_next = x + 1;
                //             y_next = y + 1;
                //         end
                //     end else begin
                //         if (x <= 0 || grid[y - 1][x - 1] == 6 || grid[y - 1][x] == 6) begin
                //             // do nothing
                //         end else begin
                //             rotation_next = rotation - 1;
                //             grid_next[y + 1][x] = 7;
                //             grid_next[y - 1][x + 1] = 7;
                //             grid_next[y - 1][x - 1] = 6;
                //             grid_next[y - 1][x] = 6;
                //             x_next = x - 1;
                //             y_next = y - 1;
                //         end
                //     end
                // end
                
                // l block   
                else if (grid[y][x] == 2) begin
                    if (rotation == 0) begin
                        if (y >= 19 || grid[y - 1][x + 1] == 6 || grid[y + 1][x + 1] == 6 || grid[y + 1][x + 2] == 6) begin
                            // do nothing
                        end else begin
                            rotation_next = rotation + 1;
                            grid_next[y][x] = 7;
                            grid_next[y][x + 2] = 7;
                            grid_next[y - 1][x + 2] = 7;
                            grid_next[y - 1][x + 1] = 2;
                            grid_next[y + 1][x + 1] = 2;
                            grid_next[y + 1][x + 2] = 2;
                            x_next = x + 1;
                            y_next = y - 1;
                        end
                    end else if (rotation == 1) begin
                        if (x <= 0 || grid[y + 1][x - 1] == 6 || grid[y + 2][x - 1] == 6 || grid[y + 1][x + 1] == 6) begin
                            // do nothing
                        end else begin
                            rotation_next = rotation + 1;
                            grid_next[y][x] = 7;
                            grid_next[y + 2][x] = 7;
                            grid_next[y + 2][x + 1] = 7;
                            grid_next[y + 1][x - 1] = 2;
                            grid_next[y + 2][x - 1] = 2;
                            grid_next[y + 1][x + 1] = 2;
                            x_next = x - 1;
                            y_next = y + 1;
                        end
                    end else if (rotation == 2) begin
                        if (y <= 0 || grid[y - 1][x] == 6 || grid[y - 1][x + 1] == 6 || grid[y + 1][x + 1] == 6) begin
                            // do nothing
                        end else begin
                            rotation_next = rotation + 1;
                            grid_next[y + 1][x] = 7;
                            grid_next[y][x] = 7;
                            grid_next[y][x + 2] = 7;
                            grid_next[y - 1][x] = 2;
                            grid_next[y - 1][x + 1] = 2;
                            grid_next[y + 1][x + 1] = 2;
                            x_next = x;
                            y_next = y - 1;
                        end
                    end else begin
                        if (x >= 8 || grid[y][x + 2] == 6 || grid[y + 1][x + 2] == 6 || grid[y + 1][x] == 6) begin
                            // do nothing
                        end else begin
                            rotation_next = rotation - 3;
                            grid_next[y][x] = 7;
                            grid_next[y][x + 1] = 7;
                            grid_next[y + 2][x + 1] = 7;
                            grid_next[y][x + 2] = 2;
                            grid_next[y + 1][x + 2] = 2;
                            grid_next[y + 1][x] = 2;
                            x_next = x;
                            y_next = y + 1;
                        end
                    end
                end
                
                // j block
                else if (grid[y][x] == 1) begin
                    if (rotation == 0) begin
                        if (y >= 18 || grid[y][x + 1] == 6 || grid[y][x + 2] == 6 || grid[y + 2][x + 1] == 6) begin
                            // do nothing
                        end else begin
                            rotation_next = rotation + 1;
                            grid_next[y][x] = 7;
                            grid_next[y + 1][x] = 7;
                            grid_next[y + 1][x + 2] = 7;
                            grid_next[y][x + 1] = 1;
                            grid_next[y][x + 2] = 1;
                            grid_next[y + 2][x + 1] = 1;
                            x_next = x + 1;
                            y_next = y;
                        end
                    end else if (rotation == 1) begin
                        if (x <= 0 || grid[y + 1][x - 1] == 6 || grid[y + 1][x + 1] == 6 || grid[y + 2][x + 1] == 6) begin
                            // do nothing
                        end else begin
                            rotation_next = rotation + 1;
                            grid_next[y][x] = 7;
                            grid_next[y][x + 1] = 7;
                            grid_next[y + 2][x] = 7;
                            grid_next[y + 1][x - 1] = 1;
                            grid_next[y + 1][x + 1] = 1;
                            grid_next[y + 2][x + 1] = 1;
                            x_next = x - 1;
                            y_next = y + 1;
                        end
                    end else if (rotation == 2) begin
                        if (y <= 0 || grid[y + 1][x] == 6 || grid[y + 1][x + 1] == 6 || grid[y - 1][x + 1] == 6) begin
                            // do nothing
                        end else begin
                            rotation_next = rotation + 1;
                            grid_next[y][x] = 7;
                            grid_next[y][x + 2] = 7;
                            grid_next[y + 1][x + 2] = 7;
                            grid_next[y + 1][x] = 1;
                            grid_next[y + 1][x + 1] = 1;
                            grid_next[y - 1][x + 1] = 1;
                            x_next = x;
                            y_next = y + 1;
                        end
                    end else begin
                        if (x >= 8 || grid[x][y - 1] == 6 || grid[x][y - 2] == 6 || grid[x + 2][y - 1] == 6) begin
                            // do nothing
                        end else begin
                            rotation_next = rotation - 3;
                            grid_next[y][x] = 7;
                            grid_next[y][x + 1] = 7;
                            grid_next[y - 2][x + 1] = 7;
                            grid_next[y - 1][x] = 1;
                            grid_next[y - 2][x] = 1;
                            grid_next[y - 1][x + 2] = 1;
                            x_next = x;
                            y_next = y - 2;
                        end
                    end 
                end
                
                // t block
               else if (grid[x][y] == 5) begin
                   if (rotation == 0) begin
                       if (y >= 19 || grid[y + 1][x + 1] == 6) begin
                            // do nothing
                       end else begin
                            rotation_next = rotation + 1;
                            grid_next[y][x] = 7;
                            grid_next[y + 1][x + 1] = 5;
                            x_next = x + 1;
                            y_next = y - 1;
                       end
                   end else if (rotation == 1) begin
                       if (x <= 0 || grid[y + 1][x - 1] == 6) begin
                            // do nothing
                       end else begin
                            rotation_next = rotation + 1;
                            grid_next[y][x] = 7;
                            grid_next[y + 1][x - 1] = 5;
                            x_next = x - 1;
                            y_next = y + 1;
                       end
                   end else if (rotation == 2) begin
                       if (y <= 0 || grid[y - 1][x + 1] == 6) begin
                            // do nothing
                       end else begin
                            rotation_next = rotation + 1;
                            grid_next[y][x + 2] = 7;
                            grid_next[y - 1][x + 1] = 5;
                            x_next = x;
                            y_next = y;
                       end
                   end else begin
                       if (x >= 8 || grid[y][x + 2] == 6) begin
                            // do nothing
                       end else begin
                            rotation_next = rotation - 3;
                            grid_next[y + 1][x + 1] = 7;
                            grid_next[y][x + 2] = 5;
                            x_next = x;
                            y_next = y;
                       end
                   end
               end
                
            // a key
            end else if (keycode == 8'h04) begin
                id_next = id + 2;
                valid = 1;
                for (int i = 0; i < GRID_HEIGHT; i++) begin
                    for (int j = 0; j < GRID_WIDTH; j++) begin
                        if (grid[i][j] < 6) begin
                            if (j - 1 < 0) begin
                                valid = 0;
                            end else if (grid[i][j - 1] != 7 && grid[i][j - 1] != grid[i][j]) begin
                                valid = 0;
                            end
                        end
                    end
                end
                
                if (valid) begin
                    x_next = x - 1;
                    for (int i = 0; i < GRID_HEIGHT; i++) begin
                        for (int j = 0; j < GRID_WIDTH; j++) begin
                            if (grid[i][j] == 6) begin
                                grid_next[i][j] = grid[i][j];
                            end else if (j < 9 && grid[i][j + 1] < 6) begin
                                grid_next[i][j] = grid[i][j + 1];
                            end else begin
                                grid_next[i][j] = 7;
                            end
                        end
                    end
                end

            // d key
            end else if (keycode == 8'h07) begin
                id_next = id + 3;
                valid = 1;
                for (int i = 0; i < GRID_HEIGHT; i++) begin
                    for (int j = 0; j < GRID_WIDTH; j++) begin
                        if (grid[i][j] < 6) begin
                            if (j + 1 >= 10) begin
                                valid = 0;
                            end else if (grid[i][j + 1] != 7 && grid[i][j + 1] != grid[i][j]) begin
                                valid = 0;
                            end
                        end
                    end
                end
                
                if (valid) begin
                    x_next = x + 1;
                    for (int i = 0; i < GRID_HEIGHT; i++) begin
                        for (int j = 0; j < GRID_WIDTH; j++) begin
                            if (grid[i][j] == 6) begin
                                grid_next[i][j] = grid[i][j];
                            end else if (i >= 1 && grid[i][j - 1] < 6) begin
                                grid_next[i][j] = grid[i][j - 1];
                            end else begin
                                grid_next[i][j] = 7;
                            end
                        end
                    end
                end
            end

            // s key
            end else if (keycode == 8'h16) begin
                drop_it_next = 1;
        end
    end

    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_Block
        if (Reset) begin
            for (int i = 0; i < GRID_HEIGHT; i++) begin 
                for (int j = 0; j < GRID_WIDTH; j++) begin
                    grid[i][j] <= 7;
                    grid_next[i][j] <= 7;
                end
            end

            start <= 1;
            move <= 60;
            timer <= 0;

            drop_it <= 0;
            rotation <= 0;
            valid <= 1;
            score <= 0;

            id <= 2;

            keycode_prev <= 8'h00;
        end
        else begin
            timer <= timer + 1;
            if (timer > move) begin
                timer <= 0;
            end

            grid <= grid_next;

            start <= start_next;
            score <= score_next;
            drop_it <= drop_it_next;
            rotation <= rotation_next;

            x <= x_next;
            y <= y_next;

            id <= id_next;

            keycode_prev <= keycode;
        end
    end

endmodule
