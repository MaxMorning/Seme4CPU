module Decoder (
    input wire[31:0] inst,

    output wire[4:0] rs,
    output wire[4:0] rt,
    output wire[4:0] rd,

    output wire[3:0] ALUControl,
    output wire[15:0] Imm16,
    output wire[25:0] Jimm,
    output wire BEQ_BNE,
    output wire[1:0] PCSrc,
    output wire[1:0] RegDst,
    output wire[1:0] ExtSelect,
    output wire GPRwe,
    output wire ALUASrc,
    output wire ALUBSrc,
    output wire DRAMwe,
    output wire[1:0] WBSrc
);
    
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];

    assign ALUControl = inst[31] ? 4'b0001 : // lw/sw
                        (inst[29] ? // 1xxx
                            (inst[28] ? // 11xx
                                (inst[27] ? // 111x
                                    (inst[26] ? 4'b1110 : 4'b0110) : //1111 lui   1110 xori
                                    {1'b0, inst[28:26]} //1101 ori   1100 andi
                                    // (inst[26] ? 4'b0101 : 4'b0100) //1101 ori   1100 andi
                                ) : // 10xx
                                {inst[27], inst[28:26]}
                                // (inst[27] ? 
                                //     (inst[26] ? 4'b1011 : 4'b1010) : //1011 sltiu    1010 slti
                                //     (inst[26] ? 4'b0001 : 4'b0000) //1001 addiu   1000 addi
                                // )
                            ) : // 0xxx
                            (inst[28] ? // 01xx
                                4'b0110 : // 00xx
                                // (inst[27] ? 
                                //     (inst[26] ? 4'b1110 : 4'b0110) : //0111 NA  0110 NA
                                //     (inst[26] ? 4'b0110 : 4'b0110) //0101 bne   0100 beq
                                // ) :
                                (inst[27] ? // 001x
                                    {2'b00, inst[27:26]} : // 000x
                                    // (inst[26] ? 4'b1011 : 4'b1010) : //0011 jal   0010 j
                                    (inst[26] ? 4'b0001 : {4{inst[5]}} ~^ {inst[3], inst[5] & inst[2], inst[1:0]}) //0001 NA   0000 R type
                                )
                            )
                        );
    
    assign Imm16 = inst[15:0];
    assign Jimm = inst[25:0];
    assign BEQ_BNE = inst[26];
    assign PCSrc[1] = (~inst[29] & ~inst[28] & ~inst[27] & ~inst[26] & ~inst[5] & inst[3]) | (~inst[31] & ~inst[29] & ~inst[28] & inst[27]);
    assign PCSrc[0] = (~inst[29] & ~inst[28] & ~inst[27] & ~inst[26] & ~inst[5] & inst[3]) | (~inst[31] & ~inst[29] & inst[28] & ~inst[27]);

    assign RegDst[1] = ~inst[31] & ~inst[29] & ~inst[28] & inst[27] & inst[26];
    assign RegDst[0] = ~inst[29] & ~inst[28] & ~inst[27] & ~inst[26];

    assign ExtSelect[1] = (~inst[29] & ~inst[28] & ~inst[27] & ~inst[26]) | (~inst[31] & ~inst[29] & inst[28] & ~inst[27]);
    assign ExtSelect[0] = inst[29] ^ inst[28];

    assign GPRwe = ~((~inst[29] & ~inst[28] & ~inst[27] & ~inst[26] & ~inst[5] & inst[3]) | (inst[31] & inst[29] & ~inst[28] & inst[27] & inst[26]) | (~inst[31] & ~inst[29] & inst[28] & ~inst[27]) | (~inst[31] & ~inst[29] & ~inst[28] & inst[27] & ~inst[26]));

    assign ALUASrc = ~inst[29] & ~inst[28] & ~inst[27] & ~inst[26] & ~inst[5] & ~inst[2];
    assign ALUBSrc = (inst[29] | inst[31]);
    assign DRAMwe = inst[31] & inst[29];

    assign WBSrc[1] = ~inst[31] & ~inst[29] & ~inst[28] & inst[27] & inst[26];
    // assign WBSrc[0] = ~inst[29] & ~inst[28] & inst[27] & inst[26];
    assign WBSrc[0] = inst[29] | inst[28] | ~inst[27] | ~inst[26];
endmodule