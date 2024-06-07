module reg_W(
    input clk, aclr,
    input             rd_wrenM,
    input      [1:0]  wb_selM,
    output reg        rd_wrenW,
    output reg [1:0]  wb_selW,
    input      [31:0] ld_data_oM, alu_dataM,
    output reg [31:0] ld_data_oW, alu_dataW,
    input      [4:0]  rd_addrM,
    output reg [4:0]  rd_addrW,
    input      [12:0] pc_fourM,
    output reg [12:0] pc_fourW
    );
    
    always @(posedge clk, negedge aclr) begin
        if (!aclr) {wb_selW, rd_wrenW, ld_data_oW, alu_dataW, rd_addrW, pc_fourW} <= 0;
        else       {wb_selW, rd_wrenW, ld_data_oW, alu_dataW, rd_addrW, pc_fourW} 
                <= {wb_selM, rd_wrenM, ld_data_oM, alu_dataM, rd_addrM, pc_fourM};
        
    end
    
endmodule