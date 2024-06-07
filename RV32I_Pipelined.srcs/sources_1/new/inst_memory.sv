module inst_memory (
    input clk_i, rst_ni,
    input [12:0] paddr_i,
    output [31:0] prdata_o
    );
    
    reg [31:0] IMEM [0:8191];
    initial begin
        $readmemh("D:/Verilog/CompArch/RV32I_Pipelined/RV32I_Pipelined.srcs/mem_1/test2.imem", IMEM);
    end
    
    assign prdata_o = IMEM[paddr_i / 4];
    
endmodule

//module inst_memory #(
//  parameter int unsigned IMEM_W = 13
//) (
//  input  logic [IMEM_W-1:0] paddr_i ,
//  output logic [31:0]       prdata_o,
//  input  logic              clk_i   ,
//  input  logic              rst_ni
//);

//  logic unused;
//  assign unused = |paddr_i[1:0];
//  logic [3:0][7:0] imem [2**(IMEM_W-2)-1:0];
  
//  initial begin
//    $readmemh("D:/Verilog/CompArch/RV32I_Single_Cycle/RV32I_Single_Cycle.srcs/mem_1/test2.imem", imem);
//  end
  
//  always_comb begin : proc_data
//    prdata_o = imem[paddr_i[IMEM_W-1:2]][3:0];
//  end

//endmodule : inst_memory


