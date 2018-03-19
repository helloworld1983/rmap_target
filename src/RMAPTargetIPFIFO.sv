module RMAPTargetIPFIFO #(
	DATA_WIDTH = 9,
	ADDR_WIDTH = 4
) (
	input                         clk       ,
	input                         rst       ,
	// write interface
	input        [DATA_WIDTH-1:0] dataIn    ,
	input                         wrEnable  ,
	output logic                  full      ,
	// read interface
	output logic [DATA_WIDTH-1:0] dataOut   ,
	input                         rdEnable  ,
	output logic                  empty     ,
	// empty space counter
	output logic [  ADDR_WIDTH:0] statusCntr
);    

	localparam RAM_DEPTH = (1 << ADDR_WIDTH);
	
	logic [ADDR_WIDTH-1:0] wr_pointer   ;
	logic [ADDR_WIDTH-1:0] rd_pointer   ;
	logic [  ADDR_WIDTH:0] statusCntrNxt;
	
	logic [DATA_WIDTH-1:0] mem[RAM_DEPTH]; 
	
	// ----------------------------------------------
	// RAM
	// ----------------------------------------------
	always @(posedge clk)
		if(rdEnable & !empty) dataOut <= mem[rd_pointer];

	always @(posedge clk)
		if(wrEnable & !full) mem[wr_pointer] <= dataIn; 

	// ----------------------------------------------   
	// full & empty
	// ----------------------------------------------   
	always_ff @(posedge clk or posedge rst)
		if(rst) empty <= 1;
		else if(statusCntrNxt[ADDR_WIDTH]) empty <= 1;
		else                               empty <= 0;
	
	always_ff @(posedge clk or posedge rst)
		if(rst) full <= 0;
		else if(statusCntrNxt == 0) full <= 1;
		else                        full <= 0;
		
	// ----------------------------------------------
	// pointers
	// ----------------------------------------------
	always_ff @(posedge clk or posedge rst) begin 
		if(rst) wr_pointer <= 0;
		else if(wrEnable & !full) wr_pointer <= wr_pointer + 1;
	end
	
	always_ff @(posedge clk or posedge rst) begin 
		if(rst) rd_pointer <= 0;
		else if(rdEnable & !empty) rd_pointer <= rd_pointer + 1;
	end
	
	always_ff @(posedge clk or posedge rst) begin 
		if(rst) statusCntr <= (1 << ADDR_WIDTH);
		else statusCntr <= statusCntrNxt;
	end
	
	always_comb begin 
		if((rdEnable & !empty) & !(wrEnable & !full)) 		statusCntrNxt = statusCntr + 1; // Read but not write
		else if(!(rdEnable & !empty) & (wrEnable & !full)) statusCntrNxt = statusCntr - 1; // Write but not read
		else statusCntrNxt = statusCntr;
			 
	end		 
endmodule 



	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	