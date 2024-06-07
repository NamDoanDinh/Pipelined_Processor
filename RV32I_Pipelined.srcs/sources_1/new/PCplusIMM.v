module PCplusIMM(
    input  [31:0] immE,
    input  [12:0] pcE,
    output [31:0] PCplusIMM
    );
    
    assign PCplusIMM = {19'b0, pcE} + immE;
    
endmodule
