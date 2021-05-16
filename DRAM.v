module DRAM (
    input wire clk,
    input wire we,
    input wire[31:0] addr,
    input wire[31:0] wdata,
    
    output wire[31:0] rdata
);
    reg[31:0] data_array[255:0];
    assign rdata = data_array[addr[9:2]];

    always @(negedge clk) begin
        if (we) begin
            data_array[addr[9:2]] <= wdata;
        end
    end
endmodule