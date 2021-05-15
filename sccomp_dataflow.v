module sccomp_dataflow (
    input wire clk_in,
    input wire reset,
    output wire[31:0] inst,
    output wire[31:0] pc
);

    wire[31:0] inst_iram_cpu;
    wire[31:0] iAddr_cpu_iram;
    wire[31:0] addr_cpu_dram;
    wire[31:0] data_cpu_dram;
    wire[31:0] data_dram_cpu;
    wire we_cpu_dram;

    CPU sccpu(
        .clk(clk_in),
        .reset(reset),
        .inst(inst_iram_cpu),
        .iAddr(iAddr_cpu_iram),
        .dataIn(data_dram_cpu),
        .dAddr(addr_cpu_dram),
        .dataOut(data_cpu_dram),
        .DRAMwe(we_cpu_dram),
        .pc_out(pc)
    );

    IRAM iram_inst(
        .addr(iAddr_cpu_iram),
        .inst(inst_iram_cpu)
    );

    DRAM dram_inst(
        .clk(clk_in),
        .we(we_cpu_dram),
        .addr(addr_cpu_dram),
        .wdata(data_cpu_dram),
        .rdata(data_dram_cpu)
    );

    assign inst = inst_iram_cpu;
endmodule