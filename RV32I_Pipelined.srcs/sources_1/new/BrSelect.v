module BrSelect(
    input br_less, br_equal,
    input [31:0] instrE,
    output reg br_selE, jalr_detect
    );
    
  wire [6:0] opcode, funct7;
  wire [2:0] funct3;

  assign opcode = instrE[6:0];
  assign funct3 = instrE[14:12];
  assign funct7 = instrE[31:25]; 

  // signature of each intructions
  localparam LUI   = 7'b0110111;    //U-type LUI  
  localparam AUIPC = 7'b0010111;    //U-type AUIPC
  localparam JAL   = 7'b1101111;    //J-type
  localparam JALR  = 7'b1100111;    //I-type JALR
  localparam B     = 7'b1100011;    //B-type
  localparam L     = 7'b0000011;    //I-type Load
  localparam S     = 7'b0100011;    //I-type Store
  localparam LSW   = 3'b010;        //I-type funct3 0x2, LW SW
  localparam I     = 7'b0010011;    //I-type Immediate
  localparam R     = 7'b0110011;    //R-type
  localparam Rf7   = 7'b0000000;    //R-type funct7 0x00
  localparam Rf7n  = 7'b0100000;    //R-type funct7 0x20
  localparam EQ    = 3'b000;        //B-type funct3 0x0
  localparam NE    = 3'b001;        //B-type funct3 0x1
  localparam LT    = 3'b100;        //B-type funct3 0x4
  localparam GE    = 3'b101;        //B-type funct3 0x5
  localparam LTU   = 3'b110;        //B-type funct3 0x6
  localparam GEU   = 3'b111;        //B-type funct3 0x7
  localparam ADDs  = 3'b000;        //R-type I-type funct3 0x0, ADDs
  localparam SLLs  = 3'b001;        //R-type I-type funct3 0x1, SLLs
  localparam SLTs  = 3'b010;        //R-type I-type funct3 0x2, SLTs
  localparam SLTUs = 3'b011;        //R-type I-type funct3 0x3, SLTUs
  localparam XORs  = 3'b100;        //R-type I-type funct3 0x4, XORs
  localparam SRs   = 3'b101;        //R-type I-type funct3 0x5, SRs
  localparam ORs   = 3'b110;        //R-type I-type funct3 0x6, ORs
  localparam ANDs  = 3'b111;        //R-type I-type funct3 0x7, ANDs   
    
    always @(*) begin
    if (opcode == JAL)                                      //3. JAL
      begin br_selE = 1; jalr_detect = 0; end
    else if (opcode == JALR && funct3 == 3'b000)            //4. JALR
      begin br_selE = 1; jalr_detect = 1; end
    else if (opcode == B &&funct3 == EQ)                    //5. BEQ
      if(br_equal)  begin br_selE = 1; jalr_detect = 0; end
      else          begin br_selE = 0; jalr_detect = 0; end
    else if (opcode == B && funct3 == NE)                   //6. BNE
      if(!br_equal) begin br_selE = 1; jalr_detect = 0; end
      else          begin br_selE = 0; jalr_detect = 0; end
    else if (opcode == B && funct3 == LT)                   //7. BLT
      if(br_less)   begin br_selE = 1; jalr_detect = 0; end
      else          begin br_selE = 0; jalr_detect = 0; end  
    else if (opcode == B && funct3 == GE)                   //8. BGE
      if((!br_less && !br_equal) || br_equal)   begin br_selE = 1; jalr_detect = 0; end
      else                                      begin br_selE = 0; jalr_detect = 0; end
    else if (opcode == B && funct3 == LTU)                  //9. BLTU
      if(br_less)   begin br_selE = 1; jalr_detect = 0; end
      else          begin br_selE = 0; jalr_detect = 0; end
    else if (opcode == B && funct3 == GEU)                  //10. BGEU
      if((!br_less && !br_equal) || br_equal)   begin br_selE = 1; jalr_detect = 0; end
      else                                      begin br_selE = 0; jalr_detect = 0; end
    else begin br_selE = 0; jalr_detect = 0; end    
    end
    
endmodule
