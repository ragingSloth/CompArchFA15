module testFSM();

wire	MISO_buf;
wire	dataMem_WE;
wire	addr_WE;
wire	shiftReg_WE;
reg 	clkEdge; // Runs on the posedge of sclk from SPI
reg 	chipSel; // Hard reset for the FSM
reg 	shiftRegOut0;


    fsm dut(.miso(MISO_buf),
    			 .dm_wre(dataMem_WE),
			 .address_wre(addr_WE),
			 .sr_wre(shiftReg_WE),
			 .sclk(clkEdge),
			 .cs(chipSel),
			 .register_lsb(shiftRegOut0));

reg[7:0]	yolo;
    initial begin
    $dumpfile("conditioner.vcd");
    $dumpvars(0, testFSM);
    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronize, Clean, Preprocess (edge finding)
    // TEST CASE 1: Run the whole shebang. Copmare to chart from the lab handout. Note that it will stay in "DONE" state.
	chipSel = 0;
	shiftRegOut0 = 1;
	$display("TEST 1: MISO || dataMem || addrWE || ShiftRegWE");
	for (yolo=0; yolo<40; yolo=yolo+1) begin
		clkEdge = 1; //The clock could be an always loop, but this sequence tests the graph more than the synchrony with clocks.
		#30 
		clkEdge=0;
		$display("%b, %b, %b, %b", MISO_buf, dataMem_WE, addr_WE, shiftReg_WE);
		#500;
	end
    // TEST CASE 2: Reset CS high low, then run it all again. Compare to chart from the lab handout.
	chipSel = 1;
	clkEdge = 1;
	#30
	clkEdge = 0;
	chipSel = 0;
	#30
	shiftRegOut0 = 0;
	$display("TEST 2: MISO || dataMem || addrWE || ShiftRegWE");
	for (yolo=0; yolo<40; yolo=yolo+1) begin
		clkEdge = 1; 
		#30 
		clkEdge=0;
		$display("%b, %b, %b, %b", MISO_buf, dataMem_WE, addr_WE, shiftReg_WE);
		#500;
	end
    end

endmodule
