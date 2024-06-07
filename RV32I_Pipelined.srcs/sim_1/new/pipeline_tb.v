`timescale 1ns / 1ps
module pipeline_tb;
  //debug
    wire [1:0] wb_selD_x, wb_selE_x, wb_selM_x, wb_selW_x;
    wire [3:0] alu_opD_x, alu_opE_x;
    wire rd_wrenD_x, rd_wrenE_x, rd_wrenM_x, rd_wrenW_x;
    wire [12:0] pc_x, pcD_x, pcE_x;
    wire [31:0] instr_x, instrD_x, instrE_x, immE_x;
    wire [4:0] rs1_addrD_x, rs1_addrE_x, rs2_addrD_x, rs2_addrE_x,
                 rd_addrD_x, rd_addrE_x, rd_addrM_x, rd_addrW_x;
    wire [1:0] FWa_sel_x, FWb_sel_x;
    wire [31:0] wb_data_x;
    wire [31:0] rs1_dataD_x, rs2_dataD_x;
    wire [31:0] rs1_dataE_x, FwaE_x, oprand_aE_x,
                  rs2_dataE_x, FWbE_x, oprand_bE_x,
                  alu_dataE_x, alu_dataM_x, alu_dataW_x;  
    wire StallF_x, StallD_x, FlushD_x, FlushE_x;
    wire br_less_x, br_equal_x, br_sel_x;
  //
  wire [12:0] pc_debug;
  reg clk_i, rst_ni;
  reg [31:0] io_sw_i;
  wire [31:0] io_lcd_o, io_ledg_o, io_ledr_o, 
  io_hex0_o, io_hex1_o, io_hex2_o, io_hex3_o, io_hex4_o, io_hex5_o, io_hex6_o, io_hex7_o;

	pipelineProcessor dut (
	    //debug
        .wb_selD_x(wb_selD_x), .wb_selE_x(wb_selE_x), .wb_selM_x(wb_selM_x), .wb_selW_x(wb_selW_x),
        .alu_opD_x(alu_opD_x), .alu_opE_x(alu_opE_x),
        .rd_wrenD_x(rd_wrenD_x), .rd_wrenE_x(rd_wrenE_x), .rd_wrenM_x(rd_wrenM_x), .rd_wrenW_x(rd_wrenW_x),
        .pc_x(pc_x), .pcD_x(pcD_x), .pcE_x(pcE_x),
        .instr_x(instr_x), .instrD_x(instrD_x), .instrE_x(instrE_x),.immE_x(immE_x),
        .rs1_addrD_x(rs1_addrD_x), .rs1_addrE_x(rs1_addrE_x), .rs2_addrD_x(rs2_addrD_x), .rs2_addrE_x(rs2_addrE_x),
        .rd_addrD_x(rd_addrD_x), .rd_addrE_x(rd_addrE_x), .rd_addrM_x(rd_addrM_x), .rd_addrW_x(rd_addrW_x),
        .FWa_sel_x(FWa_sel_x), .FWb_sel_x(FWb_sel_x),
        .wb_data_x(wb_data_x),
        .rs1_dataD_x(rs1_dataD_x), .rs2_dataD_x(rs2_dataD_x),
        .rs1_dataE_x(rs1_dataE_x), .FwaE_x(FwaE_x), .oprand_aE_x(oprand_aE_x),
        .rs2_dataE_x(rs2_dataE_x), .FWbE_x(FWbE_x), .oprand_bE_x(oprand_bE_x),
        .alu_dataE_x(alu_dataE_x), .alu_dataM_x(alu_dataM_x), .alu_dataW_x(alu_dataW_x),
        .StallF_x(StallF_x), .StallD_x(StallD_x), .FlushD_x(FlushD_x), .FlushE_x(FlushE_x),
        .br_less_x(br_less_x), .br_equal_x(br_equal_x), .br_sel_x(br_sel_x),
        //
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.io_sw_i(io_sw_i),
		.pc_debug(pc_debug),
		.io_lcd_o(io_lcd_o),
		.io_ledg_o(io_ledg_o),
		.io_ledr_o(io_ledr_o),
		.io_hex0_o(io_hex0_o),
		.io_hex1_o(io_hex1_o),
		.io_hex2_o(io_hex2_o),
	    .io_hex3_o(io_hex3_o),
		.io_hex4_o(io_hex4_o),
		.io_hex5_o(io_hex5_o),
		.io_hex6_o(io_hex6_o),
	    .io_hex7_o(io_hex7_o)
    );

    // 100Mhz clock (Artix-7)
    initial begin
      clk_i = 0;
      io_sw_i = 32'h00003039;
      forever #5 clk_i = ~clk_i;
    end  

    initial begin
      rst_ni = 0;
      #7
      rst_ni = 1;
      #10

      #2000
      $finish;
    end

endmodule