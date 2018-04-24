class fifo_tx_tmp_scb extends uvm_scoreboard;
 
    `uvm_component_utils(fifo_tx_tmp_scb)
    uvm_analysis_imp#(fifo_seq_item, fifo_tx_tmp_scb) item_collected_export;
 
    // new - constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
 
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_collected_export = new("item_collected_export", this);
    endfunction: build_phase
     
    // write
    virtual function void write(fifo_seq_item trans);
        $display("SCB:: Pkt recived");
        trans.print();
    endfunction : write
 
    // run phase
    virtual task run_phase(uvm_phase phase);
        // empty
    endtask : run_phase
endclass : fifo_tx_tmp_scb