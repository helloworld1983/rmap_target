class fifo_tx_drv extends uvm_driver#(fifo_seq_item);

    `uvm_component_utils(fifo_tx_drv)

    virtual txFIFOif fifo_vi;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(
            uvm_config_db#(virtual txFIFOif)::get
            (
                .cntxt     (this      ),
                .inst_name (""        ),
                .field_name("txFIFOif"),
                .value     (fifo_vi   )
            )
        );
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        fifo_seq_item trans;

        forever begin
            seq_item_port.get_next_item(trans);
            
            
            if(trans.delay > 0) repeat(trans.delay) @fifo_vi.drvCB;
            fifo_vi.drvCB.empty <= 1;

            do @fifo_vi.drvCB; while(!fifo_vi.readEnable);
            fifo_vi.drvCB.empty <= 0;
            
            fork
                @fifo_vi.drvCB; 
                fifo_vi.drvCB.dataOut[7:0] <= trans.data;
                fifo_vi.drvCB.dataOut[8]   <= trans.eop ;
            join_none

            seq_item_port.item_done();
        end
    endtask: run_phase
endclass: fifo_tx_drv