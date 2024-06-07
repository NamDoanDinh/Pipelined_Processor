module pipelineProcessor(   //debug
    output [1:0] wb_selD_x, wb_selE_x, wb_selM_x, wb_selW_x,
    output [3:0] alu_opD_x, alu_opE_x,
    output rd_wrenD_x, rd_wrenE_x, rd_wrenM_x, rd_wrenW_x,
    output [12:0] pc_x, pcD_x, pcE_x,
    output [31:0] instr_x, instrD_x, instrE_x, immE_x,
    output [4:0] rs1_addrD_x, rs1_addrE_x, rs2_addrD_x, rs2_addrE_x,
                 rd_addrD_x, rd_addrE_x, rd_addrM_x, rd_addrW_x,
    output [1:0] FWa_sel_x, FWb_sel_x,
    output [31:0] wb_data_x,
    output [31:0] rs1_dataD_x, rs2_dataD_x,
    output [31:0] rs1_dataE_x, FwaE_x, oprand_aE_x,
                  rs2_dataE_x, FWbE_x, oprand_bE_x,
                  alu_dataE_x, alu_dataM_x, alu_dataW_x,
    output StallF_x, StallD_x, FlushD_x, FlushE_x,
    output br_less_x, br_equal_x, br_sel_x,
 
    //
    input         clk_i, rst_ni,
    input  [31:0] io_sw_i,
    output [12:0] pc_debug,
    output [31:0] io_lcd_o, io_ledg_o, io_ledr_o,
    output [31:0] io_hex0_o, io_hex1_o, io_hex2_o, io_hex3_o, io_hex4_o, io_hex5_o, io_hex6_o, io_hex7_o    
    );
    
    //debug
    assign {wb_selD_x, wb_selE_x, wb_selM_x, wb_selW_x} = {wb_selD, wb_selE, wb_selM, wb_selW};
    assign {alu_opD_x, alu_opE_x} = {alu_opD, alu_opE};
    assign {rd_wrenD_x, rd_wrenE_x, rd_wrenM_x, rd_wrenW_x} = {rd_wrenD, rd_wrenE, rd_wrenM, rd_wrenW};
    assign {pc_x, pcD_x, pcE_x} = {pc, pcD, pcE};
    assign {instr_x, instrD_x, instrE_x, immE_x} = {instr, instrD, instrE, immE};
    assign {rs1_addrD_x, rs1_addrE_x, rs2_addrD_x, rs2_addrE_x} = {rs1_addrD, rs1_addrE, rs2_addrD, rs2_addrE};
    assign {rd_addrD_x, rd_addrE_x, rd_addrM_x, rd_addrW_x} = {rd_addrD, rd_addrE, rd_addrM, rd_addrW};
    assign {FWa_sel_x, FWb_sel_x} = {FWa_sel, FWb_sel};
    assign wb_data_x = wb_data;
    assign {rs1_dataD_x, rs2_dataD_x} = {rs1_dataD, rs2_dataD};
    assign {rs1_dataE_x, FwaE_x, oprand_aE_x} = {rs1_dataE, FWaE, oprand_aE};
    assign {rs2_dataE_x, FWbE_x, oprand_bE_x} = {rs2_dataE, FWbE, oprand_bE};
    assign {alu_dataE_x, alu_dataM_x, alu_dataW_x} = {alu_dataE, alu_dataM, alu_dataW};
    assign {StallF_x, StallD_x, FlushD_x, FlushE_x} = {StallF, StallD, FlushD, FlushE};
    assign {br_less_x, br_equal_x, br_sel_x} = {br_less, br_equal, br_selE};
    //
        
    wire [12:0] pc, pcD, pcE, nxt_pc, pc_four, pc_fourD, pc_fourE, pc_fourM, pc_fourW;
    wire [31:0] instr, instrD, instrE, immD, immE;
    wire [31:0] rs1_dataD, rs2_dataD, rs1_dataE, rs2_dataE, FWaE, FWbE, FWbM, oprand_aE, oprand_bE, alu_dataE, alu_dataM, alu_dataW;
    wire [31:0] ld_data_oM, ld_data_oW, wb_data;
    wire [31:0] PCplusIMM, JumpDes;
    wire [4:0] rs1_addrD, rs1_addrE, rs2_addrD, rs2_addrE, rd_addrD, rd_addrE, rd_addrM, rd_addrW;
    wire [1:0] wb_selD, wb_selE, wb_selM, wb_selW;
    wire [3:0] alu_opD, alu_opE;
    wire mem_wrenD, mem_wrenE, mem_wrenM;
    wire br_less, br_equal;
    wire op_b_selD, op_b_selE, op_a_selD, op_a_selE, br_unsignedD, br_unsignedE;
    wire rd_wrenD, rd_wrenE, rd_wrenM, rd_wrenW;
    wire br_selE, jalr_detect;
    wire StallF, StallD, FlushD, FlushE; 
    wire [1:0] FWb_sel, FWa_sel;
    
    
    
    assign pc_debug = pc;
    
    br_mux Branch_Mux (.br_sel(br_selE), .alu_data(JumpDes[12:0]), .pc_four(pc_four), .nxt_pc(nxt_pc));
    
    reg_F PipeF (.clk(clk_i), .aclr(rst_ni), .en(~StallF), .nxt_pc(nxt_pc), .pc(pc));
    PCPlus4 Plus4 (.pc_in(pc), .pc_out(pc_four));
    inst_memory IMEM (.paddr_i(pc), .prdata_o(instr), .clk_i(clk_i), .rst_ni(rst_ni));
    
    reg_D PipeD (.clk(clk_i), .aclr(rst_ni), .sclr(FlushD), .en(~StallD), 
                 .instr(instr), .instrD(instrD),
                 .pc_four(pc_four), .pc(pc), .pcD(pcD), .pc_fourD(pc_fourD));          
    reg_dec Instr_Decoder (.instr(instrD), .rs1_addr(rs1_addrD), .rs2_addr(rs2_addrD), .rd_addr(rd_addrD));
    immGen Instruction_Generator (.instr(instrD), .imm(immD));
    reg_file Register_File (
        .clk(clk_i),
        .rst(rst_ni),
        .rs1_addr(rs1_addrD),
        .rs2_addr(rs2_addrD),
        .rd_addr(rd_addrW),
        .rd_data(wb_data),
        .rd_wren(rd_wrenW),
        .rs1_data(rs1_dataD),
        .rs2_data(rs2_dataD)
    );
    
    reg_E PipeE     (.clk(clk_i), .aclr(rst_ni), .sclr(FlushE),
                     .mem_wrenD(mem_wrenD), .op_b_selD(op_b_selD), .op_a_selD(op_a_selD), .br_unsignedD(br_unsignedD), .rd_wrenD(rd_wrenD),
                     .wb_selD(wb_selD), .alu_opD(alu_opD),
                     .mem_wrenE(mem_wrenE), .op_b_selE(op_b_selE), .op_a_selE(op_a_selE), .br_unsignedE(br_unsignedE), .rd_wrenE(rd_wrenE),
                     .wb_selE(wb_selE), .alu_opE(alu_opE),
                     .pcD(pcD), .pcE(pcE),
                     .rs1_dataD(rs1_dataD), .rs2_dataD(rs2_dataD), .immD(immD),
                     .rs1_dataE(rs1_dataE), .rs2_dataE(rs2_dataE), .immE(immE),
                     .rs1_addrD(rs1_addrD), .rs2_addrD(rs2_addrD), .rd_addrD(rd_addrD),
                     .rs1_addrE(rs1_addrE), .rs2_addrE(rs2_addrE), .rd_addrE(rd_addrE),
                     .pc_fourD(pc_fourD), .pc_fourE(pc_fourE), .instrE(instrE), .instrD(instrD)                
                    );
    FWa_MUX FowardingA (.rs1_dataE(rs1_dataE), .alu_dataM(alu_dataM), .wb_data(wb_data),
                        .FWa_sel(FWa_sel),
                        .FWaE(FWaE));
    FWb_MUX ForwadingB (.rs2_dataE(rs2_dataE), .alu_dataM(alu_dataM), .wb_data(wb_data),
                        .FWb_sel(FWb_sel),
                        .FWbE(FWbE)
                        );
    brcomp Branch_Compare (.rs1_data(FWaE), .rs2_data(FWbE), .br_unsigned(br_unsignedE), .br_less(br_less), .br_equal(br_equal));
    BrSelect Branch_Select(.br_less(br_less), .br_equal(br_equal), .instrE(instrE), .br_selE(br_selE), .jalr_detect(jalr_detect));
    PCplusIMM PC_Plus_Immediate (.pcE(pcE), .immE(immE), .PCplusIMM(PCplusIMM));
    JumpDes_MUX Jump_Destination_MUX (.jalr_detect(jalr_detect), .PCplusIMM(PCplusIMM), .alu_dataE(alu_dataE), .JumpDes(JumpDes));
    op_a_mux OprandA_Mux (.pc(pcE), .rs1_data(FWaE), .op_a_sel(op_a_selE), .operand_a(oprand_aE));
    op_b_mux OprandB_Mux (.imm(immE), .rs2_data(FWbE), .op_b_sel(op_b_selE), .operand_b(oprand_bE)); 
    alu ALU (.oprand_a(oprand_aE), .oprand_b(oprand_bE), .alu_op(alu_opE), .alu_data(alu_dataE));
    
    reg_M PipeM     (.clk(clk_i), .aclr(rst_ni),
                     .mem_wrenE(mem_wrenE), .rd_wrenE(rd_wrenE),
                     .wb_selE(wb_selE),
                     .FWbE(FWbE), .alu_dataE(alu_dataE),
                     .rd_addrE(rd_addrE), .pc_fourE(pc_fourE),
                     .mem_wrenM(mem_wrenM), .rd_wrenM(rd_wrenM),
                     .wb_selM(wb_selM),
                     .FWbM(FWbM), .alu_dataM(alu_dataM),
                     .rd_addrM(rd_addrM), .pc_fourM(pc_fourM)
                     );
    lsu LSU (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .st_en_i(mem_wrenM),
        .addr_i(alu_dataM[11:0]),
        .st_data_i(FWbM),
        .io_sw_i(io_sw_i),
        .ld_data_o(ld_data_oM),
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
    
    reg_W PipeW     (.clk(clk_i), .aclr(rst_ni),
                     .rd_wrenM(rd_wrenM),
                     .wb_selM(wb_selM),
                     .rd_wrenW(rd_wrenW),
                     .wb_selW(wb_selW),
                     .ld_data_oM(ld_data_oM), .alu_dataM(alu_dataM),
                     .ld_data_oW(ld_data_oW), .alu_dataW(alu_dataW),
                     .rd_addrM(rd_addrM), .rd_addrW(rd_addrW),
                     .pc_fourM(pc_fourM), .pc_fourW(pc_fourW)
                     ); 
    wb_mux WriteBack_MUX (.pc_four(pc_fourW), .alu_data(alu_dataW), .ld_data(ld_data_oW), .wb_sel(wb_selW), .wb_data(wb_data));
                                             
    ctrl_unit Control_Unit (
      .instr(instrD),
      .br_less(0),
      .br_equal(0),
      .br_sel(),
      .rd_wren(rd_wrenD),
      .br_unsigned(br_unsignedD),
      .op_a_sel(op_a_selD),
      .op_b_sel(op_b_selD),
      .mem_wren(mem_wrenD),
      .alu_op(alu_opD),
      .wb_sel(wb_selD)
    );
    
    Hazard_Unit HazardUnit (
    .br_sel(br_selE), .rd_wrenM(rd_wrenM), .rd_wrenW(rd_wrenW),
    .wb_selE(wb_selE),
    .rs1_addrD(rs1_addrD), .rs2_addrD(rs2_addrD), .rs1_addrE(rs1_addrE), .rs2_addrE(rs2_addrE), .rd_addrE(rd_addrE), .rd_addrM(rd_addrM), .rd_addrW(rd_addrW),
    .StallF(StallF), .StallD(StallD), .FlushD(FlushD), .FlushE(FlushE),
    .FWb_sel(FWb_sel), .FWa_sel(FWa_sel)
    );
    
endmodule
