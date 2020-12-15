`define packet_count 5

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "sequence.sv"
`include "env.sv"

class apb_test extends uvm_test;
  `uvm_component_utils(apb_test);

  apb_env env; 
  int pkt_cnt = `packet_count; 

  function new(input string name, input uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(input uvm_phae phase);
    super.build_phase(phase); 
    env = apb_env::type_id::create("env", this);
    `uvm_info("TEST", "Start of build phase", UVM_MEDIUM);
    uvm_config_db #(virtual apb_if.DUT_if)::set(this, "env.iagt", "drv_dut", top.a_if.DUT_if);
    uvm_config_db #(virtual apb_if.IMON_if)::set(this, "env.iagt", "drv_imon", top.a_if.IMON_if);
    uvm_config_db #(virtual apb_if.OMON_if)::set(this, "env.oagt", "drv_omon", top.a_if.OMON_if); 
    uvm_config_db #(int)::set(null, "", "pkt_cnt", pkt_cnt); 
    `uvm_info("TEST", "End of build phase", UVM_MEDIUM);
  endfunction : build_phase

  virtual function void end_of_elaboration_phase(input uvm_phase phase);
    `uvm_info("TEST", "Start of elab phase", UVM_MEDIUM);
    uvm_root::get().print_topology(); 
    `uvm_info("TEST", "End pf elab phase", UVM_MEDIUM); 
  endfunction : end_of_elaboration_phase

  virtual task run_phase(input uvm_phase phase);
    apb_seq seq = apb_seq::type_id::create("seq");
    `uvm_info("TEST", "Start of run phase", UVM_MEDIUM);
    phase.raise_objection(this);
    seq.start(env.iagt.sqr); 
    phase.phase_done.set_drain_time(this, 20ns); 
    phase.drop_objection(this);
    `uvm_info("TEST", "End of run phase", UVM_MEDIUM);
  endtask : run_phase
endclass : apb_test