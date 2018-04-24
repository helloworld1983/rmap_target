class fifo_tx_sqr extends uvm_sequencer#(fifo_seq_item);

    `uvm_component_utils(fifo_tx_sqr)

    //constructor
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction
    
endclass