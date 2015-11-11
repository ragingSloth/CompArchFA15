//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------
module inputconditioner
(
input         clk,            // Clock domain to synchronize input to
input         noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);
 
    parameter counterwidth = 5; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 10;     // Debounce delay, in clock cycles
   
    reg[counterwidth-1:0] counter = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;
   
    always @(posedge clk ) begin
        if(conditioned == synchronizer1) begin
            counter <= 0;
            positiveedge <= 0;
            negativeedge <= 0;
            end
        else begin
            if( counter == waittime) begin
                counter <= 0;
                conditioned <= synchronizer1;
                if (synchronizer1 == 1) begin
                    positiveedge <= 1;
                end else begin
                    negativeedge <= 1;
                    end
            end else begin
                counter <= counter+1;
            end
        end
        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;
    end
endmodule
