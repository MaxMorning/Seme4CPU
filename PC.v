module PC (
    input wire clk,
    input wire[31:0] pc_in,
    input wire reset,

    output reg[31:0] pc_out
);
    
    always @(posedge clk) begin
        if (reset) begin
            pc_out <= 32'h0;
        end
        else begin
            pc_out <= pc_in;
        end
    end
endmodule