module ALU
(
    output[31:0]    result,
    output          carryout,
    output          zero,
    output          overflow,
    input[31:0]     operandA,
    input[31:0]     operandB,
    input[2:0]      command
);

    wire[31:0] xoro, ando, nando, noro, oro, add, sub, slt;
    wire cadd, oadd, csub, osub, neg_lsb, csub_sel, cadd_sel, osub_sel, oadd_sel;
    or32 op_or(oro, operandA, operandB);
    and32 op_and(ando, operandA, operandB);
    xor32 op_xor(xoro, operandA, operandB);
    nor32 op_nor(noro, operandA, operandB);
    nand32 op_nand(nando, operandA, operandB);
    FullAdderNbit adder(operandA, operandB, add, cadd, oadd);
    subtractorNbit subb(operandA, operandB, sub, csub, osub);
    generate
    genvar i;
    for (i=0; i<32; i=i+1) begin: slt_set
        assign slt[i] = 1'b0;
    end
    endgenerate
    xor slt_bit(slt[0], overflow, sub[31]);
    or #320 set_zero(zero, xoro[0], xoro[1], xoro[2], xoro[3], xoro[4], xoro[5], xoro[6], xoro[7], xoro[8], xoro[9], xoro[10], xoro[11], xoro[12], xoro[13], xoro[14], xoro[15], xoro[16], xoro[17], xoro[18], xoro[19], xoro[20], xoro[21], xoro[22], xoro[23], xoro[24], xoro[25], xoro[26], xoro[27], xoro[28], xoro[29], xoro[30], xoro[31]);
    xor #20 (slt[0], osub, sub[0]);
    not #10 neg_sel_lsb(neg_lsb, command[0]);
    and #20 caddNneglsb(cadd_sel, cadd, neg_lsb);
    and #20 csubNlsb(csub_sel, csub, command[0]);
    and #20 oaddNneglsb(oadd_sel, oadd, neg_lsb);
    and #20 osubNlsb(osub_sel, osub, command[0]);
    or #20 cout(carryout, cadd_sel, csub_sel);
    or #20 oout(overflow, oadd_sel, osub_sel);
    MUX multi(command, add, sub, xoro, slt, ando, nando, noro, oro, result);
endmodule

