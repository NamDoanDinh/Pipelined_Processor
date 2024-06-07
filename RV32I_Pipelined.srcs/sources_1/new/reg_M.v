module reg_M(
    input clk, aclr,
    input mem_wrenE, rd_wrenE,
    input [1:0] wb_selE,
    input [31:0] FWbE, alu_dataE,
    input [4:0] rd_addrE,
    input [12:0] pc_fourE,
    output reg mem_wrenM, rd_wrenM,
    output reg [1:0] wb_selM,
    output reg [31:0] FWbM, alu_dataM,
    output reg [4:0] rd_addrM,
    output reg [12:0] pc_fourM
    );
    
    always @(posedge clk, negedge aclr) begin
        if (!aclr)  {wb_selM, mem_wrenM, rd_wrenM, FWbM, alu_dataM, rd_addrM, pc_fourM} <= 0;
        else        {wb_selM, mem_wrenM, rd_wrenM, FWbM, alu_dataM, rd_addrM, pc_fourM} <=
                    {wb_selE, mem_wrenE, rd_wrenE, FWbE, alu_dataE, rd_addrE, pc_fourE};
    end
endmodule
