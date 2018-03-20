module RMAPTargetTop_TB ();

	localparam ADDR_MIN = 0;
	localparam ADDR_MAX = 2048;
	localparam BUS_WIDTH = 32;


	bit clk;
	bit rst;

	logic       txWriteEnable;
	logic [8:0] txDataIn     ;
	logic       txFull       ;
	logic       rxReadEnable ;
	logic [8:0] rxDataOut    ;
	logic       rxEmpty      ;

	logic                     cycOut;
	logic                     stbOut;
	logic [             31:0] adrOut;
	logic [(BUS_WIDTH/8)-1:0] selOut;
	logic [    BUS_WIDTH-1:0] datIn ;
	logic [    BUS_WIDTH-1:0] datOut;
	logic                     weOut ;
	logic                     ackIn ;
	logic                     errIn ;

	logic [7:0] rmapErrorCode      ;
	logic       errorIndication    ;
	logic       writeDataIndication;
	logic       readDataIndication ;
	logic       rmwDataIndication  ;
	logic [7:0] configKey          ;
	logic [7:0] logicalAddress     ;
	logic       addrInvalid        ;
	logic       dataLengthInvalid  ;

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