//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Given Code - SLC-3 core
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-2020
//	  Revised 03-02-2021
//    Xilinx vivado
//    Revised 07-25-2023 
//    Revised 12-29-2023
//    Revised 09-25-2024
//------------------------------------------------------------------------------

module cpu (
    input   logic        clk,
    input   logic        reset,

    input   logic        run_i,
    input   logic        continue_i,
    output  logic [15:0] hex_display_debug,
    output  logic [15:0] led_o,
   
    input   logic [15:0] mem_rdata,
    output  logic [15:0] mem_wdata,
    output  logic [15:0] mem_addr,
    output  logic        mem_mem_ena,
    output  logic        mem_wr_ena
);


// Internal connections, follow the datapath block diagram and add the additional needed signals
logic           ld_mar; 
logic           ld_mdr; 
logic           ld_ir; 
logic           ld_pc; 
logic           ld_led;

logic           gate_pc;
logic           gate_mdr;
// logic           gate_alu; //change for 5.2 
logic           gate_marmux;

logic [1:0]     pcmux;

logic [15:0]    mar; 
logic [15:0]    mdr;
logic [15:0]    ir;
logic [15:0]    pc;
logic           ben;


logic           mio_en;

logic [15:0]    bus;
// logic [15:0]    alu; //change for 5.2 
logic [15:0]    pcmux_out;
logic [15:0]    mio_en_out;

assign mem_addr = mar;
assign mem_wdata = mdr;

// State machine, you need to fill in the code here as well
// .* auto-infers module input/output connections which have the same name
// This can help visually condense modules with large instantiations, 
// but can also lead to confusing code if used too commonly
control cpu_control (
    .*
); 

assign led_o = ir;
assign hex_display_debug = ir;

bus_mux busmux (
    .GateMAR(1'b0), //change for 5.2 
    .GatePC(gate_pc),
    .GateMDR(gate_mdr),
    .GateALU(1'b0), //change for 5.2 
    .ADDR(16'h0000), // change for 5.2
    .PC(pc),
    .MDR(mdr),
    .ALU(16'h0000), //change for 5.2 
        
    .data_bus(bus)
);

pc_mux PCmux(
    .data_bus(bus),
    .gate_marmux(16'h0000), // change for 5.2
    .pc_plus_1(pc + 1),
    
    .select(pcmux),

    .pcmux_out(pcmux_out)
);

mio_en_mux miomux(
    .data_bus(bus),
    .rdata(mem_rdata),

    .mio_en(mio_en),

    .mio_en_mux_out(mio_en_out)
);

load_reg #(.DATA_WIDTH(16)) ir_reg (
    .clk    (clk),
    .reset  (reset),

    .load   (ld_ir),
    .data_i (bus),

    .data_q (ir)
);

load_reg #(.DATA_WIDTH(16)) pc_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_pc),
    .data_i(pcmux_out),

    .data_q(pc)
);

load_reg #(.DATA_WIDTH(16)) mdr_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_mdr),
    .data_i(mio_en_out),

    .data_q(mdr)
);

load_reg #(.DATA_WIDTH(16)) mar_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_mar),
    .data_i(bus),

    .data_q(mar)
);

endmodule