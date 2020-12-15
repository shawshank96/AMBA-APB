/* ----------------------------------------------------------------------------
Author: Shashank Shivashankar
Date: 12/12/2020
---------------------------------------------------------------------------- */

`include "input_agent.sv"
`include "output_agent.sv"
`include "scoreboard.sv"

class apb_env extends uvm_env;
  `uvm_component_utils(apb_env); 

  function new(input string name = "apb_env", input uvm_component parent);
    super.new(name, parent);  
  endfunction

  virtual function void build_phase(input uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV", "Start of build phase", UVM_MEDIUM);
    iagt = apb_iagt::type_id::create("iagt", this);
    oagt = apb_oagt::type_id::create("oagt", this);
    scbd = apb_scbd::type_id::create("scbd", this); 
    `uvm_info("ENV", "End of build phase", UVM_MEDIUM);
  endfunction : build_phase

  virtual function void connect_phase(input uvm_phase phase);
    `uvm_info("ENV", "Start of connect phase", UVM_MEDIUM);
    iagt.i_export.connect(scbd.imon_ap);
    oagt.o_export.connect(scbd.omon_ap);
    `uvm_info("ENV", "End of connect phase", UVM_MEDIUM);
  endfunction : connect_phase
endclass : apb_env
