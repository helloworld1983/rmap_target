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

	typedef bit[7:0] ubyte;

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
		$stop;
	end

	// main
	initial begin 
		// wait for reset
		while(rst) @(posedge clk);

		
		// start interface signals
		fork
			// tx fifo interface
			txFull = 1;
			forever @(posedge clk) txFull <= (txFull) ? ($urandom_range(5) == 0) : txFull;

			// wishbone interface
			ackIn = 0;
			forever @(posedge clk) ackIn <= $urandom_range(1);
			datIn = 0;
			errIn = 0;

			// config signals
			configKey      = 8'h20;
			logicalAddress = 8'hFE;
		join_none

		// send packets to DUT
		writeRMAP(32'h4,32'h89AB_CDEF,16'h45_67);


		// finish sim
		repeat(100) @(posedge clk);
		$display("%t : Main task successfully completed.",$time);
		$stop;
	end

	// ---------------------------------------------------
	// Tasks
	// ---------------------------------------------------

	task writeRMAP(
			bit [3:0][7:0] addr                 ,
			bit [3:0][7:0] data                 ,
			bit [1:0][7:0] transID              ,
			ubyte          key           = 8'h20,
			// ubyte          replyAddr  [] ={8'hZ}, // should be 0,4,8 or 12 size
			ubyte          targLogAddr   = 8'hFE,
			ubyte          initLogAddr   = 8'hFE
			);

		static ubyte          protocolID  = 8'h01;
		static ubyte          instruction = {2'b01,4'b1110,2'b00/*replyAddr.size()/4*/};
		static ubyte          extAddr     = 8'h00;
		static bit [2:0][7:0] dataLen     = 24'd4;

		ubyte dataForCRC[4];

		ubyte packet[$];


		// convert data to unpacket array
		foreach(dataForCRC[i]) dataForCRC[i] = data[3-i];

		// prepare RMAP packet
		packet.push_back(targLogAddr);
		packet.push_back(protocolID);
		packet.push_back(instruction);
		packet.push_back(key);
		//
		// here should be replyAddr, but not implemented yet
		//
		packet.push_back(initLogAddr);
		packet.push_back(transID[1]);
		packet.push_back(transID[0]);
		packet.push_back(extAddr);
		packet.push_back(addr[3]);
		packet.push_back(addr[2]);
		packet.push_back(addr[1]);
		packet.push_back(addr[0]);
		packet.push_back(dataLen[2]);
		packet.push_back(dataLen[1]);
		packet.push_back(dataLen[0]);
		packet.push_back(calcCRC(packet)); 
		packet.push_back(data[3]);
		packet.push_back(data[2]);
		packet.push_back(data[1]);
		packet.push_back(data[0]);
		packet.push_back(calcCRC(dataForCRC)); 

		// send packet
		rxGetsPacket(packet);
		
	endtask : writeRMAP


	// calculate CRC for RMAP packets
	function ubyte calcCRC(ubyte data[]);
		static ubyte crc;
		static ubyte crcTable[] = {'h00, 'h91, 'he3, 'h72, 'h07, 'h96, 'he4, 'h75, 
		                          'h0e, 'h9f, 'hed, 'h7c, 'h09, 'h98, 'hea, 'h7b, 
		                          'h1c, 'h8d, 'hff, 'h6e, 'h1b, 'h8a, 'hf8, 'h69, 
		                          'h12, 'h83, 'hf1, 'h60, 'h15, 'h84, 'hf6, 'h67, 
		                          'h38, 'ha9, 'hdb, 'h4a, 'h3f, 'hae, 'hdc, 'h4d, 
		                          'h36, 'ha7, 'hd5, 'h44, 'h31, 'ha0, 'hd2, 'h43, 
		                          'h24, 'hb5, 'hc7, 'h56, 'h23, 'hb2, 'hc0, 'h51, 
		                          'h2a, 'hbb, 'hc9, 'h58, 'h2d, 'hbc, 'hce, 'h5f, 
		                          'h70, 'he1, 'h93, 'h02, 'h77, 'he6, 'h94, 'h05, 
		                          'h7e, 'hef, 'h9d, 'h0c, 'h79, 'he8, 'h9a, 'h0b, 
		                          'h6c, 'hfd, 'h8f, 'h1e, 'h6b, 'hfa, 'h88, 'h19, 
		                          'h62, 'hf3, 'h81, 'h10, 'h65, 'hf4, 'h86, 'h17, 
		                          'h48, 'hd9, 'hab, 'h3a, 'h4f, 'hde, 'hac, 'h3d, 
		                          'h46, 'hd7, 'ha5, 'h34, 'h41, 'hd0, 'ha2, 'h33, 
		                          'h54, 'hc5, 'hb7, 'h26, 'h53, 'hc2, 'hb0, 'h21, 
		                          'h5a, 'hcb, 'hb9, 'h28, 'h5d, 'hcc, 'hbe, 'h2f, 
		                          'he0, 'h71, 'h03, 'h92, 'he7, 'h76, 'h04, 'h95, 
		                          'hee, 'h7f, 'h0d, 'h9c, 'he9, 'h78, 'h0a, 'h9b, 
		                          'hfc, 'h6d, 'h1f, 'h8e, 'hfb, 'h6a, 'h18, 'h89, 
		                          'hf2, 'h63, 'h11, 'h80, 'hf5, 'h64, 'h16, 'h87, 
		                          'hd8, 'h49, 'h3b, 'haa, 'hdf, 'h4e, 'h3c, 'had, 
		                          'hd6, 'h47, 'h35, 'ha4, 'hd1, 'h40, 'h32, 'ha3, 
		                          'hc4, 'h55, 'h27, 'hb6, 'hc3, 'h52, 'h20, 'hb1, 
		                          'hca, 'h5b, 'h29, 'hb8, 'hcd, 'h5c, 'h2e, 'hbf, 
		                          'h90, 'h01, 'h73, 'he2, 'h97, 'h06, 'h74, 'he5, 
		                          'h9e, 'h0f, 'h7d, 'hec, 'h99, 'h08, 'h7a, 'heb, 
		                          'h8c, 'h1d, 'h6f, 'hfe, 'h8b, 'h1a, 'h68, 'hf9, 
		                          'h82, 'h13, 'h61, 'hf0, 'h85, 'h14, 'h66, 'hf7, 
		                          'ha8, 'h39, 'h4b, 'hda, 'haf, 'h3e, 'h4c, 'hdd, 
		                          'ha6, 'h37, 'h45, 'hd4, 'ha1, 'h30, 'h42, 'hd3, 
		                          'hb4, 'h25, 'h57, 'hc6, 'hb3, 'h22, 'h50, 'hc1, 
		                          'hba, 'h2b, 'h59, 'hc8, 'hbd, 'h2c, 'h5e, 'hcf};

		crc = 0;
		for (int i = 0; i < data.size(); i++) begin
			crc = crcTable[crc ^ data[i]];
		end

		return crc;
	endfunction : calcCRC

	// send SpaceWire packet to DUT
	task rxGetsPacket(ubyte data[], bit eep=0, int maxDelay=5);
		for (int i = 0; i < data.size(); i++) begin
			rxGetsData(data[i],0,$urandom_range(maxDelay));
		end
		rxGetsData({7'b0,eep},1,$urandom_range(maxDelay));
	endtask : rxGetsPacket

	// send one data character to DUT
	task rxGetsData(ubyte data, bit flag=0, int delay=0);
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