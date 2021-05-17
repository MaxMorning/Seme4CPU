`timescale 1ns/1ps
module device_tb;

    reg[7:0] opr1;
    reg[7:0] opr2;
    reg reset;
    reg clk;

    wire[15:0] result;

    wire clk25 = device_inst.clk_25;

    device device_inst(
        .opr1(opr1),
        .opr2(opr2),
        .base_clk(clk),
        .reset(reset),
        .result(result)
    );

    initial begin
        clk = 0;
        forever 
            #5 clk = ~clk;
    end

    initial begin
        reset = 0;
        #3 reset = 1;
        opr1 = 4;
        opr2 = 7;

        #13
        reset = 0;
    end
    
endmodule