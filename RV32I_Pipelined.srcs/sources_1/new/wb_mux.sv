module wb_mux (
	input  [12:0]  pc_four,
	input  [31:0]  alu_data, ld_data,
	input  [1:0]   wb_sel,
	output reg [31:0]  wb_data
);

	always @(*) begin
		case (wb_sel)
			2'b00 : wb_data = alu_data;
			2'b01 : wb_data = ld_data;
			2'b10 : wb_data = pc_four;
			2'b11 : wb_data = pc_four;
		endcase
	end

endmodule