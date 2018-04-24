class fifo_tx_mon extends uvm_monitor;
 
    // Virtual Interface
    virtual txFIFOif fifo_vi;
 
    uvm_analysis_port #(fifo_seq_item) item_collected_port;
 
    // Placeholder to capture transaction information.
    fifo_seq_item trans;
 
    `uvm_component_utils(fifo_tx_mon)
 
    // new - constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
        trans = new();
        item_collected_port = new("item_collected_port", this);
    endfunction : new
 
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
 
    // run phase
    virtual task run_phase(uvm_phase phase);
        forever begin
            @fifo_vi.monCB;
            if(fifo_vi.writeEnable & !fifo_vi.full) fork
                begin
                    @fifo_vi.monCB;
                    trans.data = fifo_vi.dataIn[7:0];
                    trans.eop  = fifo_vi.dataIn[8];
                    item_collected_port.write(trans);
                end
            join_none
        end
    endtask : run_phase
 
endclass : fifo_tx_mon