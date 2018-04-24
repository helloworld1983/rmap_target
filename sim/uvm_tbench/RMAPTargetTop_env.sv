class RMAPTargetTop_env extends uvm_env;
     
    //---------------------------------------
    // agent and scoreboard instance
    //---------------------------------------
    fifo_tx_agt      tx_agt;
    fifo_tx_tmp_scb  tx_scb;
     
    `uvm_component_utils(RMAPTargetTop_env)
     
    //---------------------------------------
    // constructor
    //---------------------------------------
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
 
    //---------------------------------------
    // build_phase - crate the components
    //---------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
 
        tx_agt = fifo_tx_agt::type_id::create("tx_agt", this);
        tx_scb = fifo_tx_tmp_scb::type_id::create("tx_scb", this);
    endfunction : build_phase
     
    //---------------------------------------
    // connect_phase - connecting monitor and scoreboard port
    //---------------------------------------
    function void connect_phase(uvm_phase phase);
        tx_agt.mon.item_collected_port.connect(tx_scb.item_collected_export);
    endfunction : connect_phase
 
endclass : RMAPTargetTop_env