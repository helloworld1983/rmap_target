

module RMAPTargetTop #(
	ADDR_MIN        = 0        , // should be dividable by 4
	ADDR_MAX        = 2048     , // should be dividable by 4
	MAX_READ_LENGTH = (ADDR_MAX - ADDR_MIN), // max length for incrementing read
	BUS_WIDTH       = 32         // should be dividable by 8
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
	// wishbone bus
	output logic                     cycOut             , 
	output logic                     stbOut             , 
	output logic [             31:0] adrOut             , 
	output logic [(BUS_WIDTH/8)-1:0] selOut             , 
	input        [    BUS_WIDTH-1:0] datIn              , 
	output logic [    BUS_WIDTH-1:0] datOut             , 
	output logic                     weOut              , 
	input                            ackIn              , 
	input                            errIn              , 
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

	// fifo interface
	initial begin 
		forever @(posedge clk) begin
			repeat($urandom_range(5,7)) @(posedge clk);
			rxReadEnable <= ($urandom_range(3) == 0);
			@(posedge clk);
			rxReadEnable  <= 0;
		end
	end 
	
	assign txWriteEnable = 0;
	assign txDataIn      = 0;
	// wishbone bus
	assign cycOut = 0;
	assign stbOut = 0;
	assign adrOut = 0;
	assign selOut = 0;
	assign datOut = 0;
	assign weOut  = 0;
	// RMAP error code and status
	assign rmapErrorCode       = 0;
	assign errorIndication     = 0;
	assign writeDataIndication = 0;
	assign readDataIndication  = 0;
	assign rmwDataIndication   = 0;
	// RMAPAuthentication config & errors
	assign addrInvalid         = 0;
	assign dataLengthInvalid   = 0;


endmodule