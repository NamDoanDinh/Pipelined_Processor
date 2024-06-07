module brcomp (
	input [31:0] rs1_data, rs2_data,  
	input br_unsigned,
	output reg br_less,
	output reg br_equal
);
    // if a & b is unsigned number, it's better to extend the MSB
    // Verilog still consider u_oprand_a & u_oprand_b as 2's compelement numbers
    // but now it's all positive numbers
    wire [32:0] u_rs1_data, u_rs2_data;
	wire [31:0] signed_sub;
	wire [32:0] unsigned_sub;
	assign u_rs1_data = {1'b0, rs1_data};
	assign u_rs2_data = {1'b0, rs2_data};
	assign signed_sub = rs1_data + ~rs2_data + 1;
	assign unsigned_sub = u_rs1_data + ~u_rs2_data + 1;
	
	always @(*) begin
	   if (br_unsigned) begin
	       br_less = unsigned_sub[32] ? 1 : 0;
	       br_equal = ~|signed_sub;    //Reduction
	   end
	   else begin
	       br_less = signed_sub[31] ? 1 : 0;
	       br_equal = ~|signed_sub;    //Reduction
	   end
	end
endmodule