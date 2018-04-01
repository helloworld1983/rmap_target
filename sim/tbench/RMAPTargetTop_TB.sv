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

	// ---------------------------------------------------
	// Signals declaration
	// ---------------------------------------------------

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

	// ---------------------------------------------------
	// Clock & reset
	// ---------------------------------------------------


	always #10 clk = !clk;

	initial begin 
		rst = 1;
		repeat(2) @(posedge clk);
		rst <= 0;
	end

	// ---------------------------------------------------
	// Main
	// ---------------------------------------------------

	// timeout
	initial begin 
		repeat(5000) @(posedge clk);
		$error("%t : SIMULATION TERMINATED BY TIMEOUT",$time);
		$finish;
	end

	// main
	initial begin 
		// wait for reset
		while(rst) @(posedge clk);

		// start interface signals
		fork
			// tx fifo interface
			forever @(posedge clk) txFull <= $urandom_range(1);

			// wishbone interface
			forever @(posedge clk) ackIn <= $urandom_range(1);
			datIn = 0;
			errIn = 0;

			// config signals
			configKey      = 8'h20;
			logicalAddress = 8'hFE;
		join_none

		// send packets to DUT
		writeRMAP(32'h4,32'h89AB_CDEF,16'h45_67);
	end

	// ---------------------------------------------------
	// Tasks
	// ---------------------------------------------------

	task writeRMAP(
			byte [3:0] addr             ,
			byte [3:0] data             ,
			byte [1:0] transID          ,
			byte       key=8'h20        ,
			byte       replyAddr[]      , // should be 0,4,8 or 12 size
			byte       targLogAddr=8'hFE,
			byte       initLogAddr=8'hFE
		);

		byte       protocolID  = 8'h01;
		byte       instruction = {2'b01,4'b1110,replyAddr.size()/4};
		byte       extAddr     = 8'h00;
		byte [2:0] dataLen     = 24'd4;

		byte packet[$];

		// prepare RMAP packet
		packet.push_back(targLogAddr);
		packet.push_back(protocolID);
		packet.push_back(instruction);
		packet.push_back(key);
		for (int i = 0; i < replyAddr.size(); i++) begin
			packet.push_back(replyAddr[i]);
		end
		packet.push_back(initLogAddr);
		packet.push_back(transID[15:8]);
		packet.push_back(transID[ 7:0]);
		packet.push_back(extAddr);
		for (int i = 3; i >= 0; i--) begin
			packet.push_back(addr[i*8 +: 8]);
		end
		for (int i = 2; i >= 0; i--) begin
			packet.push_back(dataLen[i*8 +: 8]);
		end
		packet.push_back(calcCRC(packet)); 
		for (int i = 3; i >= 0; i--) begin
			packet.push_back(data[i*8 +: 8]);
		end
		packet.push_back(calcCRC(data)); 

		// send packet
		rxGetsPacket(byte'(packet));
		
	endtask : writeRMAP


	// calculate CRC for RMAP packets
	function byte calcCRC(byte data[]);
		
	endfunction : calcCRC

	// send SpaceWire packet to DUT
	task rxGetsPacket(byte data[], bit eep=0, int maxDelay=5);
		for (int i = 0; i < data.size(); i++) begin
			rxGetsData(data[i],0,$urandom_range(maxDelay));
		end
		rxGetsData({7'b0,eep},1,$urandom_range(maxDelay));
	endtask : rxGetsPacket

	// send one data charecter to DUT
	task rxGetsData(byte data, bit flag=0, int delay=0);
		repeat(delay) @(posedge clk);
		rxEmpty <= 0;
		do @(posedge clk); while(!rxReadEnable);
		rxDataOut <= {flag, data};
		rxEmpty   <= 1;
	endtask : rxGetsData

	// ---------------------------------------------------
	// DUT
	// ---------------------------------------------------

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