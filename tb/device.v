module device (
    input wire base_clk,
    input wire[7:0] opr1,
    input wire[7:0] opr2,
    input wire reset,

    output wire[15:0] result
);

    wire clk_25;
    wire clk_50;

    wire[31:0] addr_cpu_iram;
    wire[31:0] data_iram_cpu;
    wire[31:0] addr_cpu_dram;
    wire[31:0] data_dram_cpu;
    wire[31:0] data_cpu_dram;
    wire dram_we;
    CPU cpu_inst(
        .clk(clk_25),
        .reset(reset),
        .inst(data_iram_cpu),
        .iAddr(addr_cpu_iram),
        .dataIn(data_dram_cpu),
        .dAddr(addr_cpu_dram),
        .dataOut(data_cpu_dram),
        .DRAMwe(dram_we)
    );

    IRAM iram_inst(
        .a(addr_cpu_iram[7:2]),
        .spo(data_iram_cpu)
    );

    DRAM dram_inst(
        .clk(clk_25),
        .addr(addr_cpu_dram),
        .we(dram_we),
        .dataIn(data_cpu_dram),
        .dataOut(data_dram_cpu),
        .opr1(opr1),
        .opr2(opr2),
        .result(result)
    );

    clock clock_inst(
        .clk_in1(base_clk),
        .clk_out1(clk_25),
        .clk_out2(clk_50),
        .reset(reset)
    );
    
endmodule