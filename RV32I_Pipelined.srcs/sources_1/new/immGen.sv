module immGen(
    input [31:0] instr,
    output reg [31:0] imm
    );
    //concat phase
    wire [11:0] immI, immS;
    wire [12:0] immB;
    wire [19:0] immU;
    wire [20:0] immJ;
    wire [6:0]  opcode;
    wire [2:0]  funct3;
    wire        funct7;
    
    assign immI = instr[31:20];
    assign immS = {instr[31:25],instr[11:7]};
    assign immB = {instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
    assign immU = instr[31:12];
    assign immJ = {instr[31],instr[19:12],instr[20],instr[30:21],1'b0};
    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    
    //opcode field
    localparam lui   = 7'b0110111;
    localparam auipc = 7'b0010111;
    localparam jal   = 7'b1101111;
    localparam jalr  = 7'b1100111;
    localparam Im    = 7'b0010011;
    localparam ImLd  = 7'b0000011;
    localparam St    = 7'b0100011;
    localparam Br    = 7'b1100011; 
    
    always @(*) begin       
        if (opcode == lui || opcode == auipc)                               imm = {immU,12'b0};
        else if (opcode == jal)                                             imm = {{11{immJ[20]}},immJ};
        else if (opcode == jalr || opcode == ImLd || (opcode == Im && (funct3 == 3'b000 || funct3 == 3'b010 ||
                                                                       funct3 == 3'b100 || funct3 == 3'b110 ||
                                                                       funct3 == 3'b111))) 
                                                                            imm = {{20{immI[11]}},immI};
        else if (opcode == Im && funct3 == 3'b011)                          imm = {20'b0, immI};
        else if (opcode == Im && (funct3 == 3'b001 || funct3 == 3'b101))    imm = {27'b0,instr[24:20]};         
        else if (opcode == Br)                                              imm = {{19{immB[12]}},immB};
        else if (opcode == St)                                              imm = {{20{immS[11]}},immS};
        else                                                                imm = 32'b0;            //avoid Latch                                                      
    end
endmodule