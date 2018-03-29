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

	txFIFOif txFIFOif (clk);
	rxFIFOif rxFIFOif (clk);
	statusIf statusIf (clk);
	wbIf #(BUS_WIDTH) wbIf (clk);

	// --------------------------------------------------------
	// DUT
	// --------------------------------------------------------

	RMAPTargetTop #(.ADDR_MIN(ADDR_MIN), .ADDR_MAX(ADDR_MAX), .BUS_WIDTH(BUS_WIDTH)) uRMAPTargetTop (
		.clk                (clk                          ),
		.rst                (rst                          ),
		//
		.txWriteEnable      (txFIFOif.writeEnable        ),
		.txDataIn           (txFIFOif.dataIn             ),
		.txFull             (txFIFOif.full               ),
		.rxReadEnable       (rxFIFOif.readEnable         ),
		.rxDataOut          (rxFIFOif.dataOut            ),
		.rxEmpty            (rxFIFOif.empty              ),
		//
		.cycOut             (wbIf.cyc                    ),
		.stbOut             (wbIf.stb                    ),
		.adrOut             (wbIf.adr                    ),
		.selOut             (wbIf.sel                    ),
		.datIn              (wbIf.datMstIn               ),
		.datOut             (wbIf.datSlvIn               ),
		.weOut              (wbIf.we                     ),
		.ackIn              (wbIf.ack                    ),
		.errIn              (wbIf.err                    ),
		//
		.rmapErrorCode      (statusIf.rmapErrorCode      ),
		.errorIndication    (statusIf.errorIndication    ),
		.writeDataIndication(statusIf.writeDataIndication),
		.readDataIndication (statusIf.readDataIndication ),
		.rmwDataIndication  (statusIf.rmwDataIndication  ),
		.configKey          (statusIf.configKey          ),
		.logicalAddress     (statusIf.logicalAddress     ),
		.addrInvalid        (statusIf.addrInvalid        ),
		.dataLengthInvalid  (statusIf.dataLengthInvalid  )
	);

endmodule