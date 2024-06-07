module reg_dec_tb;
    reg [31:0] instr;
    wire [4:0] rs1_addr, rs2_addr, rd_addr;
    
    reg_dec DUT(
		.instr(instr),
		.rs1_addr(rs1_addr),
		.rs2_addr(rs2_addr),
		.rd_addr(rd_addr)
    );
    
    initial begin
    instr = 32'h10000193;
    #10 $finish;
    end
   
endmodule