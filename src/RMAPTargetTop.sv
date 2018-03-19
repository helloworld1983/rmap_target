module RMAPTargetTop #(
	ADDR_MIN        = 0        , // should be dividable by 4
	ADDR_MAX        = 2048     , // should be dividable by 4
	MAX_READ_LENGTH = (ADDR_MAX - ADDR_MIN), // max length for incrementing read
	BUS_WIDTH       = 32		 // should be dividable by 8
) (
	input                            clk                ,
	input                            rst                ,
	// fifo interface
	output logic                     txWriteEnable      ,
	output logic [              8:0] txDataIn           ,
	input                            txFull             ,
	output logic                     rxReadEnable       ,
	input        [              8:0] rxDataOut          ,
	input                            rxEmpty            ,
	// internal BUS
	output logic                     busCycleOut        ,
	output logic                     busStrobeOut       ,
	output logic [             31:0] busAddressOut      ,
	output logic [(BUS_WIDTH/8)-1:0] busByteEnableOut   ,
	input        [    BUS_WIDTH-1:0] busDataIn          ,
	output logic [    BUS_WIDTH-1:0] busDataOut         ,
	output logic                     busWriteEnableOut  ,
	output logic                     busReadEnableOut   ,
	input                            busAcknowledgeIn   ,
	input                            busTimeOutErrorIn  ,
	// RMAP error code and status
	output logic [              7:0] rmapErrorCode      ,
	output logic                     errorIndication    ,
	output logic                     writeDataIndication,
	output logic                     readDataIndication ,
	output logic                     rmwDataIndication  ,
	// RMAPAuthentication config & errors
	input        [              7:0] configKey          ,
	input        [              7:0] logicalAddress     ,
	output logic                     addrInvalid        ,
	output logic                     dataLengthInvalid
);

	//
	logic [ 7:0] rmapLogicalAddress  ;
	logic [ 3:0] rmapCommand         ;
	logic [ 7:0] rmapKey             ;
	logic [ 7:0] rmapExtendedAddress ;
	logic [31:0] rmapAddress         ;
	logic [23:0] rmapDataLength      ;
	logic        requestAuthorization;
	logic        authorizeAck        ;
	logic        rejectAck           ;
	logic [ 7:0] replyStatus         ;


	RMAPTargetIP #(.gBusWidth(BUS_WIDTH)) uRMAPTargetIP (
		.clock                  (clk                 ),
		.reset                  (rst                 ),
		
		// FIFO
		.transmitFIFOWriteEnable(txWriteEnable       ),
		.transmitFIFODataIn     (txDataIn            ),
		.transmitFIFOFull       (txFull              ),
		.receiveFIFOReadEnable  (rxReadEnable        ),
		.receiveFIFODataOut     (rxDataOut           ),
		.receiveFIFOEmpty       (rxEmpty             ),
		
		// Internal BUS
		.busMasterCycleOut      (busCycleOut         ),
		.busMasterStrobeOut     (busStrobeOut        ),
		.busMasterAddressOut    (busAddressOut       ),
		.busMasterByteEnableOut (busByteEnableOut    ),
		.busMasterDataIn        (busDataIn           ),
		.busMasterDataOut       (busDataOut          ),
		.busMasterWriteEnableOut(busWriteEnableOut   ),
		.busMasterReadEnableOut (busReadEnableOut    ),
		.busMasterAcknowledgeIn (busAcknowledgeIn    ),
		.busMasterTimeOutErrorIn(busTimeOutErrorIn   ),
		
		// RMAP Statemachines state
		.commandStateOut        (                    ),
		.replyStateOut          (                    ),
		
		// RMAP_User_Decode
		.rmapExtendedAddressOut (rmapExtendedAddress ),
		.rmapLogicalAddressOut  (rmapLogicalAddress  ),
		.rmapCommandOut         (rmapCommand         ),
		.rmapKeyOut             (rmapKey             ),
		.rmapAddressOut         (rmapAddress         ),
		.rmapDataLengthOut      (rmapDataLength      ),
		.requestAuthorization   (requestAuthorization),
		.authorizeIn            (authorizeAck        ),
		.rejectIn               (rejectAck           ),
		.replyStatusIn          (replyStatus         ),
		
		// RMAP Error Code and Status
		.rmapErrorCode          (rmapErrorCode       ),
		.errorIndication        (errorIndication     ),
		.writeDataIndication    (writeDataIndication ),
		.readDataIndication     (readDataIndication  ),
		.rmwDataIndication      (rmwDataIndication   )
	);

	RMAPAuthentication #(
		.ADDR_MIN       (ADDR_MIN       ),
		.ADDR_MAX       (ADDR_MAX       ),
		.MAX_READ_LENGTH(MAX_READ_LENGTH)
	) uRMAPAuthentication (
		.clk                 (clk                 ),
		.rst                 (rst                 ),
		// config
		.configKey           (configKey           ),
		.logicalAddress      (logicalAddress      ),
		// interface to RMAPTargetIP
		.rmapLogicalAddress  (rmapLogicalAddress  ),
		.rmapCommand         (rmapCommand         ),
		.rmapKey             (rmapKey             ),
		.rmapExtendedAddress (rmapExtendedAddress ),
		.rmapAddress         (rmapAddress         ),
		.rmapDataLength      (rmapDataLength      ),
		.requestAuthorization(requestAuthorization),
		.authorizeAck        (authorizeAck        ),
		.rejectAck           (rejectAck           ),
		.replyStatus         (replyStatus         ),
		// status
		.addrInvalid         (addrInvalid         ),
		.dataLengthInvalid   (dataLengthInvalid   )
	);


endmodule