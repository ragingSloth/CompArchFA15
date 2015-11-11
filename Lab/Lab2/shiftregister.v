module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output [width-1:0]  parallelDataOut,    // Shift reg data contents
output              serialDataOut       // Positive edge synchronized
);
 
    reg [width-1:0]      shiftregistermem;
    always @(posedge clk) begin
        if (peripheralClkEdge == 1) begin
            shiftregistermem <= {shiftregistermem[width-2:0], serialDataIn};
        end
        if (parallelLoad == 1) begin
            shiftregistermem <= parallelDataIn;
        end
    end
    assign serialDataOut = shiftregistermem[width-1];
    assign parallelDataOut = shiftregistermem;
endmodule
