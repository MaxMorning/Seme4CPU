module DRAM (
    input wire clk,
    input wire we,
    input wire[31:0] addr,
    input wire[31:0] dataIn,

    input wire[7:0] opr1,
    input wire[7:0] opr2,

    output wire[15:0] result,
    
    output wire[31:0] dataOut
);

    assign dataOut = addr[2] ? {24'h0, opr2} : {24'h0, opr1};

    reg[15:0] outData;
    assign result = outData;
    always @(negedge clk) begin
        if (we) begin
            if (addr[3])
                outData <= dataIn[15:0];
            else
                outData <= 16'hZ;
        end
    end
    
endmodule