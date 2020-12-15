/* ----------------------------------------------------------------------------
Author: Shashank Shivashankar
Date: 12/14/2020
---------------------------------------------------------------------------- */

`include "output_monitor.sv"

class apb_oagt extends uvm_agent;
  `uvm_component_utils(apb_oagt);
  apb_omon omon;
  uvm_analysis_port #(apb_pkt) o_export; 

  function new(input string name, input uvm_component parent);
      super.new(name, parent);
  endfunction

  virtual function void build_phase(input uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("O_AGT", "Start of build phase", UVM_MEDIUM);
      omon = apb_omon::type_id::create("omon", this);
      o_export = new("o_export", this);
      `uvm_info("OAGT", "End of build phase", UVM_MEDIUM);
  endfunction : build_phase

  virtual function void connect_phase(input uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("O_AGT", "Start of connect phase", UVM_MEDIUM);
    omon.omon_scbd.connect(this.o_export);
    `uvm_info("O_AGT", "End of connect phase", UVM_MEDIUM);
  endfunction : connect_phase
endclass : apb_oagt
