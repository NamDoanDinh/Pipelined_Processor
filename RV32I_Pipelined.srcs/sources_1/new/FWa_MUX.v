module FWa_MUX(
    input [31:0] rs1_dataE, alu_dataM, wb_data,
    input [1:0] FWa_sel,
    output reg [31:0] FWaE
    );

    always @(*) begin
        case(FWa_sel)
            0: FWaE = rs1_dataE;
            1: FWaE = alu_dataM;
            2: FWaE = wb_data;
            default: FWaE = rs1_dataE; 
        endcase
    end
endmodule
