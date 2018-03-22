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


	bit clk;
	bit rst;

	// fifo interface
	logic       txWriteEnable;
	logic [8:0] txDataIn     ;
	logic       txFull       ;
	logic       rxReadEnable ;
	logic [8:0] rxDataOut    ;
	logic       rxEmpty      ;

	// wishbone interface
	logic                     cycOut;
	logic                     stbOut;
	logic [             31:0] adrOut;
	logic [(BUS_WIDTH/8)-1:0] selOut;
	logic [    BUS_WIDTH-1:0] datIn ;
	logic [    BUS_WIDTH-1:0] datOut;
	logic                     weOut ;
	logic                     ackIn ;
	logic                     errIn ;

	// status
	logic [7:0] rmapErrorCode      ;
	logic       errorIndication    ;
	logic       writeDataIndication;
	logic       readDataIndication ;
	logic       rmwDataIndication  ;
	logic       addrInvalid        ;
	logic       dataLengthInvalid  ;

	// config
	logic [7:0] configKey          ;
	logic [7:0] logicalAddress     ;

	initial begin 
		configKey = 8'h20;
		logicalAddress = 8'hFE;
	end

	always #10 clk = !clk;

	initial begin 
		rst = 1;
		repeat(2) @(posedge clk);
		rst <= 0;
	end

	initial begin 
		repeat(5000) @(posedge clk);
		$error("%t : SIMULATION TERMINATED BY TIMEOUT",$time);
		$finish;
	end


	RMAPTargetTop #(.ADDR_MIN(ADDR_MIN), .ADDR_MAX(ADDR_MAX), .BUS_WIDTH(BUS_WIDTH)) uRMAPTargetTop (
		.clk                (clk                ),
		.rst                (rst                ),
		//
		.txWriteEnable      (txWriteEnable      ),
		.txDataIn           (txDataIn           ),
		.txFull             (txFull             ),
		.rxReadEnable       (rxReadEnable       ),
		.rxDataOut          (rxDataOut          ),
		.rxEmpty            (rxEmpty            ),
		//
		.cycOut             (cycOut             ),
		.stbOut             (stbOut             ),
		.adrOut             (adrOut             ),
		.selOut             (selOut             ),
		.datIn              (datIn              ),
		.datOut             (datOut             ),
		.weOut              (weOut              ),
		.ackIn              (ackIn              ),
		.errIn              (errIn              ),
		//
		.rmapErrorCode      (rmapErrorCode      ),
		.errorIndication    (errorIndication    ),
		.writeDataIndication(writeDataIndication),
		.readDataIndication (readDataIndication ),
		.rmwDataIndication  (rmwDataIndication  ),
		.configKey          (configKey          ),
		.logicalAddress     (logicalAddress     ),
		.addrInvalid        (addrInvalid        ),
		.dataLengthInvalid  (dataLengthInvalid  )
	);

endmodule