module reg_D(
    input clk, aclr, sclr, en,
    input       [31:0] instr,
    input       [12:0] pc, pc_four,
    output reg  [31:0] instrD,
    output reg  [12:0] pcD, pc_fourD
    );
    
    always @(posedge clk, negedge aclr) begin
        if(!aclr) begin
            instrD <= 0;
            pcD <= 0;
            pc_fourD <= 0;
        end else if (sclr) begin
            instrD <= 0;
            pcD <= 0;
            pc_fourD <= 0;
        end else if (en) begin
            instrD <= instr;
            pcD <= pc;
            pc_fourD <= pc_four;
        end
    end
endmodule
