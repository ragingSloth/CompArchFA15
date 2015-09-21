module hw1test;
reg A;
reg B;
wire nA;
wire nB;
wire Ai;
wire Bi;
wire nAnB;
wire AnorB;
wire AnandB;
wire AorB;
not Ainv(nA, A);
not Binv(nB, B);
and andgate(nAnB, nA, nB);
nor norgate(AnorB, A, B);
nand nandgate(AnandB, A, B);
or norgate(AorB, nA, nB);

initial begin
$display("A B | ~A ~B | ~(A+B) ~A~B | ~(AB) ~A+~B\n");
A=0;B=0; #1
$display("%b %b | %b %b  | %b   %b | %b  %b\n", A, B, nA, nB, AnorB, nAnB, AnandB, AorB);
A=0;B=1; #1
$display("%b %b | %b %b  | %b   %b | %b  %b\n", A, B, nA, nB, AnorB, nAnB, AnandB, AorB);
A=1;B=0; #1
$display("%b %b | %b %b  | %b   %b | %b  %b\n", A, B, nA, nB, AnorB, nAnB, AnandB, AorB);
A=1;B=1; #1
$display("%b %b | %b %b  | %b   %b | %b  %b\n", A, B, nA, nB, AnorB, nAnB, AnandB, AorB);
end
endmodule
