`timescale 1ns/1ps
module soc_tb();
    reg clk;
    reg reset;
    wire[31:0] inst;
    wire[31:0] pc;

    integer fout;
    integer i;
//    string file_output = "G:/FTP/TransTemp/MIPS31/RES/_1_addi.txt";

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
        #3
        reset = 1;
        #3
        reset = 0;

        #6;
        forever begin
            
            $fdisplay(fout, "pc: %h", pc);
            $fdisplay(fout, "instr: %h", inst);

            for (i = 0; i < 32; i = i + 1) begin
                $fdisplay(fout, "regfile%d: %h", i, soc.sccpu.cpu_ref.array_reg[i]);
            end
            #10;
            // $fdisplay(file_output, "REG0 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG1 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG2 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG3 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG4 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG5 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG6 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG7 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG8 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG9 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG10 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG11 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG12 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG13 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG14 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG15 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG16 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG17 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG0 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG0 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG0 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG0 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG0 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG0 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG0 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG0 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG0 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG0 : %h", soc.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output, "REG0 : %h", soc.sccpu.cpu_ref.array_reg[0]);
        end
        $fclose(fout);

    end
    
endmodule