module FullAdderNbit
(
    input[N-1:0] a,     // First operand in 2?s complement format
    input[N-1:0] b,     // Second operand in 2?s complement format
    output[N-1:0] sum,  // 2?s complement sum of a and b
    output carryout,  // Carry out of the summation of a and b
    output overflow  // True if the calculation resulted in an overflow
);
    parameter N = 32;
    wire[N-2:0] carry;
    fullAdder adder0(sum[0], carry[0], a[0], b[0], 1'b0);
    generate
    genvar i;
    for (i=1; i<N-1; i=i+1) begin: adderN
    fullAdder adder(sum[i], carry[i], a[i], b[i], carry[i-1]);
    end
    endgenerate
    fullAdder adder3(sum[N-1], carryout, a[N-1], b[N-1], carry[N-2]);
    or #20 orgate(overflow, carryout, carry[N-2]);
endmodule

module subtractorNbit
(
    input[N-1:0] a,     // First operand in 2?s complement format
    input[N-1:0] b,     // Second operand in 2?s complement format
    output[N-1:0] sum,  // 2?s complement sum of a and b
    output carryout,  // Carry out of the summation of a and b
    output overflow  // True if the calculation resulted in an overflow
);
    parameter N = 32;
    wire[N-2:0] carry;
    wire[N-1:0] negated;
    generate
    genvar i;
    for (i=0; i<N; i=i+1) begin: sub_negate
        not #10 neg(negated[i], b[i]);
    end
    endgenerate
    //set carry in to one to get free incrementation of second number
    fullAdder adder0(sum[0], carry[0], a[0], negated[0], 1'b1);
    generate
    genvar j;
    for (j=1; j<N-1; j=j+1) begin: subN
        fullAdder adder(sum[j], carry[j], a[j], negated[j], carry[j-1]);
    end
    endgenerate
    fullAdder adder3(sum[N-1], carryout, a[N-1], negated[N-1], carry[N-2]);
    or #20 orgate(overflow, carryout, carry[N-2]);
endmodule

module fullAdder(
    output sum, 
    output carryout,
    input a, 
    input b, 
    input carryin
);
    wire AxorB, AandB, AxorBandC;

    xor #20 xorgate0(AxorB,a,b);
    xor #20 xorgate1(sum,AxorB, carryin);
    and #20 andgate0(AxorBandC,AxorB,carryin);
    and #20 andgate1(AandB, a, b);
    or #20 orgate(carryout, AandB, AxorBandC);
endmodule

module or32
(
    input[31:0] a,
    input[31:0] b,
    output[31:0] out
);
    generate
    genvar i;
    for (i=0; i<32; i=i+1) begin: or_op
        or #20 or_32(out[i], a[i], b[i]);
    end
    endgenerate
endmodule

module nor32
(
    input[31:0] a,
    input[31:0] b,
    output[31:0] out
);
    generate
    genvar i;
    for (i=0; i<32; i=i+1) begin: nor_op
        nor #20 nor_32(out[i], a[i], b[i]);
    end
    endgenerate
endmodule

module xor32
(
    input[31:0] a,
    input[31:0] b,
    output[31:0] out
);
    generate
    genvar i;
    for (i=0; i<32; i=i+1) begin: xor_op
        xor #20 xor_32(out[i], a[i], b[i]);
    end
    endgenerate
endmodule

module nand32 
(
    input[31:0] a,
    input[31:0] b,
    output[31:0] out
);
    generate
    genvar i;
    for (i=0; i<32; i=i+1) begin: nand_op
        nand #20 nand_32(out[i], a[i], b[i]);
    end
    endgenerate
endmodule

module and32
(
    input[31:0] a,
    input[31:0] b,
    output[31:0] out
);
    generate
    genvar i;
    for (i=0; i<32; i=i+1) begin: and_op
        and #20 or_32(out[i], a[i], b[i]);
    end
    endgenerate
endmodule

module MUX
(
    input [2:0] select,
    input [31:0] i0,
    input [31:0] i1,
    input [31:0] i2,
    input [31:0] i3,
    input [31:0] i4,
    input [31:0] i5,
    input [31:0] i6,
    input [31:0] i7,
    output [31:0] out
);
    wire n0, n1, n2;
    wire a_0, a_1, a_2, a_3, a_4, a_5, a_6, a_7;
    wire[31:0] b_0, b_1, b_2, b_3, b_4, b_5, b_6, b_7;
    not #10 s0(n0, select[0]);
    not #10 s1(n1, select[1]);
    not #10 s2(n2, select[2]);
    and #30 a0(a_0, n2, n1, n0);
    and #30 a1(a_1, n2, n1, select[0]);
    and #30 a2(a_2, n2, select[1], n0);
    and #30 a3(a_3, n2, select[1], select[0]);
    and #30 a4(a_4, select[2], n1, n0);
    and #30 a5(a_5, select[2], n1, select[0]);
    and #30 a6(a_6, select[2], select[1], n0);
    and #30 a7(a_7, select[2], select[1], select[0]);

    generate
    genvar i;
    for (i=0; i<32; i=i+1) begin: and_32
        and #20 b0(b_0[i], i0[i], a_0); 
        and #20 b1(b_1[i], i1[i], a_1);
        and #20 b2(b_2[i], i2[i], a_2);
        and #20 b3(b_3[i], i3[i], a_3);
        and #20 b4(b_4[i], i4[i], a_4);
        and #20 b5(b_5[i], i5[i], a_5);
        and #20 b6(b_6[i], i6[i], a_6);
        and #20 b7(b_7[i], i7[i], a_7);
    end
    endgenerate

    generate
    genvar j;
    for (j=0; j<32; j=j+1) begin: or_32
        or #80 or_32(out[j], b_0[j], b_1[j], b_2[j], b_3[j], b_4[j], b_5[j], b_6[j], b_7[j]);
    end
    endgenerate
endmodule

module test;
    reg[31:0] opa, opb;
    reg[2:0] command;
    wire[31:0] result;
    wire co, ofl, zero;
    ALU alu(result, co, zero, ofl, opa, opb, command);
    initial begin
        opa=289;opb=598;command=4; #100000
        $display("%b", result);
    end
endmodule
//module testMux;
//    reg[31:0] i0, i1, i2, i3, i4, i5, i6, i7;
//    reg[2:0] sel;
//    wire[31:0] out;
//    MUX mux(sel, i0, i1, i2, i3, i4, i5, i6, i7, out);
//    initial begin
//    i0=1;i1=2;i2=32'd3;i3=4;i4=5;i5=6;i6=7;i7=8;sel=7; #1000
//    $display("%d", out);
//    sel=6; #1000
//    $display("%d", out);
//    sel=5; #1000
//    $display("%d", out);
//    sel=4; #1000
//    $display("%d", out);
//    sel=3; #1000
//    $display("%d", out);
//    sel=2; #1000
//    $display("%d", out);
//    sel=1; #1000
//    $display("%d", out);
//    sel=0; #1000
//    $display("%d", out);
//    end
//endmodule
