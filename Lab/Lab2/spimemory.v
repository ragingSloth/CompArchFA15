//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output reg      miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    input           fault_pin,  // For fault injection testing
    output [3:0]    leds        // LEDs for debugging
);
    parameter width=8;
    reg [2**(width - 2) - 1: 0] data[width-1:0];
    reg [width-2:0] address;
    wire cmosi, csclk, ccs, pos_sclk, neg_sclk;
    wire ph1, ph2, ph3, ph4;
    inputconditioner mosi_ic(clk, mosi_pin, cmosi, ph1, ph2);
    inputconditioner sclk_ic(clk, sclk_pin, csclk, pos_sclk, neg_sclk);
    inputconditioner cs_ic(clk, cs_pin, ccs, ph3, ph4);
    wire [width-1:0] p_out, d_out;
    //reg [width-1:0] d_out;
    //wire sr_wre, reset, dm_wre, address_wre, miso_en, s_out;
    wire sr_wre, dm_wre, address_wre, miso_en, s_out;
    //fsm state(ccs, p_out[0], csclk, sr_wre, reset, dm_wre, address_wre, miso_en);
    datamemory mem(clk, d_out, address, dm_wre, p_out);
    //fsm state(ccs, p_out[0], csclk, sr_wre, dm_wre, address_wre, miso_en);
    fsm state(ccs, p_out[0], pos_sclk, sr_wre, dm_wre, address_wre, miso_en);
    shiftregister #(8) sr(clk, pos_sclk, sr_wre, d_out, cmosi, p_out, s_out);
    always @(posedge clk) begin
        if (address_wre==1) begin
            address=p_out[width-1:1];
        end
        if (neg_sclk == 1 && miso_en==1) begin
            miso_pin = s_out;
        end
        //else begin
        //    miso_pin = 1'bz;
        //end
        //if (dm_wre == 1) begin
        //    data[address] = s_out;
        //end
        //assign d_out = data[address];
    end
endmodule

module fsm
(
    input cs,
    input register_lsb,
    input sclk,
    output reg sr_wre,
    //output reset,
    output reg dm_wre,
    output reg address_wre,
    output reg miso
);
    reg [2:0] count, state;
    initial begin
        sr_wre = 0;
        dm_wre = 0;
        address_wre = 0;
        miso=0;
    end
    always @(negedge cs) begin
        count = 0;
        state = 0;
        sr_wre = 0;
        dm_wre = 0;
        address_wre = 0;
        miso=0;
    end
    always @(posedge sclk) begin
        case (state)
            3'd0: 
                begin 
                    sr_wre = 0;
                    dm_wre = 0;
                    address_wre = 0;
                    miso=0;
                    if (count == 7) begin
                        count = 0;
                        state = 1;
                        address_wre = 1;
                    end
                    else begin
                        count = count + 1;
                    end
                end
            3'd1:
                begin
                    sr_wre = 0;
                    dm_wre = 0;
                    miso=0;
                    address_wre = 0;
                    if (register_lsb == 1) begin
                        //assign reset <= 1;
                        sr_wre = 1;
                        miso=1;
                        state = 4;
                    end
                    else begin
                        state = 5;
                    end
                end
            3'd2:
                begin
                    sr_wre = 0;
                    dm_wre = 0;
                    address_wre = 0;
                    miso=0;
                    state = 3;
                end
            3'd3:
                begin
                    sr_wre = 1;
                    miso=1;
                    dm_wre = 0;
                    address_wre = 0;
                    state = 4;
                end
            3'd4:
                begin
                    sr_wre = 0;
                    dm_wre = 0;
                    address_wre = 0;
                    if (count == 7) begin
                        count = 0;
                        state = 7;
                        miso = 0;
                    end
                    else begin
                        count = count + 1;
                    end
                end
            3'd5:
                begin
                    sr_wre = 0;
                    dm_wre = 0;
                    address_wre = 0;
                    miso=0;
                    if (count == 7) begin
                        dm_wre = 0;
                        count = 0;
                        state = 6;
                    end
                    if (count == 6) begin
                        dm_wre = 1;
                        count = count + 1;
                    end
                    else begin
                        count = count + 1;
                    end
                end
            3'd6:
                begin
                    sr_wre = 0;
                    dm_wre = 0;
                    address_wre = 0;
                    miso=0;
                    state = 7;
                end
            3'd7:
                begin
                    sr_wre = 0;
                    dm_wre = 0;
                    address_wre = 0;
                    miso=0;
                    //assign reset <= 1;
                end
        endcase
    end
endmodule

module test();
    reg clk, sclk, cs, mosi, fault;
    wire [3:0] leds;
    initial clk = 0;
    initial sclk = 0;
    wire miso;
    spiMemory spi(clk, sclk, cs, miso, mosi, fault, leds);
    always #1  clk=!clk;
    always #50 sclk=!sclk;
    initial begin
        $dumpfile("spi.vcd");
        $dumpvars(0, test);
        fault =0;
        cs = 0;
        mosi = 1; #100 
        mosi = 1; #100
        mosi = 1; #100
        mosi = 1; #100
        mosi = 0; #100
        mosi = 1; #100
        mosi = 0; #100
        mosi = 0; #100
        mosi = 1; #100
        mosi = 0; #100
        mosi = 1; #100
        mosi = 0; #100
        mosi = 1; #100
        mosi = 1; #100
        mosi = 0; #100
        mosi = 0; #10000
        cs = 1; #400
        cs = 0;
        mosi = 1; #100 
        mosi = 1; #100
        mosi = 1; #100
        mosi = 1; #100
        mosi = 0; #100
        mosi = 1; #100
        mosi = 0; #100
        mosi = 1; #10000
        $display("%b", miso);#100  
        $display("%b", miso);#100
        $display("%b", miso);#100
        $display("%b", miso);#100
        $display("%b", miso);#100
        $display("%b", miso);#100
        $display("%b", miso);#100
        $display("%b", miso);#10000;
    end
endmodule
    
