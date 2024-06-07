`timescale 1ns / 1ps
module PCPlus4(
	input [12:0] pc_in,
	output [12:0] pc_out
    );
    assign pc_out = pc_in + 4;
endmodule