module Hazard_Unit(
    input br_sel, rd_wrenM, rd_wrenW,
    input [1:0] wb_selE,
    input [4:0] rs1_addrD, rs2_addrD, rs1_addrE, rs2_addrE, rd_addrE, rd_addrM, rd_addrW, 
    output reg StallF, StallD, FlushD, FlushE, 
    output reg [1:0] FWb_sel, FWa_sel
    );
    
    // Foward to solve RAW
    always @(*) begin
        if (rs1_addrE != 5'b0)
            if      ((rs1_addrE == rd_addrM) && rd_wrenM) FWa_sel = 2'b01;
            else if ((rs1_addrE == rd_addrW) && rd_wrenW) FWa_sel = 2'b10;
            else                                          FWa_sel = 2'b00;
		else                                              FWa_sel = 2'b00;
    end
    
    always @(*) begin
        if (rs2_addrE != 5'b0)
            if      ((rs2_addrE == rd_addrM) && rd_wrenM) FWb_sel = 2'b01;
            else if ((rs2_addrE == rd_addrW) && rd_wrenW) FWb_sel = 2'b10;
            else                                          FWb_sel = 2'b00;
		else                                              FWb_sel = 2'b00;
    end
    
    wire lwStall;
    assign lwStall = ~wb_selE[1] & wb_selE[0] & ((rs1_addrD == rd_addrE)|(rs2_addrD == rd_addrE));
    
    //Stall to slove lw hazard
    always @(*) begin
        StallF = lwStall;
        StallD = lwStall;
    end
    
    //Flush when a branch is taken or a load introduces a bubble
    always @(*) begin
        FlushD = br_sel;
        FlushE = br_sel | lwStall;
    end
endmodule