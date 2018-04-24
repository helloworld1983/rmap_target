class spw_pack_seq extends uvm_sequence#(fifo_seq_item);

    rand int unsigned data_num; 
    rand bit          err_end ;  // 0 for EOP, 1 for EEP

    constraint data_num_c { data_num <= 2096; }

    function new(string name = "");
        super.new(name);
    endfunction: new

    task body();
        fifo_seq_item trans;

        // data chars
        if(data_num > 0) repeat(data_num) begin
            trans = fifo_seq_item::type_id::create(.name("trans"), .contxt(get_full_name()));
            start_item(trans);
            assert(trans.randomize() with { trans.eop == 0; });
            finish_item(trans);
        end

        // end of packet
        trans = fifo_seq_item::type_id::create(.name("trans"), .contxt(get_full_name()));
        start_item(trans);
        assert(trans.randomize() with { trans.eop == 1; trans.data[0] == err_end; });
        finish_item(trans);

    endtask: body

    `uvm_object_utils_begin(spw_pack_seq)
        `uvm_field_int(data_num, UVM_ALL_ON)
    `uvm_object_utils_end
endclass: spw_pack_seq