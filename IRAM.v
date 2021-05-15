module IRAM (
    input wire[31:0] addr,

    output wire[31:0] inst
);

    reg[31:0] inst_array[63:0];

    assign inst = inst_array[addr[5:0]];
    
endmodule