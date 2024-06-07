module lsu (
	input logic 	clk_i,
	input logic 	rst_ni,
	input logic 	[11:0] addr_i, 		// [11:0] alu_data, 12bits, 4KB, 2KB DMEM 2KB other
	input logic 	[31:0] st_data_i, 	// 32 bits data_in
	input logic 	st_en_i, 			// store enable
	output logic 	[31:0] ld_data_o, 	// 32 bits data_out, feed to the last mux
	
	input  logic [31:0] io_sw_i, 	// SW[31:0], 0x900
	output logic [31:0] io_lcd_o, 	// LCD[31:0], 0x8A0
	output logic [31:0] io_ledg_o, 	// LEDG[31:0], 0x890
	output logic [31:0] io_ledr_o, 	// LEDR[31:0], 0x880
	output logic [31:0] io_hex0_o, 	// HEX0[31:0], 0x800
	output logic [31:0] io_hex1_o, 	// HEX0[31:0], 0x810
	output logic [31:0] io_hex2_o, 	// HEX0[31:0], 0x820
	output logic [31:0] io_hex3_o, 	// HEX0[31:0], 0x830
	output logic [31:0] io_hex4_o, 	// HEX0[31:0], 0x840
	output logic [31:0] io_hex5_o, 	// HEX0[31:0], 0x850
	output logic [31:0] io_hex6_o, 	// HEX0[31:0], 0x860
	output logic [31:0] io_hex7_o 	// HEX0[31:0], 0x870
 	);

	// wire for data out of DMEM
	wire [31:0] r_data_dmem;
	// Register for SW
	reg [31:0] SW;
	// no need wire or reg for LEDHEX cause io_..._o already become an FF if I code like that


	//DMEM 2KB, 0x000 0x7FF 11 bits
	data_memory dmem (
		.clk_i(clk_i),
		.rst_ni(rst_ni), 
		.wren_i(st_en_i),
		.addr_i(addr_i[10:0]),		//Only 11 lower bits is needed to select 2KB DMEM
		.wdata_i(st_data_i),
		.rdata_o(r_data_dmem)
	);


	always @(posedge clk_i or negedge rst_ni) begin
		if (!rst_ni) begin
			io_lcd_o <= 0;
			io_ledg_o <= 0;
			io_ledr_o <= 0;
			io_hex0_o <= 0;
			io_hex1_o <= 0;
			io_hex2_o <= 0;
			io_hex3_o <= 0;
			io_hex4_o <= 0;
			io_hex5_o <= 0;
			io_hex6_o <= 0;
			io_hex7_o <= 0;
		end
		else if (st_en_i) begin
			case (addr_i) 
				12'h800: io_hex0_o <= st_data_i;
				12'h810: io_hex1_o <= st_data_i;
				12'h820: io_hex2_o <= st_data_i;
				12'h830: io_hex3_o <= st_data_i;
				12'h840: io_hex4_o <= st_data_i;
				12'h850: io_hex5_o <= st_data_i;
				12'h860: io_hex6_o <= st_data_i;
				12'h870: io_hex7_o <= st_data_i;
				12'h880: io_ledr_o <= st_data_i;
				12'h890: io_ledg_o <= st_data_i;
				12'h8a0: io_lcd_o <= st_data_i;
			endcase 
		end
	end
	
	
	//always get data from SW, no bidirectional
	always @(posedge clk_i) begin
		SW[31:0] <= io_sw_i[31:0];
	end

	always @(*) begin
		case(addr_i)  
            12'h800: ld_data_o = io_hex0_o;
            12'h810: ld_data_o = io_hex1_o;
            12'h820: ld_data_o = io_hex2_o;
            12'h830: ld_data_o = io_hex3_o;
            12'h840: ld_data_o = io_hex4_o;
            12'h850: ld_data_o = io_hex5_o;
            12'h860: ld_data_o = io_hex6_o;
            12'h870: ld_data_o = io_hex7_o;
            12'h880: ld_data_o = io_ledr_o;
            12'h890: ld_data_o = io_ledg_o;
            12'h8a0: ld_data_o = io_lcd_o;
            12'h900: ld_data_o = SW;
            default: ld_data_o = r_data_dmem;		//DMEM, I known it's wrong, OK
	   endcase
	end


endmodule