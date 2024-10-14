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
logic           ld_ben; 
logic           ld_cc; 
logic           ld_reg; 

logic           mio_en;

logic           gate_pc;
logic           gate_mdr;
logic           gate_alu; 
logic           gate_marmux;

logic [1:0]     pcmux;

logic [15:0]    mar; 
logic [15:0]    mdr;
logic [15:0]    ir;
logic [15:0]    pc;
logic           ben;
logic [2:0]     nzp;
logic [2:0]     logic_nzp;

logic [15:0]    bus;                //assuming busmux out
logic [15:0]    alu;
logic [15:0]    pcmux_out;
logic [15:0]    mio_en_out;

logic           addr1mux;           //the select for the mux
logic           addr2mux;           //the select for the addr2 mux
logic [1:0]     aluk;               //what alu function to do
logic           addr1_mux_out;      //the output of the mux
logic           addr2_mux_out;      //the output of the addr2 mux

logic [15:0]    sr1_out;
logic [15:0]    sr2_out;
logic [15:0]    sr2mux_out;
logic [15:0]    sr1mux_out;
logic [2:0]     drmux_out;
logic           drmux_control;

logic           sr2muxcontrol;      //sr2 mux control
logic           sr1muxcontrol;      //sr1 mux control


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
    .GateMAR(gate_marmux),
    .GatePC(gate_pc),
    .GateMDR(gate_mdr),
    .GateALU(gate_alu),
    .ADDR(addr1_mux_out + addr2_mux_out),
    .PC(pc),
    .MDR(mdr),
    .ALU(alu),
        
    .data_bus(bus)
);

pc_mux PCmux(
    .data_bus(bus),
    .gate_marmux(addr1_mux_out + addr2_mux_out),
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

regfile register_file (
    .clk(clk),
    .reset(reset),

    .ld_reg(ld_reg),
    .sr1(sr1mux_out),
    .sr2(ir[2:0]),
    .dr(drmux_out),
    .data_bus(bus),

    .sr2_out(sr2_out),
    .sr1_out(sr1_out)
);

addr1_mux addr1(
    .pc(pc),
    .sr1_out(sr1_out),

    .addr1mux(addr1mux),

    .addr1_mux_out(addr1_mux_out)
),

addr2_mux addr2(
    .elevenbits({ir[10], ir[10], ir[10], ir[10], ir[10], ir[10:0]}),
    .ninebits({ir[8], ir[8], ir[8], ir[8], ir[8], ir[8], ir[8], ir[8:0]}),
    .sixbits({ir[5], ir[5], ir[5], ir[5], ir[5], ir[5], ir[5], ir[5], ir[5], ir[5], ir[5:0]}),
    .zeroes(0), // check if error is 0

    .addr2mux(addr2mux),

    .addr2_mux_out(addr2_mux_out)
);


sr1_mux sr1mux(
    .eleventhrnine(ir[11:9]),
    .eightthrsix(ir[8:6]),

    .sr1(sr1muxcontrol),

    .sr1mux_out(sr1mux_out)
);


sr2_mux sr2mux(
    .sr2_out(sr2_out),
    .ir(ir[4], ir[4], ir[4], ir[4], ir[4], ir[4], ir[4], ir[4], ir[4], ir[4], ir[4], ir[4:0]),

    .control(sr2mux_control),

    .sr2mux_out(sr2mux_out)
);

alu_mux alumux(
    .aluk(aluk),
    .A(sr1_out),
    .B(sr2mux_out),
    
    .alu(alu)
);

dr_mux dr_load(
    .ir(ir[11:9]),
    .ones(3'b111),

    .control(drmux_control),

    .drmux_out(drmux_out)
);

always_comb
begin
    if (bus == 0) // z
        logic_nzp = 3'b010;
    else if (bus[15] == 1) // n
        logic_nzp = 3'b100;
    else if (bus[15] == 0) // p
        logic_nzp = 3'b001;
    else
        logic_nzp = 3'b000;
end

load_reg #(.DATA_WIDTH(3)) nzp_reg (
    .clk    (clk),
    .reset  (reset),

    .load   (ld_cc),
    .data_i (logic_nzp),

    .data_q (nzp)
);

load_reg #(.DATA_WIDTH(1)) ben_reg (
    .clk    (clk),
    .reset  (reset),

    .load   (ld_ben),
    .data_i (ir[11] & nzp[2] | ir[10] & nzp[1] | ir[9] & nzp[0]),

    .data_q (ben)
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