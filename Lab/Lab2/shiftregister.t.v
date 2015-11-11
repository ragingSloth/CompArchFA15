//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------

module testshiftregister();

    reg             clk;
    reg             peripheralClkEdge;
    reg             parallelLoad;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    reg[7:0]        parallelDataIn;
    reg             serialDataIn; 
    
    // Instantiate with parameter width = 8
    shiftregister #(8) dut(.clk(clk), 
    		           .peripheralClkEdge(peripheralClkEdge),
    		           .parallelLoad(parallelLoad), 
    		           .parallelDataIn(parallelDataIn), 
    		           .serialDataIn(serialDataIn), 
    		           .parallelDataOut(parallelDataOut), 
    		           .serialDataOut(serialDataOut));
    
    initial clk=0;
    always #10 clk=!clk;
    initial begin
    	// Your Test Code

        parallelLoad=0; #20
        parallelDataIn=8'hFF; #20
        parallelLoad=1; #20
        $display("%b", parallelDataOut);
        parallelLoad=0; #20

        peripheralClkEdge = 1;
        serialDataIn=0; #20
        $display("%b", parallelDataOut);
        $display("%b", serialDataOut);
        serialDataIn=0; #20
        $display("%b", parallelDataOut);
        $display("%b", serialDataOut);
        serialDataIn=0; #20
        $display("%b", parallelDataOut);
        $display("%b", serialDataOut);
        serialDataIn=0; #20
        $display("%b", parallelDataOut);
        $display("%b", serialDataOut);
        serialDataIn=0; #20
        $display("%b", parallelDataOut);
        $display("%b", serialDataOut);
        serialDataIn=0; #20
        $display("%b", parallelDataOut);
        $display("%b", serialDataOut);
        serialDataIn=0; #20
        $display("%b", parallelDataOut);
        $display("%b", serialDataOut);
        serialDataIn=0; #20
        $display("%b", parallelDataOut);
        $display("%b", serialDataOut);
    end

endmodule

