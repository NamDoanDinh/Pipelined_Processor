module data_memory(
      input   [10:0] addr_i,
      input          wren_i,
      input   [31:0] wdata_i,
      output  [31:0] rdata_o,
      input  clk_i, rst_ni
      );
      
      reg [31:0] DMEM [0:2047];
      
      always @(posedge clk_i) begin
        if (wren_i) DMEM[addr_i / 4] <=  wdata_i;
      end      
      assign rdata_o = DMEM[addr_i / 4];    
endmodule 


////-----------------------------------------------------------------------------
//// Project:         RISCV - RV32I - Single Cycle 
//// Module:          DMEM
//// File:            data_memory.sv
//// Date created:    2024-03-21
//// Author:          Rivers Hoang
//// Description:     Data memory 2KB
//// DO NOT USE "for,while,-,<, >"
////-----------------------------------------------------------------------------
//module data_memory #(
//  parameter int unsigned DMEM_W = 11
//) (
//  // APB Protocol
//  input  logic [DMEM_W-1:0] addr_i  ,
//  input  logic              wren_i ,
//  input  logic [31:0]       wdata_i ,
////   input  logic [3:0]        strb_i  ,
//  output logic [31:0]       rdata_o ,

//  /* verilator lint_off UNUSED */
//  input  logic              clk_i   ,
//  input  logic              rst_ni
//  /* verilator lint_on UNUSED */
//);

//  /* verilator lint_off UNUSED */
//  logic unused;
//  assign unused = |addr_i[1:0];
//  /* verilator lint_on UNUSED */

//  logic [3:0][7:0] dmem [0:2**(DMEM_W-2)-1];

//  // Read - Write
//  always_ff @(posedge clk_i) begin : proc_data
//    if (wren_i) begin
//    // with 32 bit data, bitmask has 3 bits
//    // in order to decide write 1 byte, 2 bytes or 4 bytes
//    //  if (strb_i[0]) begin
//        dmem[addr_i[DMEM_W-1:2]][0] <= wdata_i[ 7: 0];
//    //  end
//   //   if (strb_i[1]) begin
//        dmem[addr_i[DMEM_W-1:2]][1] <= wdata_i[15: 8];
//   //   end
//    //  if (strb_i[2]) begin
//        dmem[addr_i[DMEM_W-1:2]][2] <= wdata_i[23:16];
//   //   end
//   //   if (strb_i[3]) begin
//        dmem[addr_i[DMEM_W-1:2]][3] <= wdata_i[31:24];
//   //   end
//    end
//    // $writememh("E:/memory/data_mem.mem", dmem);
//  end

//  assign rdata_o = dmem[addr_i[DMEM_W-1:2]];

//endmodule : data_memory

