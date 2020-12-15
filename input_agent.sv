/* ----------------------------------------------------------------------------
Author: Shashank Shivashankar
Date: 12/12/2020
---------------------------------------------------------------------------- */

`include "sequencer.sv"
`include "driver.sv"
`include "imonitor.sv"

class apb_iagt extends uvm_agent;
  `uvm_component_utils(apb_iagt);

  apb_seqr seqr;
  apb_drv drv;
  apb_imon imon; 
  uvm_analysis_port #(apb_pkt) i_export; 

  function new(input string name, input uvm_component parent);
    super.new(name, parent); 
  endfunction

  virtual function void build_phase(input uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("IAGT", "Start of build phase", UVM_MEDIUM);
    seqr = apb_seqr::type_id::create("seqr", this);
    drv = apb_drv::type_id::create("drv", this);
    imon = apb_imon::type_id::create("imon", this);
    `uvm_info("IAGT", "End of build phase", UVM_MEDIUM);
  endfunction : build_phase

  virtual function void connect_phase(input uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info("IAGT", "Start of connect phase", UVM_MEDIUM);
      drv.seq_item_port.connect(seqr.seq_item_export);
      imon.imon_scbd.connect(this.i_export);
      `uvm_info("IAGT", "End of connect phase", UVM_MEDIUM);
  endfunction : connect_phase
endclass : apb_iagt 
