`define AND and #50
`define OR or #50
`define NOT not #50
`define XOR xor #50


module FullAdder4bit(sum, carryout, overflow, a, b);
  output[3:0] sum;  // 2?s complement sum of a and b
  output carryout;  // Carry out of the summation of a and b
  output overflow;  // True if the calculation resulted in an overflow
  input[3:0] a;     // First operand in 2?s complement format
  input[3:0] b;     // Second operand in 2?s complement format
  wire[2:0] carry;
  fullAdder adder0(sum[0], carry[0], a[0], b[0], 1'b0);
  fullAdder adder1(sum[1], carry[1], a[1], b[1], carry[0]);
  fullAdder adder2(sum[2], carry[2], a[2], b[2], carry[1]);
  fullAdder adder3(sum[3], carryout, a[3], b[3], carry[2]);
  `XOR orgate(overflow, carryout, carry[2]);

endmodule

module fullAdder(sum, carryout, a, b, carryin);
output sum, carryout;
input a, b, carryin;
wire AxorB, AandB, AxorBandC;

`XOR xorgate0(AxorB,a,b);
`XOR xorgate1(sum,AxorB, carryin);
`AND andgate0(AxorBandC,AxorB,carryin);
`AND andgate1(AandB, a, b);
`OR orgate(carryout, AandB, AxorBandC);
endmodule


module testFullAdder;
reg[3:0] a, b;
wire[3:0] sum;
wire overflow, carryout;
FullAdder4bit adder (sum,carryout,overflow, a,b);

initial begin
$display("These show addition is working properly in cases with no overflow or carryout");
$display("  A    B   |  S   Cout Ovf |  S   Cout Ovf  Expected");
a=0;b=0;#1000
$display("%b  %b | %b   %b   %b  | 0000   0   0 ", a,b,sum,carryout,overflow);
a=1;b=0;#1000
$display("%b  %b | %b   %b   %b  | 0001   0   0 ", a,b,sum,carryout,overflow);
a=2;b=1;#1000
$display("%b  %b | %b   %b   %b  | 0011   0   0 ", a,b,sum,carryout,overflow);
a=3;b=3;#1000
$display("%b  %b | %b   %b   %b  | 0100   0   0 ", a,b,sum,carryout,overflow);
a=-4;b=3;#1000
$display("%b  %b | %b   %b   %b  | 1111   0   0 ", a,b,sum,carryout,overflow);
a=7;b=-8;#1000
$display("%b  %b | %b   %b   %b  | 1111   0   0 ", a,b,sum,carryout,overflow);
$display("-----------------------------------------------------------------");
$display("These are cases with carryout but no overflow");
$display("  A    B   |  S   Cout Ovf |  S   Cout Ovf  Expected");
a=-2;b=-3;#1000
$display("%b  %b | %b   %b   %b  | 1011   1   0 ", a,b,sum,carryout,overflow);
a=-2;b=-2;#1000
$display("%b  %b | %b   %b   %b  | 1101   1   0 ", a,b,sum,carryout,overflow);
$display("-----------------------------------------------------------------");
$display("Inverses sum to 0");
$display("  A    B   |  S   Cout Ovf |  S   Cout Ovf  Expected");
a=2;b=-2;#1000
$display("%b  %b | %b   %b   %b  | 0000   1   0 ", a,b,sum,carryout,overflow);
a=-6;b=6;#1000
$display("%b  %b | %b   %b   %b  | 0000   1   0 ", a,b,sum,carryout,overflow);
$display("-----------------------------------------------------------------");
$display("These are cases with overflow but no carryout");
$display("  A    B   |  S   Cout Ovf |  S   Cout Ovf  Expected");
a=5;b=4;#1000
$display("%b  %b | %b   %b   %b  | 1001   0   1 ", a,b,sum,carryout,overflow);
a=3;b=7;#1000
$display("%b  %b | %b   %b   %b  | 1010   0   1 ", a,b,sum,carryout,overflow);
$display("-----------------------------------------------------------------");
$display("These are cases with overflow and carryout");
$display("  A    B   |  S   Cout Ovf |  S   Cout Ovf  Expected");
a=-7;b=-8;#1000
$display("%b  %b | %b   %b   %b  | 0001   1   1 ", a,b,sum,carryout,overflow);
a=-4;b=-6;#1000
$display("%b  %b | %b   %b   %b  | 0110   1   1 ", a,b,sum,carryout,overflow);

end

endmodule

