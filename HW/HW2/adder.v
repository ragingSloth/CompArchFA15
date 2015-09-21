module behavioralFullAdder(sum, carryout, a, b, carryin);
output sum, carryout;
input a, b, carryin;
assign {carryout, sum}=a+b+carryin;
endmodule

module structuralFullAdder(out, carryout, a, b, carryin);
output out, carryout;
input a, b, carryin;
wire axorb, ab, abcarryin;
xor AorB(axorb, a, b);
xor outp(out, carryin, axorb);
and ab_(ab, a, b);
and (abcarryin, axorb, carryin);
or (carryout, acarryin, ab);

endmodule

module testFullAdder;
reg a, b, carryin;
wire sum, carryout;
//behavioralFullAdder adder (sum, carryout, a, b, carryin);
structuralFullAdder adder (sum, carryout, a, b, carryin);

initial begin
    $display("A B Cin | Sum Cout | Expected");
    a=0;b=0;carryin=0; #1000
    $display("%b %b %b   | %b   %b    | 0, 0", a, b, carryin, sum, carryout);
    a=0;b=0;carryin=1; #1000
    $display("%b %b %b   | %b   %b    | 1, 0", a, b, carryin, sum, carryout);
    a=0;b=1;carryin=0; #1000
    $display("%b %b %b   | %b   %b    | 1, 0", a, b, carryin, sum, carryout);
    a=0;b=1;carryin=1; #1000
    $display("%b %b %b   | %b   %b    | 0, 1", a, b, carryin, sum, carryout);
    a=1;b=0;carryin=0; #1000
    $display("%b %b %b   | %b   %b    | 1, 0", a, b, carryin, sum, carryout);
    a=1;b=0;carryin=1; #1000
    $display("%b %b %b   | %b   %b    | 0, 1", a, b, carryin, sum, carryout);
    a=1;b=1;carryin=0; #1000
    $display("%b %b %b   | %b   %b    | 0, 1", a, b, carryin, sum, carryout);
    a=1;b=1;carryin=1; #1000
    $display("%b %b %b   | %b   %b    | 1, 1", a, b, carryin, sum, carryout);
  // Your test code here
end
endmodule
