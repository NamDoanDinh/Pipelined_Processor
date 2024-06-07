module reg_F (
	input clk, aclr,
	input en,           // stall
	input [12:0] nxt_pc,
	output reg [12:0] pc 
);

	always @ (posedge clk, negedge aclr) begin
		if (!aclr) pc <= 0;
		else if (en) pc <= nxt_pc;
	end

endmodule

