/*
	------------------------------------------------------------------------------
	-- The MIT License (MIT)
	--
	-- Copyright (c) <2018> <Vitaliy Konovalov>
	--
	-- Permission is hereby granted, free of charge, to any person obtaining a copy
	-- of this software and associated documentation files (the "Software"), to deal
	-- in the Software without restriction, including without limitation the rights
	-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	-- copies of the Software, and to permit persons to whom the Software is
	-- furnished to do so, subject to the following conditions:
	--
	-- The above copyright notice and this permission notice shall be included in
	-- all copies or substantial portions of the Software.
	--
	-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	-- THE SOFTWARE.
	-------------------------------------------------------------------------------
*/

module RMAPTargetTop_TB ();

	localparam ADDR_MIN = 0;
	localparam ADDR_MAX = 2048;
	localparam BUS_WIDTH = 32;

	// --------------------------------------------------------
	// clock & reset generation
	// --------------------------------------------------------

	bit clk;
	bit rst;
	
	always #10 clk = !clk;

	initial begin 
		rst = 1;
		@(posedge clk) rst <= 0;
	end

	// --------------------------------------------------------
	// interfaces
	// --------------------------------------------------------

	txFIFOif              tx_fifo_if (clk);
	rxFIFOif              rx_fifo_if (clk);
	statusIf              status_if  (clk);
	wbIf     #(BUS_WIDTH) wb_if      (clk);

	// --------------------------------------------------------
	// DUT
	// --------------------------------------------------------

	RMAPTargetTop #(.ADDR_MIN(ADDR_MIN), .ADDR_MAX(ADDR_MAX), .BUS_WIDTH(BUS_WIDTH)) uRMAPTargetTop (
		.clk                (clk                          ),
		.rst                (rst                          ),
		//
		.txWriteEnable      (tx_fifo_if.writeEnable        ),
		.txDataIn           (tx_fifo_if.dataIn             ),
		.txFull             (tx_fifo_if.full               ),
		.rxReadEnable       (rx_fifo_if.readEnable         ),
		.rxDataOut          (rx_fifo_if.dataOut            ),
		.rxEmpty            (rx_fifo_if.empty              ),
		//
		.cycOut             (wb_if.cyc                    ),
		.stbOut             (wb_if.stb                    ),
		.adrOut             (wb_if.adr                    ),
		.selOut             (wb_if.sel                    ),
		.datIn              (wb_if.datMstIn               ),
		.datOut             (wb_if.datSlvIn               ),
		.weOut              (wb_if.we                     ),
		.ackIn              (wb_if.ack                    ),
		.errIn              (wb_if.err                    ),
		//
		.rmapErrorCode      (status_if.rmapErrorCode      ),
		.errorIndication    (status_if.errorIndication    ),
		.writeDataIndication(status_if.writeDataIndication),
		.readDataIndication (status_if.readDataIndication ),
		.rmwDataIndication  (status_if.rmwDataIndication  ),
		.configKey          (status_if.configKey          ),
		.logicalAddress     (status_if.logicalAddress     ),
		.addrInvalid        (status_if.addrInvalid        ),
		.dataLengthInvalid  (status_if.dataLengthInvalid  )
	);


	initial begin
		uvm_config_db#(virtual txFIFOif)::set(uvm_root::get(),"*","tx_fifo_if",tx_fifo_if);
		uvm_config_db#(virtual rxFIFOif)::set(uvm_root::get(),"*","rx_fifo_if",rx_fifo_if);
		uvm_config_db#(virtual statusIf)::set(uvm_root::get(),"*","status_if" ,status_if );
		uvm_config_db#(virtual wbIf    )::set(uvm_root::get(),"*","wb_if"     ,wb_if     );
		
		$dumpfile("dump.vcd"); $dumpvars;
	end
	 
	initial begin
		run_test("RMAPTargetTop_test_tmp");
	end

endmodule