module behavioralMultiplexer(out, address0,address1, in0,in1,in2,in3);
output out;
input address0, address1;
input in0, in1, in2, in3;
wire[3:0] inputs = {in3, in2, in1, in0};
wire[1:0] address = {address1, address0};
assign out = inputs[address];
endmodule

module structuralMultiplexer(out, address0,address1, in0,in1,in2,in3);
output out;
input address0, address1;
input in0, in1, in2, in3;

wire a0, a1, xa0a1, a0a1, na0a1, s0, s1, s2, s3;

and a0a1_(a0a1, address0, address1);
nand na0a1_(na0a1, address0, address1);
xor xa0a1_(xa0a1, address0, address1);
and a0_(a0, xa0a1, address0);
and a1_(a1, xa0a1, address1);
and s0_(s0, na0a1, in0);
and s1_(s1, a0, in1);
and s2_(s2, a1, in2);
and s3_(s3, a0a1, in3);
or out_(out, s0, s1, s2, s3);
endmodule


module testMultiplexer;
reg address0, address1, in0, in1, in2, in3;
wire out;
//behavioralMultiplexer mux (out, address0,address1, in0,in1,in2,in3);
structuralMultiplexer mux (out, address0,address1, in0,in1,in2,in3);
initial begin
    $display("A0 A1 I0 I1 I2 I3 | Out | Expected");
    address0=0;address1=0;in0=0;in1=0;in2=0;in3=0; #1000
    $display("%b  %b  %b  %b  %b  %b | %b   | 0", address0, address1, in0, in1, in2, in3, out);
    address0=0;address1=0;in0=1;in1=0;in2=0;in3=0; #1000
    $display("%b  %b  %b  %b  %b  %b | %b   | 1", address0, address1, in0, in1, in2, in3, out);
    address0=1;address1=0;in0=0;in1=0;in2=0;in3=0; #1000
    $display("%b  %b  %b  %b  %b  %b | %b   | 0", address0, address1, in0, in1, in2, in3, out);
    address0=1;address1=0;in0=0;in1=1;in2=0;in3=0; #1000
    $display("%b  %b  %b  %b  %b  %b | %b   | 1", address0, address1, in0, in1, in2, in3, out);
    address0=0;address1=1;in0=0;in1=0;in2=0;in3=0; #1000
    $display("%b  %b  %b  %b  %b  %b | %b   | 0", address0, address1, in0, in1, in2, in3, out);
    address0=0;address1=1;in0=0;in1=0;in2=1;in3=0; #1000
    $display("%b  %b  %b  %b  %b  %b | %b   | 1", address0, address1, in0, in1, in2, in3, out);
    address0=1;address1=1;in0=0;in1=0;in2=0;in3=0; #1000
    $display("%b  %b  %b  %b  %b  %b | %b   | 0", address0, address1, in0, in1, in2, in3, out);
    address0=1;address1=1;in0=0;in1=0;in2=0;in3=1; #1000
    $display("%b  %b  %b  %b  %b  %b | %b   | 1", address0, address1, in0, in1, in2, in3, out);
end
  // Your test code here
endmodule
