`timescale 1ns/1ps
module soc_tb;
    reg clk;
    reg reset;
    wire[31:0] inst;
    wire[31:0] pc;

    sccomp_dataflow soc(
        .clk_in(clk),
        .reset(reset),
        .inst(inst),
        .pc(pc)
    );

    $readmemh(, soc.iram_inst.inst_array);
    $readmemh(, soc.dram_inst.data_array);
    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        #3
        reset = 1;
        #3
        reset = 0;
    end
    
endmodule