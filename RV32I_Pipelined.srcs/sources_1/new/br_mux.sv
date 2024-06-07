module br_mux (
	input br_sel,
	input [12:0] alu_data, pc_four,
	output [12:0] nxt_pc
);

	assign nxt_pc = (br_sel) ? alu_data : pc_four;

endmodule