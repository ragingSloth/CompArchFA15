module register32(
    input [width-1:0] d,
    input wrenable,
    input clk,
    output reg [width-1:0] q
);
    parameter width=32;
    always @(posedge clk) begin
        if (wrenable) begin
            q = d;
        end
    end
endmodule

module register32zero(
    input [width-1:0] d,
    input wrenable,
    input clk,
    output reg [width-1:0] q
);
    parameter width = 32;
    //always @(posedge clk) begin
    initial begin
        q = 32'd0;
    end
endmodule
