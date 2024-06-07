module reg_E(
    input clk, aclr, sclr,
    input mem_wrenD, op_b_selD, op_a_selD, br_unsignedD, rd_wrenD,
    input [1:0] wb_selD,
    input [3:0] alu_opD,
    output reg  mem_wrenE, op_b_selE, op_a_selE, br_unsignedE, rd_wrenE,
    output reg [1:0] wb_selE,
    output reg [3:0] alu_opE,    
    input [12:0] pcD,
    input [31:0] rs1_dataD, rs2_dataD, immD,
    output reg [12:0] pcE, 
    output reg [31:0] rs1_dataE, rs2_dataE, immE,
    input [4:0] rs1_addrD, rs2_addrD, rd_addrD,
    output reg [4:0] rs1_addrE, rs2_addrE, rd_addrE,
    input [12:0] pc_fourD,
    output reg [12:0] pc_fourE,  
    input [31:0] instrD,
    output reg [31:0] instrE
    );
    
    always @(posedge clk, negedge aclr) begin
        if(!aclr) {wb_selE, mem_wrenE, alu_opE, op_b_selE, op_a_selE, br_unsignedE, rd_wrenE, pcE, rs1_dataE, rs2_dataE, immE, rs1_addrE, rs2_addrE, rd_addrE, pc_fourE, instrE} <= 0;
        else if (sclr) {wb_selE, mem_wrenE, alu_opE, op_b_selE, op_a_selE, br_unsignedE, rd_wrenE, pcE, rs1_dataE, rs2_dataE, immE, rs1_addrE, rs2_addrE, rd_addrE, pc_fourE, instrE} <= 0;
        else {wb_selE, mem_wrenE, alu_opE, op_b_selE, op_a_selE, br_unsignedE, rd_wrenE, pcE, rs1_dataE, rs2_dataE, immE, rs1_addrE, rs2_addrE, rd_addrE, pc_fourE, instrE} 
          <= {wb_selD, mem_wrenD, alu_opD, op_b_selD, op_a_selD, br_unsignedD, rd_wrenD, pcD, rs1_dataD, rs2_dataD, immD, rs1_addrD, rs2_addrD, rd_addrD, pc_fourD, instrD};
    end
endmodule
