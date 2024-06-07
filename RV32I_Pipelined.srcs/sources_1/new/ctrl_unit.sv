module ctrl_unit (
  input [31:0] instr,
  input br_less, br_equal,
  output logic br_sel, rd_wren, br_unsigned, op_a_sel, op_b_sel, mem_wren,
  output logic [3:0] alu_op, //byte_en,
  output logic [1:0] wb_sel
  // output logic [2:0] ld_sel
  );
    //byte_en only for some load, store instruction without using entire word.
    //ld_sel is the idea of Mr. Phu Truong Nguyen

  wire [6:0] opcode, funct7;
  wire [2:0] funct3;

  assign opcode = instr[6:0];
  assign funct3 = instr[14:12];
  assign funct7 = instr[31:25]; 

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
    if (opcode == LUI) begin                          //1. LUI
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 0; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == AUIPC) begin                   //2. AUIPC
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 1; op_b_sel = 1; alu_op = 0; mem_wren = 0; wb_sel = 0;
    end
    
    else if (opcode == JAL) begin                     //3. JAL
      br_sel = 1; rd_wren = 1; br_unsigned = 0; op_a_sel = 1; op_b_sel = 1; alu_op = 0; mem_wren = 0; wb_sel = 2;
    end
    else if (opcode == JALR && funct3 == 3'b000) begin    //4. JALR
      br_sel = 1; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 0; mem_wren = 0; wb_sel = 2;
    end
    
    else if (opcode == B &&funct3 == EQ) begin        //5. BEQ
      br_unsigned = 0;
      if(br_equal) begin
        br_sel = 1; rd_wren = 0; br_unsigned = 0; op_a_sel = 1; op_b_sel = 1; alu_op = 0; mem_wren = 0; wb_sel = 0;
      end
      else begin
        br_sel = 0; rd_wren = 0; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 0; mem_wren = 0; wb_sel = 0;  
      end
    end
    else if (opcode == B && funct3 == NE) begin       //6. BNE
      br_unsigned = 0;
      if(!br_equal) begin
        br_sel = 1; rd_wren = 0; br_unsigned = 0; op_a_sel = 1; op_b_sel = 1; alu_op = 0; mem_wren = 0; wb_sel = 0;
      end
      else begin
        br_sel = 0; rd_wren = 0; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 0; mem_wren = 0; wb_sel = 0;  
      end
    end
    else if (opcode == B && funct3 == LT) begin       //7. BLT
      br_unsigned = 0;
      if(br_less) begin
        br_sel = 1; rd_wren = 0; br_unsigned = 0; op_a_sel = 1; op_b_sel = 1; alu_op = 0; mem_wren = 0; wb_sel = 0;
      end
      else begin
        br_sel = 0; rd_wren = 0; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 0; mem_wren = 0; wb_sel = 0;  
      end
    end
    else if (opcode == B && funct3 == GE) begin       //8. BGE
      br_unsigned = 0;
      if((!br_less && !br_equal) || br_equal) begin
        br_sel = 1; rd_wren = 0; br_unsigned = 0; op_a_sel = 1; op_b_sel = 1; alu_op = 0; mem_wren = 0; wb_sel = 0;
      end
      else begin
        br_sel = 0; rd_wren = 0; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 0; mem_wren = 0; wb_sel = 0;  
      end
    end
    else if (opcode == B && funct3 == LTU) begin      //9. BLTU
      br_unsigned = 1;
      if(br_less) begin
        br_sel = 1; rd_wren = 0; br_unsigned = 1; op_a_sel = 1; op_b_sel = 1; alu_op = 0; mem_wren = 0; wb_sel = 0;
      end
      else begin
        br_sel = 0; rd_wren = 0; br_unsigned = 1; op_a_sel = 0; op_b_sel = 0; alu_op = 0; mem_wren = 0; wb_sel = 0;  
      end  
    end
    else if (opcode == B && funct3 == GEU) begin      //10. BGEU
      br_unsigned = 1;
      if((!br_less && !br_equal) || br_equal) begin
        br_sel = 1; rd_wren = 0; br_unsigned = 1; op_a_sel = 1; op_b_sel = 1; alu_op = 0; mem_wren = 0; wb_sel = 0;
      end
      else begin
        br_sel = 0; rd_wren = 0; br_unsigned = 1; op_a_sel = 0; op_b_sel = 0; alu_op = 0; mem_wren = 0; wb_sel = 0;  
      end  
    end
    
    else if (opcode == L && funct3 == LSW) begin      //11. LW
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 0; mem_wren = 0; wb_sel = 1;
    end
    else if (opcode == S && funct3 == LSW) begin      //12. SW
      br_sel = 0; rd_wren = 0; br_unsigned = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 0; mem_wren = 1; wb_sel = 0;
    end
    else if (opcode == I && funct3 == ADDs) begin     //13. ADDI
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 0; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == I && funct3 == SLTs) begin     //14. SLTI
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 2; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == I && funct3 == SLTUs) begin    //15. SLTIU
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 3; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == I && funct3 == XORs) begin     //16. XORI
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 4; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == I && funct3 == ORs) begin      //17. ORI
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 5; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == I && funct3 == ANDs) begin     //18. ANDI
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 6; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == I && funct3 == SLLs && funct7 == Rf7) begin  //19. SLLI
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 7; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == I && funct3 == SRs && funct7 == Rf7) begin   //20. SRLI
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 8; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == I && funct3 == SRs && funct7 == Rf7n) begin  //21. SRAI
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 9; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == R && funct3 == ADDs && funct7 == Rf7) begin  //22. ADD
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 0; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == R && funct3 == ADDs && funct7 == Rf7n) begin //23. SUB
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 1; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == R && funct3 == SLTs && funct7 == Rf7) begin  //24. SLT
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 2; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == R && funct3 == SLTUs && funct7 == Rf7) begin //25. SLTU
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 3; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == R && funct3 == XORs && funct7 == Rf7) begin  //26. XOR
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 4; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == R && funct3 == ORs && funct7 == Rf7) begin   //27. OR
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 5; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == R && funct3 == ANDs && funct7 == Rf7) begin  //28. AND
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 6; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == R && funct3 == SLLs && funct7 == Rf7) begin  //29. SLL
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 7; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == R && funct3 == SRs && funct7 == Rf7) begin   //30. SRL
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 8; mem_wren = 0; wb_sel = 0;
    end
    else if (opcode == R && funct3 == SRs && funct7 == Rf7n) begin  //31. SRA
      br_sel = 0; rd_wren = 1; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 9; mem_wren = 0; wb_sel = 0;
    end
    else begin      //avoid latches, go straight if no instructions
      br_sel = 0; rd_wren = 0; br_unsigned = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 0; mem_wren = 0; wb_sel = 0;
    end   
  end
     
endmodule