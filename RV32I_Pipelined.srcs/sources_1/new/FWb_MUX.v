module FWb_MUX(
    input [31:0] rs2_dataE, alu_dataM, wb_data,
    input [1:0] FWb_sel,
    output reg [31:0] FWbE
    );

    always @(*) begin
        case(FWb_sel)
            0: FWbE = rs2_dataE;
            1: FWbE = alu_dataM;
            2: FWbE = wb_data;
            default: FWbE = rs2_dataE; 
        endcase
    end
endmodule
