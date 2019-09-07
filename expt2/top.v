`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:06:11 08/29/2019 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define REG_SIZE 32
`define MEM_SIZE 1024
`define OPWIDTH 6
`define REG_ADDR_SIZE 5
`define NUM_CHECK 6

module top(
	input clk
    );
	 
    wire [`REG_SIZE-1:0] reg_indata;
    wire [`REG_ADDR_SIZE-1:0] rs1;
    wire [`REG_ADDR_SIZE-1:0] rs2;
    wire [`REG_ADDR_SIZE-1:0] rd;
    wire [`REG_SIZE-1:0] rv1;
    wire [`REG_SIZE-1:0] rv2;
	 wire reg_we;
    
    wire [`REG_SIZE-1:0] dmem_daddr;
    wire [1:0] dmem_we;
    wire [`REG_SIZE-1:0] dmem_indata;
    wire [`REG_SIZE-1:0] dmem_outdata;
	 
    wire [`REG_SIZE-1:0] imem_idata;
	 wire [`REG_SIZE-1:0] imem_iaddr;
	wire [35:0]         vio_control, ila_control;
	dmem dmem_instance(.daddr(dmem_daddr),.clk(clk),.we(dmem_we),.indata(dmem_indata),.outdata(dmem_outdata));
	imem imem_instance(.iaddr(imem_iaddr),.idata(imem_idata),.clk(clk));
	regfile regfile_instance(.rs1(rs1),.rs2(rs2),.rd(rd),.we(reg_we),.clk(clk),.indata(reg_indata),.rv1(rv1),.rv2(rv2));
	
	icon2 icon_instance(
	 .CONTROL0(vio_control), // INOUT BUS [35:0]
    .CONTROL1(ila_control) // INOUT BUS [35:0]
	);
	vio2 vio_instance(
	    .CONTROL(vio_control),// INOUT BUS [35:0]
		 .SYNC_OUT({reg_we,reg_indata,rs1,rs2,rd,dmem_we,dmem_daddr,dmem_indata,imem_iaddr}),// OUT BUS [144:0]
		 .SYNC_IN({rv1,rv2,dmem_outdata,imem_idata}),// IN BUS [127:0]
		 .CLK(clk)
		 );
	ila2 ila_instance(.CONTROL(ila_control), // INOUT BUS [35:0]
    .CLK(clk),
    .TRIG0(rv1),// IN BUS [31:0]
    .TRIG1(rv2),// IN BUS [31:0]
	 .TRIG2(dmem_outdata),// IN BUS [31:0]
	 .TRIG3(imem_idata));// IN BUS [31:0]
endmodule
