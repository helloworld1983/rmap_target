class RMAPTargetTop_test_tmp extends uvm_test;
 
  `uvm_component_utils(RMAPTargetTop_test_tmp)
 
  RMAPTargetTop_env env;
  spw_pack_seq      seq;
 
  function new(string name = "RMAPTargetTop_test_tmp",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 
    env = RMAPTargetTop_env::type_id::create("env", this);
    seq = spw_pack_seq::type_id::create("seq");
  endfunction : build_phase
 
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.tx_agt.sqr);
    phase.drop_objection(this);
  endtask : run_phase
 
endclass : RMAPTargetTop_test_tmp