class fifo_seq_item extends uvm_sequence_item;
    
    rand bit          eop;
    rand bit [7:0]    data;
    rand int unsigned delay;
     
    `uvm_object_utils_begin(fifo_seq_item)
        `uvm_field_int(data,UVM_ALL_ON)
        `uvm_field_int(eop ,UVM_ALL_ON)
    `uvm_object_utils_end
     
    function new(string name = "fifo_seq_item");
        super.new(name);
    endfunction
     
    // if it's the end of packet, data could be only x00 or x01
    constraint eop_c { 
        if(eop) {
            data[7:1] == 0;
        } 
    };

    constraint delay_c { 
            delay < 10;
    };
     
endclass