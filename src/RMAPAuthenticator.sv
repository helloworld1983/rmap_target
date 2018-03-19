/*
    RMAPAuthentication is used to generate control signals for RMAPTargetIPDecoder.

    Commands supported:
        Read single
        Read incrementing
        Write single with acknowledgment
        Read-Modify-Write

    Module use following limitations:
        Only 32-word access, address and data length must be dividable by 4.
        Extended address is not supported.
        
*/

module RMAPAuthentication #(
    ADDR_MIN        = 0       ,             // should be dividable by 4
    ADDR_MAX        = 2048    ,             // should be dividable by 4
    MAX_READ_LENGTH = (ADDR_MAX - ADDR_MIN) // max length for incrementing read
) (
    input               clk                 ,
    input               rst                 ,
    // settings
    input        [ 7:0] configKey           , // should be 0x20 by default
    input        [ 7:0] logicalAddress      , // should be 0xFE by default
    // to RMAPTargetIPDecoder
    input        [ 7:0] rmapLogicalAddress  ,
    input        [ 3:0] rmapCommand         ,
    input        [ 7:0] rmapKey             ,
    input        [ 7:0] rmapExtendedAddress ,
    input        [31:0] rmapAddress         ,
    input        [23:0] rmapDataLength      ,
    input               requestAuthorization,
    output logic        authorizeAck        ,
    output logic        rejectAck           ,
    output logic [ 7:0] replyStatus         ,
    // status -- errors
    output logic        addrInvalid         ,
    output logic        dataLengthInvalid
);


    logic       writeDataLenValid, rmwDataLenValid, readDataLenValid;
    logic       wrAddrValid, wrAddrValidNxt;
    logic       rdAddrValid, rdAddrValidNxt;
    logic       rdAddrOverflow, rdAddrOverflowNxt;
    logic [7:0] replyStatusNxt      ;
    logic       rejectNxt           ;
    logic       addrInvalidNxt      ;
    logic       dataLengthInvalidNxt;


    // ----------------------------------------------------------------
    // First stage check
    // ----------------------------------------------------------------

    // check is done with one-cycle delay for better performance
    always_ff @(posedge clk or posedge rst) begin 
        if(rst) begin
            writeDataLenValid <= 0;
            rmwDataLenValid   <= 0;
            readDataLenValid  <= 0;
            wrAddrValid       <= 0;
            rdAddrValid       <= 0;
            rdAddrOverflow    <= 0;
        end
        else begin
            // data length check
            writeDataLenValid <= (rmapDataLength == 24'd4);
            rmwDataLenValid   <= (rmapDataLength == 24'd8);
            readDataLenValid  <= (rmapDataLength <= MAX_READ_LENGTH) && (~|rmapDataLength[1:0]);
            // register address check
            wrAddrValid       <= wrAddrValidNxt;
            rdAddrValid       <= rdAddrValidNxt;
            rdAddrOverflow    <= rdAddrOverflowNxt;
        end
    end 
        
    always_comb begin
        wrAddrValidNxt    = 0;
        rdAddrValidNxt    = 0;
        rdAddrOverflowNxt = 0;

        if(~|rmapExtendedAddress & ~|rmapAddress[1:0]) begin // extended addr & byte operations not supported
            if((rmapAddress >= ADDR_MIN) & (rmapAddress <= ADDR_MAX)) begin
                wrAddrValidNxt = 1;          
                rdAddrValidNxt = 1;
            end
            if ((rmapAddress + rmapDataLength) > ADDR_MAX) begin // incrementing read overflow
                rdAddrOverflowNxt = 1;
            end
        end 
    end  
    

    // ----------------------------------------------------------------
    // Second stage check
    // ----------------------------------------------------------------

    always_ff @(posedge clk)
        if(rst) begin
            replyStatus       <= 8'h00;
            authorizeAck      <= 0;
            rejectAck         <= 0;
            addrInvalid       <= 0;
            dataLengthInvalid <= 0;
        end
        else begin
            replyStatus       <= replyStatusNxt;
            authorizeAck      <= !rejectNxt    ;
            rejectAck         <=  rejectNxt    ;
            addrInvalid       <= addrInvalidNxt        & !(authorizeAck | rejectAck);
            dataLengthInvalid <= dataLengthInvalidNxt  & !(authorizeAck | rejectAck);
        end
    
    always_comb begin // main check 
        replyStatusNxt       = 8'h00;
        rejectNxt            = 0;
        addrInvalidNxt       = 0;
        dataLengthInvalidNxt = 0;
        
        if(requestAuthorization) begin 
            // invalid logical adress
            if(rmapLogicalAddress != logicalAddress) begin
                replyStatusNxt = 8'd12; 
                rejectNxt      = 1;
            // unused command
            end else if((rmapCommand[3:1] == 3'd0) | (rmapCommand[3:2] == 2'b01) & ~&rmapCommand[1:0]) begin
                replyStatusNxt = 8'd2; 
                rejectNxt      = 1;
            // invalid key
            end else if(configKey != rmapKey) begin
                replyStatusNxt = 8'd3; 
                rejectNxt      = 1;
            // address or data length errors
            end else case(rmapCommand)
                4'b0010 :   begin // read single 
                                addrInvalidNxt       = !rdAddrValid;
                                dataLengthInvalidNxt = !writeDataLenValid;
                                if(!rdAddrValid | !writeDataLenValid) begin
                                    replyStatusNxt = 8'h01; 
                                    rejectNxt      = 1;
                                end
                            end
                4'b0011 :   begin // read incrementing
                                addrInvalidNxt       = !rdAddrValid;
                                dataLengthInvalidNxt = !readDataLenValid;
                                if(!rdAddrValid | !readDataLenValid | rdAddrOverflow) begin
                                    replyStatusNxt = 8'h01; 
                                    rejectNxt      = 1;
                                end
                            end
                4'b0111 :   begin // RMW
                                addrInvalidNxt       = !wrAddrValid;
                                dataLengthInvalidNxt = !rmwDataLenValid;
                                if(!wrAddrValid | !rmwDataLenValid) begin
                                    replyStatusNxt = 8'h01; 
                                    rejectNxt      = 1;
                                end
                            end
                4'b1110 :   begin // write single
                                addrInvalidNxt       = !wrAddrValid;
                                dataLengthInvalidNxt = !writeDataLenValid;
                                if(!wrAddrValid | !writeDataLenValid) begin
                                    replyStatusNxt = 8'h01; 
                                    rejectNxt      = 1;
                                end
                            end
                default :   begin // command not implemented
                                replyStatusNxt = 8'h0A; 
                                rejectNxt      = 1;
                            end
             endcase
        end // of if
    end // of always
    
    
    
endmodule



















