module JumpDes_MUX(
    input jalr_detect,
    input [31:0] PCplusIMM, alu_dataE,
    output [31:0] JumpDes
    );
    assign JumpDes = jalr_detect ? alu_dataE : PCplusIMM;
endmodule
