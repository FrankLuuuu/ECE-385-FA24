module bus_mux(
    input logic GateMAR,
    input logic GatePC,
    input logic GateMDR,
    input logic GateALU,
    
    input logic [15:0] ADDR,
    input logic [15:0] PC,
    input logic [15:0] MDR,
    input logic [15:0] ALU,
    
    output logic [15:0] data_bus
);

always_comb
begin
    if (GatePC == 1)
        data_bus = PC;
    else if (GateMDR == 1) 
        data_bus = MDR;
    else if (GateMAR == 1) 
        data_bus = ADDR;
    else 
        data_bus = ALU;
end
endmodule



module pc_mux(
    input   logic [15:0] data_bus,        // left most wire
    input   logic [15:0] addr,     // middle wire
    input   logic [15:0] pc_plus_1,       // right most wire

    input   logic [1:0]  select,          // the wires to select the input

    output  logic [15:0] pcmux_out
);

always_comb
begin
    if (select == 2'b00)
        pcmux_out = pc_plus_1;           // select = 0
    else if (select == 2'b01)
        pcmux_out = addr;        // select = 1
    else 
        pcmux_out = data_bus;          // avoids the infered latch by making all other values (b'10 or b'11) pc plus 1
end
endmodule



module mio_en_mux(
    input   logic [15:0]    data_bus,
    input   logic [15:0]    rdata,

    input   logic           mio_en,

    output  logic [15:0]    mio_en_mux_out
);

always_comb
begin
    if (mio_en == 0)
        mio_en_mux_out = rdata;      // enable = 0
    else
        mio_en_mux_out = data_bus;         // enable = 1
end
endmodule



module addr1_mux (
    input   logic [15:0]    pc,
    input   logic [15:0]    sr1_out,

    input   logic           addr1mux,

    output  logic [15:0]    addr1_mux_out
);

always_comb
begin
    if (addr1mux == 1'b0)
        addr1_mux_out = pc;
    else   
        addr1_mux_out = sr1_out;
end
endmodule



module sr1_mux(
    input   logic [2:0]     eleventhrnine,
    input   logic [2:0]     eightthrsix,

    input   logic           sr1,

    output  logic [2:0]     sr1mux_out
);

always_comb
begin
    if (sr1 == 1'b0)
        sr1mux_out = eightthrsix;
    else    
        sr1mux_out = eleventhrnine;    
end
endmodule


module sr2_mux(
    input   logic [15:0]    sr2_out,
    input   logic [15:0]    ir,

    input   logic           control,        //select

    output  logic [15:0]    sr2mux_out
);

always_comb
begin
    if (control == 1'b0)
        sr2mux_out = ir;
    else    
        sr2mux_out = sr2_out;
end
endmodule


module dr_mux(
    input logic [2:0] ir,
    input logic [2:0] ones,

    input logic control,

    output logic [2:0] drmux_out
);

always_comb
begin
    if (control == 1'b1)
        drmux_out = ir;
    else
        drmux_out = ones;
end
endmodule


module addr2_mux (
    input   logic [15:0]    elevenbits,
    input   logic [15:0]    ninebits,
    input   logic [15:0]    sixbits, 
    // input   logic [15:0]    ir,
    input   logic [15:0]    zeroes, 

    input   logic [1:0]     addr2mux,
    
    output  logic [15:0]    addr2_mux_out
);

always_comb
begin
    if (addr2mux == 2'b00)
        addr2_mux_out = zeroes;
    else if (addr2mux == 2'b01)
        addr2_mux_out = sixbits;
    else if (addr2mux == 2'b10)
        addr2_mux_out = ninebits;
    else
        addr2_mux_out = elevenbits;
end
endmodule



module alu_mux (
    input logic [1:0] aluk,
    input logic [15:0] A,
    input logic [15:0] B,
    
    output logic [15:0] alu
);

always_comb
begin
    if (aluk == 0)
        alu = A + B;
    else if (aluk == 1)
        alu = A & B;
    else if (aluk == 2)
        alu = ~A;
    else 
        alu = A;
end
endmodule



module decoder(
    input   logic [2:0] dr,

    output  logic [7:0] load
);

always_comb
begin
    load[7:0] = 0; 

    case(dr)
        3'b000: load[0] = 1;
        3'b001: load[1] = 1;
        3'b010: load[2] = 1;
        3'b011: load[3] = 1;
        3'b100: load[4] = 1;
        3'b101: load[5] = 1;
        3'b110: load[6] = 1;
        3'b111: load[7] = 1;
    endcase
end

endmodule