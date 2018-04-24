class fifo_tx_agt extends uvm_agent;
    //declaring agent components
    fifo_tx_drv drv;
    fifo_tx_sqr sqr;
    fifo_tx_mon mon;
 
    // UVM automation macros for general components
    `uvm_component_utils(fifo_tx_agt)
 
    // constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
 
    // build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
 
        if(get_is_active() == UVM_ACTIVE) begin
            drv = fifo_tx_drv::type_id::create("drv", this);
            sqr = fifo_tx_sqr::type_id::create("sqr", this);
        end
 
        mon = fifo_tx_mon::type_id::create("mon", this);
    endfunction : build_phase
 
    // connect_phase
    function void connect_phase(uvm_phase phase);
        if(get_is_active() == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction : connect_phase
 
endclass : fifo_tx_agt