`timescale 1ns/1ps
module soc_tb();
    reg clk;
    reg reset;
    wire[31:0] inst;
    wire[31:0] pc;

    integer fout;
    integer i;
//    string file_output = "G:/FTP/TransTemp/MIPS31/RES/_1_addi.txt";

    wire[31:0] a_0;
    wire[31:0] a_1;
    wire[31:0] a_2;
    wire[31:0] a_3;
    wire[31:0] a_4;
    wire[31:0] a_5;
    wire[31:0] a_6;
    wire[31:0] a_7;

    assign a_0 = soc.dram_inst.data_array[0];
    assign a_1 = soc.dram_inst.data_array[1];
    assign a_2 = soc.dram_inst.data_array[2];
    assign a_3 = soc.dram_inst.data_array[3];
    assign a_4 = soc.dram_inst.data_array[4];
    assign a_5 = soc.dram_inst.data_array[5];
    assign a_6 = soc.dram_inst.data_array[6];
    assign a_7 = soc.dram_inst.data_array[7];

    sccomp_dataflow soc(
        .clk_in(clk),
        .reset(reset),
        .inst(inst),
        .pc(pc)
    );

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        $readmemh("G:/FTP/TransTemp/MIPS31/WORKSPACE/instr.txt", soc.iram_inst.inst_array);
        $readmemh("G:/FTP/TransTemp/MIPS31/DRAM.txt", soc.dram_inst.data_array);
        fout = $fopen("G:/FTP/TransTemp/MIPS31/WORKSPACE/result.txt", "w+");
        reset = 1;
        #6
        reset = 0;

        #6;
        forever begin
            
            $fdisplay(fout, "pc: %h", pc);
            $fdisplay(fout, "instr: %h", inst);

            for (i = 0; i < 32; i = i + 1) begin
                $fdisplay(fout, "regfile%d: %h", i, soc.sccpu.cpu_ref.array_reg[i]);
            end
            #10;
            
        end
        $fclose(fout);

    end
    
endmodule