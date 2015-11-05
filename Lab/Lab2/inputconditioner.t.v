//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------

module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;
    
    inputconditioner dut(.clk(clk),
    			 .noisysignal(pin),
			 .conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling));


    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock
    
    initial begin
        $dumpfile("conditioner.vcd");
        $dumpvars(0, testConditioner);
        pin = 0; #100;
        pin = 1; #10;
        pin = 0; #10;
        pin = 1; #100;
        pin = 0; #100;
        pin = 1; #100;
        pin = 0; #100;
        pin = 1; #100;
        pin = 0; #100;
        pin = 1; #100;
        pin = 0; #100;
        pin = 1; #20;
        pin = 0; #20;
    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronize, Clean, Preprocess (edge finding)
    end
    
endmodule
