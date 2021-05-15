module OverflowProc (
    input wire[1:0] RegDst,
    input wire overflow,
    input wire GPRwe,

    output wire RegFileWE
);
    assign RegFileWE = RegDst[1] | (~overflow & GPRwe);
endmodule