module reg_file (
    input           clk, rst,
    input [4:0]     rs1_addr, rs2_addr, rd_addr,
    input [31:0]    rd_data,
    input	        rd_wren,
    output [31:0] rs1_data, rs2_data
);

	//x0-x31 32bits
	reg [31:0] register [0:31];
	integer i;
	always @(negedge clk or negedge rst) begin
		if (!rst) begin
			for (i = 0; i < 32; i = i + 1) begin
				register[i] <= 32'h0;
			end
		end
		else if (rd_wren && rd_addr != 0) begin
			register[rd_addr] <= rd_data;
		end
	end
	assign rs1_data = register[rs1_addr];            
    assign rs2_data = register[rs2_addr];
	//register[5'b00000] <= 32'h00000000;        //hard-write x0 = 0
	
endmodule