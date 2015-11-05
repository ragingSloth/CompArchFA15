//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------

module inputconditioner
(
input 	    clk,            // Clock domain to synchronize input to
input	    noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 3;     // Debounce delay, in clock cycles
    
    reg[counterwidth-1:0] counter = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;
    reg triggered = 0;
    
    always @(posedge clk ) begin
        if(conditioned == synchronizer1)
            counter <= 0;
            if (triggered == 1) begin
                positiveedge <= 0;
                negativeedge <= 0;
                triggered <= 0;
            end
        else begin
            if( counter == waittime) begin
                counter <= 0;
                conditioned <= synchronizer1;
                positiveedge <= synchronizer1;
                negativeedge <= !synchronizer1;
                triggered <= 1;
            end
            else 
                counter <= counter+1;
        end
        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;
    end
endmodule
