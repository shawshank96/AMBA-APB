/* ----------------------------------------------------------------------------
Author: Shashank Shivashankar
Date: 12/14/2020
---------------------------------------------------------------------------- */

class apb_seqr extends uvm_sequencer #(apb_pkt);
  `uvm_component_utils(apb_seqr);

  function new(input string name, input uvm_component parent);
    super.new(name, parent); 
  endfunction
  
endclass : apb_seqr
