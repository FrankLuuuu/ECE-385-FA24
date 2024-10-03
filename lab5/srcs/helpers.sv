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
    input   logic [15:0] gate_marmux,     // middle wire
    input   logic [15:0] pc_plus_1,       // right most wire

    input   logic [1:0]  select,          // the wires to select the input

    output  logic [15:0] pcmux_out
);

always_comb
begin
    if (select == 2'b00)
        pcmux_out = pc_plus_1;           // select = 0
    else if (select == 2'b01)
        pcmux_out = gate_marmux;        // select = 1
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