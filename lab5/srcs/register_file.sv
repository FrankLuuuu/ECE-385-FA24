//`timescale 1ns / 1ps

module regfile(
    input logic clk,
    input logic reset,

    input logic ld_reg,
    input logic [2:0] sr1,
    input logic [2:0] sr2,
    input logic [2:0] dr,
    input logic [15:0] data_bus,

    output logic [15:0] sr1_out,
    output logic [15:0] sr2_out
);

logic [15:0]    reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;
logic [7:0]     decode;

decoder decode_load(
    .dr     (dr),

    .load   (decode)
);

load_reg #(.DATA_WIDTH(16)) reg_file0 (
    .clk    (clk),
    .reset  (reset),

    .load   (decode[0] & ld_reg), 
    .data_i (data_bus), 

    .data_q (reg0)
);

load_reg #(.DATA_WIDTH(16)) reg_file1 (
    .clk    (clk),
    .reset  (reset),

    .load   (decode[1] & ld_reg),
    .data_i (data_bus),

    .data_q (reg1)
);

load_reg #(.DATA_WIDTH(16)) reg_file2 (
    .clk    (clk),
    .reset  (reset),

    .load   (decode[2] & ld_reg),
    .data_i (data_bus),

    .data_q (reg2)
);

load_reg #(.DATA_WIDTH(16)) reg_file3 (
    .clk    (clk),
    .reset  (reset),

    .load   (decode[3] & ld_reg),
    .data_i (data_bus),

    .data_q (reg3)
);

load_reg #(.DATA_WIDTH(16)) reg_file4 (
    .clk    (clk),
    .reset  (reset),

    .load   (decode[4] & ld_reg),
    .data_i (data_bus),

    .data_q (reg4)
);

load_reg #(.DATA_WIDTH(16)) reg_file5 (
    .clk    (clk),
    .reset  (reset),

    .load   (decode[5] & ld_reg),
    .data_i (data_bus),

    .data_q (reg5)
);

load_reg #(.DATA_WIDTH(16)) reg_file6 (
    .clk    (clk),
    .reset  (reset),

    .load   (decode[6] & ld_reg),
    .data_i (data_bus),

    .data_q (reg6)
);

load_reg #(.DATA_WIDTH(16)) reg_file7 (
    .clk    (clk),
    .reset  (reset),

    .load   (decode[7] & ld_reg),
    .data_i (data_bus),

    .data_q (reg7)
);
  
always_comb
begin  
    case(sr1)
        3'b000:     sr1_out = reg0;
        3'b001:     sr1_out = reg1;
        3'b010:     sr1_out = reg2;
        3'b011:     sr1_out = reg3;
        3'b100:     sr1_out = reg4;
        3'b101:     sr1_out = reg5;
        3'b110:     sr1_out = reg6;
        3'b111:     sr1_out = reg7;
        default:    sr1_out = 0;
    endcase
    
    case(sr2)
        3'b000:     sr2_out = reg0;
        3'b001:     sr2_out = reg1;
        3'b010:     sr2_out = reg2;
        3'b011:     sr2_out = reg3;
        3'b100:     sr2_out = reg4;
        3'b101:     sr2_out = reg5;
        3'b110:     sr2_out = reg6;
        3'b111:     sr2_out = reg7;
        default:    sr2_out = 0;
    endcase
end

endmodule