module delayLine #(parameter width = 8)
    (
        input in,
        input clk,
        output reg [width-1:0] out
    );
        /*a clock signal is required to properly emulate a delay line
        without it multiple 1s aren't properly handled*/
        initial out = 0;
        genvar i;
        generate
            for (i=0; i<width; i=i+1) begin: generate_taps 
                always @(posedge clk) begin
                    /*each bit in the line is set with a proportional delay
                    the bits retain state for 20 ticks then defaults low again*/
                    out[i] <= #(i*20) in;
                    out[i] <= #(i*20+20) 1'b0;
                end
            end
        endgenerate
endmodule


//This is the interface to the delay line memory unit
//It provides parallel input and output functionality
module controller #(parameter width = 8)
    (
        input clk,
        input sclk,
        input [width-1:0] word,
        input wre,
        input re,
        input dline,
        output sout,
        output [2*width-1:0] pout
    );
    wire [3:0] cycle, addr;
    wire w1, w2, w3, w4, regout, sr_clk;
    wire dffq, ndffq, flip, write;
    wire sr_out, clr;

    wire ndffq2, dffq2, readclk, bufsel2, read, readenable, noops, decr;
    wire r1, r2, r3, r4, rclr1;
    wire d3, q3, c3, d4, q4, c4, od3, od4, nclk;


    /*this group generates the signal to resume feeding
    the delay line back in on itself upon completing a write*/
    not (nclk, clk);
    not (d3, q3);
    and a1(c3, dffq, regout);
    or (od3, c3, q4);
    and (od4, q4, d3, nclk);
    mux flopselect(q4, {od4, readok}, c4);
    dff d1(d3, od3, q3);
    dff d2(q3, c4, q4);



    /*noops indicates whether or not there is an operation queued 
    locking memory accordingly*/
    and free(noops, ndffq, ndffq2);

    ringCounter #(4) rc1(sclk, 1'b0, cycle);
    ringCounter #(4) rc2(write, decr, addr);

    /*decrement the current register at beggining of read 
    and after reading the first 8 bits*/
    or reduce(decr, read, rclr2);

     
    /*this group ensures writes only run at appropriate times
    it also provides a signal that a write has been queued*/
    not (ndffq, dffq);
    or toggle(flip, write, q4);
    dff _wre(ndffq, flip, dffq);
    buffer b2(noops, wre, write);


    //this group signals when the currently addressed register is in position to be written
    and a1(w1, cycle[0], addr[0]);
    and a1(w2, cycle[1], addr[1]);
    and a1(w3, cycle[2], addr[2]);
    and a1(w4, cycle[3], addr[3]);
    or _out(regout, w1, w2, w3, w4);

    /*the input buffer handles parallel to serial conversion
    if a write is queued and the register is inline the mux will
    swap this serial output with the output of the delay line for
    the time it takes to write 8 bits*/

    and srclk(sr_clk, regout, dffq);
    piso input_buffer(word, write, clk, sr_clk, sr_out);
    mux m1(sr_clk, {sr_out, dline}, sout);

    /*this group is responsible for generating register alignment
    information for the reading hardware*/
    and a1(r1, cycle[0], addr[3]);
    and a1(r2, cycle[1], addr[0]);
    and a1(r3, cycle[2], addr[1]);
    and a1(r4, cycle[3], addr[2]);
    or readok(readok, r1, r2, r3, r4);

    /*this group corresponds to the portion that queues writes
    it ensures reads are only queued at appropriate times, and sets
    readenable when the relevant register is aligned*/
    not qnot2(ndffq2, dffq2);
    or toggle2(readclk, read, rclr1);
    dff _re(ndffq2, readclk, dffq2);
    buffer b1(noops, re, read);
    and g2g(readenable, readok, dffq2);

    /*readiut handles serial to parallel conversion on the output, 
    it also provides signals upon completion of both reads to allow future commands*/
    sipo #(2*width) readout(dline, readenable, clk, rclr1, rclr2, pout);
endmodule

module test();
    reg clk, sclk, we, re;
    initial clk = 1;
    initial sclk = 1;
    reg [7:0] in;
    wire out;
    wire [15:0] pout;
    wire [31:0] dline;
    always #10 clk = !clk;
    always #80 sclk = !sclk;
    controller dut2(clk, sclk, in, we, re, dline[31], out, pout);
    delayLine #(32) dl(out, clk, dline);
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
        re = 0; we = 0; in = 8'b11111111; #180
        we = 1; #20
        we = 0; in = 8'b00001111; #100
        we = 1; #20
        we = 0;#800
        we = 1; #20
        we = 0; #2000
        re = 1; #20
        re = 0; #2000
        we = 0; in = 8'b00001111; #180
        we = 1; #20
        we = 0; #20
        $display("%b", out);
    end
endmodule
