//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

module regfile
(
    output[31:0]	ReadData1,	// Contents of first register read
    output[31:0]	ReadData2,	// Contents of second register read
    input[31:0]	WriteData,	// Contents to write to register
    input[4:0]	ReadRegister1,	// Address of first register to read
    input[4:0]	ReadRegister2,	// Address of second register to read
    input[4:0]	WriteRegister,	// Address of register to write
    input		RegWrite,	// Enable writing of register when High
    input		Clk		// Clock (Positive Edge Triggered)
);
    wire [31:0] wre;
    wire [1023:0] mux_in;
    decoder1to32 decoder (wre, RegWrite, WriteRegister);
    register32zero zero (WriteData, wre[0], Clk, mux_in[31:0]);
    generate
    genvar i;
        for (i=1; i<32; i=i+1) begin: gen_regs
            register32 register (WriteData, wre[i], Clk, mux_in[32*i+31:32*i]);
        end
    endgenerate
    mux32to1by32 mux1 (ReadData1, ReadRegister1, mux_in);
    mux32to1by32 mux2 (ReadData2, ReadRegister2, mux_in);
endmodule
