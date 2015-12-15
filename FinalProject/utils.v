`define LOG(x) \
    (x <= 2) ? 1 :  \
    (x <= 4) ? 2 :  \
    (x <= 8) ? 3 :  \
    (x <= 16) ? 4 : \
    (x <= 32) ? 5 : 0

module sipo #(parameter width = 8)
    (
        input in,
        input wre,
        input clk,
        output reg clr,
        output reg clr2,
        output reg [width-1:0] out
    );
    reg [`LOG(width) - 1:0] state;
    initial state = 0;
    always @ (posedge clk) begin
        clr <= 0;
        clr2 <= 0;
        if (wre) begin
            out <= out << 1;
            out[0] <= in;
            if (state == width - 1) begin
                clr <= 1;
                state <= 0;
            end
            else begin
                state <= state+1;
            end
            if (state == width/2) clr2 <= 1;
        end
    end
endmodule

module dff
    (
        input d,
        input clk,
        output reg q
    );
    initial q = 0;
    always @ (posedge clk) begin
        q <= d;
    end
endmodule

module mux
    (
        input select,
        input [1:0] addr,
        output out
    );
    assign out = addr[select];
endmodule

module ringCounter #(parameter width = 8)
    (
        input clk,
        input rclk,
        output [width-1:0] q
    );
 
    reg[width-1:0] state;
    initial state = 1 << (width-1);
    always @(posedge clk) begin
        state    <= state << 1;
        state[0] <= state[width - 1];
    end
    always @(posedge rclk) begin
        state    <= state >> 1;
        state[width - 1] <= state[0];
    end
    assign q = state;
 
endmodule

module buffer 
    (
        input select,
        input in,
        output out
    );
    assign out = select ? in : 1'b0;
endmodule

module piso #(parameter width = 8)
    (
        input [width-1: 0] in,
        input wre,
        input clk,
        input clke,
        output reg out
    );
    reg [width-1:0] state;
    wire clki;
    and clk_internal(clki, clk, clke);
    always @ (posedge clki) begin
        out = state[0];
        state <= state >> 1;
    end
    always @ (posedge clk) begin
        if (wre == 1) begin
            state <= in;
        end
    end
//    (
//        input [width-1: 0] in,
//        input wre,
//        input clk,
//        input clke,
//        output reg out,
//        output reg clr
//    );
//    reg [width-1:0] state;
//    reg [`LOG(width):0] counter;
//    initial counter = 0;
//    wire clki;
//    and clk_internal(clki, clk, clke);
//    always @ (posedge clki) begin
//        if (counter == 8) begin
//            clr <= 1;
//            state <= 0;
//            counter <= 0;
//            out <= 0;
//        end
//        else begin
//            out <= state[counter];
//            clr <= 0;
//            counter <= counter + 1;
//        end
//    end
//    always @ (posedge clk) begin
//        clr <= 0;
//        if (wre == 1) begin
//            state <= in;
//        end
//    end
endmodule


//module test();
//    wire [7:0] out;
//    reg in, wre, clk;
//    initial clk = 1;
//    sipo dut(in, wre, clk, out);
//    always #10 clk = !clk;
//    initial begin
//        $dumpfile("test.vcd");
//        $dumpvars(0, test);
//        in = 1; #20
//        wre = 1; in = 0; #20
//        in = 1; #20
//        in = 0; #20
//        in = 1; #20
//        in = 0; #20
//        in = 1; #20
//        in = 0; #20
//        in = 1; #20
//        wre = 0; #20
//        in = 1; #20
//        in = 1; #20
//        in = 1; #20
//        in = 1; #20
//        in = 1; #20
//        in = 1; #20
//        in = 1; #20
//        in = 1; #20
//        $display("%b", out);
//    end
//endmodule

//module test();
//    reg [7:0] word;
//    reg wre, clk;
//    initial clk = 0;
//    always #10 clk = !clk;
//    wire out, clr;
//    sr dut(word, wre, clk, out, clr);
//    initial begin
//        $dumpfile("test.vcd");
//        $dumpvars(0, test);
//        wre = 1; word = 8'b11110000; #20
//        wre = 0;
//    end
//endmodule

//module test ();
//    wire[7:0] state;
//    reg clk;
//    initial clk = 0;
//    always #10 clk = !clk;
//    ringCounter rc(clk, state);
//    initial begin
//        $dumpfile("test.vcd");
//        $dumpvars(0, test);
//        #1
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); #10
//        $display("%b", state); 
//    end
//endmodule
