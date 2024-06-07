module alu(
    input [31:0] oprand_a,
    input [31:0] oprand_b,
    input [3:0]  alu_op,
    output reg [31:0] alu_data
    );
    
    localparam ADD  = 4'h0;    // rd = rs1 + rs2
	localparam SUB  = 4'h1;    // rd = rs1 - rs2
	localparam SLT  = 4'h2;    // rd = (rs1<rs2)?1:0
	localparam SLTU = 4'h3;    // rd = (rs1<rs2)?1:0
	localparam XOR  = 4'h4;    // rd = rs1 XOR rs2
	localparam OR   = 4'h5;    // rd = rs1 OR rs2
	localparam AND  = 4'h6;    // rd = rs1 AND rs2
	localparam SLL  = 4'h7;    // rd = rs1 << rs2[4:0]
	localparam SRL  = 4'h8;    // rd = rs1 >> rs2[4:0]
	localparam SRA  = 4'h9;    // rd = rs1 >>> rs2[4:0]
	
	// if a & b is unsigned number, it's better to extend the MSB
	// Verilog still consider u_oprand_a & u_oprand_b as 2's compelement numbers
	// but now it's all positive numbers
	wire [32:0] u_oprand_a, u_oprand_b;
	wire [31:0] SRAcase;
	wire [31:0] signed_sub;
	wire [32:0] unsigned_sub;
	
	assign u_oprand_a = {1'b0, oprand_a};
	assign u_oprand_b = {1'b0, oprand_b};
	assign signed_sub = oprand_a + ~oprand_b + 1;
	assign unsigned_sub = u_oprand_a + ~u_oprand_b + 1;
	shift_right_arithmetic inst(oprand_a, oprand_b[4:0], SRAcase);
	always @(*)begin
	case(alu_op)
	   ADD:    alu_data = oprand_a + oprand_b;
	   SUB:    alu_data = oprand_a + ~oprand_b + 1;
	   SLT:    alu_data = (signed_sub[31]) ? 1 : 0;
	   SLTU:   alu_data = (unsigned_sub[32]) ? 1 : 0;
	   XOR:    alu_data = oprand_a ^ oprand_b;
	   OR:     alu_data = oprand_a | oprand_b;
	   AND:    alu_data = oprand_a & oprand_b;
	   SLL:    alu_data = oprand_a << oprand_b[4:0];
	   SRL:    alu_data = oprand_a >> oprand_b[4:0];
	   SRA:    alu_data = SRAcase;
	   default: alu_data = 32'b0;
	endcase 
	end  
endmodule: alu

// Verilog treats >>> as a >> (maybe), just look at the rtl schematic 
// so I build a new one.       
module shift_right_arithmetic(
    input [31:0] din,
    input [4:0]  amount,
    output reg [31:0] dout 
    );
    
    wire [31:0] temp_shift;
    assign temp_shift = din >> amount;       //still logical
    always @(*)begin
    if (din[31])
    case(amount)
        5'd0 : dout = temp_shift;
		5'd1 : dout = temp_shift | 32'b10000000000000000000000000000000;
		5'd2 : dout = temp_shift | 32'b11000000000000000000000000000000;
		5'd3 : dout = temp_shift | 32'b11100000000000000000000000000000;
		5'd4 : dout = temp_shift | 32'b11110000000000000000000000000000;
		5'd5 : dout = temp_shift | 32'b11111000000000000000000000000000;
		5'd6 : dout = temp_shift | 32'b11111100000000000000000000000000;
		5'd7 : dout = temp_shift | 32'b11111110000000000000000000000000;
		5'd8 : dout = temp_shift | 32'b11111111000000000000000000000000;
		5'd9 : dout = temp_shift | 32'b11111111100000000000000000000000;
		5'd10: dout = temp_shift | 32'b11111111110000000000000000000000;
		5'd11: dout = temp_shift | 32'b11111111111000000000000000000000;
		5'd12: dout = temp_shift | 32'b11111111111100000000000000000000;
		5'd13: dout = temp_shift | 32'b11111111111110000000000000000000;
		5'd14: dout = temp_shift | 32'b11111111111111000000000000000000;
		5'd15: dout = temp_shift | 32'b11111111111111100000000000000000;
		5'd16: dout = temp_shift | 32'b11111111111111110000000000000000;
		5'd17: dout = temp_shift | 32'b11111111111111111000000000000000;
		5'd18: dout = temp_shift | 32'b11111111111111111100000000000000;
		5'd19: dout = temp_shift | 32'b11111111111111111110000000000000;
		5'd20: dout = temp_shift | 32'b11111111111111111111000000000000;
		5'd21: dout = temp_shift | 32'b11111111111111111111100000000000;
		5'd22: dout = temp_shift | 32'b11111111111111111111110000000000;
		5'd23: dout = temp_shift | 32'b11111111111111111111111000000000;
		5'd24: dout = temp_shift | 32'b11111111111111111111111100000000;
		5'd25: dout = temp_shift | 32'b11111111111111111111111110000000;
		5'd26: dout = temp_shift | 32'b11111111111111111111111111000000;
		5'd27: dout = temp_shift | 32'b11111111111111111111111111100000;
		5'd28: dout = temp_shift | 32'b11111111111111111111111111110000;
		5'd29: dout = temp_shift | 32'b11111111111111111111111111111000;
		5'd30: dout = temp_shift | 32'b11111111111111111111111111111100;
		5'd31: dout = temp_shift | 32'b11111111111111111111111111111110;
    endcase
    else dout = temp_shift;
    end
endmodule: shift_right_arithmetic