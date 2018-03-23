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

	Interface for monitoring status & control signals in testbench.

*/
interface status_if (input logic clk);
    
    // default status signals
    logic [7:0] rmapErrorCode      ;
    logic       errorIndication    ;
    logic       writeDataIndication;
    logic       readDataIndication ;
    logic       rmwDataIndication  ;

    // RMAPAuthentication config & errors
    logic [7:0] configKey        ;
    logic [7:0] logicalAddress   ;
    logic       addrInvalid      ;
    logic       dataLengthInvalid;

    // ---------------------------------------
    // driver modport
    // ---------------------------------------
    clocking drvCB @(posedge clk);
        default input #1 output #1;
        output configKey          ;
        output logicalAddress     ;
    endclocking
    
    modport drv (clocking drvCB, input clk); 

    // ---------------------------------------
    // monitor
    // ---------------------------------------
    clocking monCB @(posedge clk);
        default input #1 output #1;
        input rmapErrorCode      ;
        input errorIndication    ;
        input writeDataIndication;
        input readDataIndication ;
        input rmwDataIndication  ;
        input configKey          ;
        input logicalAddress     ;
        input addrInvalid        ;
        input dataLengthInvalid  ;
    endclocking

    modport mon (clocking monCB, input clk);

    endinterface