module CPU (
    input wire clk,
    input wire reset,

    input wire[31:0] inst,
    output wire[31:0] iAddr,

    input wire[31:0] dataIn,
    output wire[31:0] dAddr,
    output wire[31:0] dataOut,
    output wire DRAMwe
);
    wire[31:0] pc_out;
    wire[31:0] pc_in;
    // wire[31:0] inst;
    wire[4:0] rs;
    wire[4:0] rt;
    wire[4:0] rd;
    wire[3:0] ALUControl;
    wire[15:0] Imm16;
    wire[25:0] Jimm;
    wire BEQ_BNE;
    wire[1:0] PCSrc;
    wire[1:0] RegDst;
    wire[1:0] ExtSelect;
    wire GPRwe;
    wire ALUBSrc;
    // wire DRAMwe;
    wire[1:0] WBSrc;

    wire[31:0] pc4 = pc_out + 32'h4; // next PC
    wire[31:0] Jconcatenate;

    wire[31:0] extResult;

    wire[31:0] ALUOpr1;
    wire[31:0] ALUOpr2;
    wire[31:0] ALUResult;
    wire overflow;
    wire zero;

    wire[31:0] branchPC;

    wire[4:0] GPRwaddr;

    wire[31:0] ALUB;
    wire[31:0] rdata1;
    wire[31:0] rdata2;

    wire[31:0] WBdata;

    wire RegFileWE;

    assign pc_in = PCSrc[1] ? // 11 10
                        (PCSrc[0] ? rdata1 : Jconcatenate)
                        : // 01 00
                        (PCSrc[0] ? branchPC : pc4);
    
    assign branchPC = (BEQ_BNE ^ zero) ? (pc4 + extResult) : pc4;

    assign GPRwaddr = RegDst[1] ? // 11 10
                            5'b11111
                            : // 01 00
                            (RegDst[0] ? rd : rt);

    assign ALUB = ALUBSrc ? extResult : rdata2;

    assign WBdata = WBSrc[1] ? // 11 10
                        pc4
                        :
                        (WBSrc[0] ? dataIn : ALUResult);


    assign iAddr = pc_out;
    assign dAddr = ALUResult;
    assign dataOut = rt;

    PC pc_inst(
        .clk(clk),
        .pc_in(pc_in),
        .reset(reset),
        .pc_out(pc_out)
    );

    Decoder decoder_inst(
        .inst(inst),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .ALUControl(ALUControl),
        .Imm16(Imm16),
        .Jimm(Jimm),
        .BEQ_BNE(BEQ_BNE),
        .PCSrc(PCSrc),
        .RegDst(RegDst),
        .ExtSelect(ExtSelect),
        .GPRwe(GPRwe),
        .ALUBSrc(ALUBSrc),
        .DRAMwe(DRAMwe),
        .WBSrc(WBSrc)
    );

    Concatenate concatenate_inst(
        .Jimm(Jimm),
        .pc(pc4),
        .Jconcatenate(Jconcatenate)
    );

    ImmExt immExt_inst(
        .Imm16(Imm16),
        .ExtSelect(ExtSelect),
        .extResult(extResult)
    );

    ALU ALU_inst(
        .opr1(rdata1),
        .opr2(ALUB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .overflow(overflow),
        .zero(zero)
    );

    RegFile cpu_ref(
        .clk(clk),
        .reset(reset),
        .we(RegFileWE),
        .raddr1(rs),
        .raddr2(rt),
        .waddr(GPRwaddr),
        .wdata(WBdata),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    OverflowProc overflowProc_inst(
        .RegDst(RegDst),
        .overflow(overflow),
        .GPRwe(GPRwe),
        .RegFileWE(RegFileWE)
    );
endmodule