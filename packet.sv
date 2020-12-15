/* ----------------------------------------------------------------------------
Author: Shashank Shivashankar
Date: 12/12/2020
---------------------------------------------------------------------------- */

`define ADDRWIDTH 8
`define DATAWIDTH 32

class apb_pkt extends uvm_sequence_item;
  rand logic [`ADDRWIDTH-1:0] paddr; 
  rand logic [`DATAWIDTH-1:0] pwdata;
  rand logic                  pwrite; 
  rand logic                  psel; 
  rand logic                  penable; 
  
  logic                       pready;
  logic [`DATAWIDTH-1:0]      prdata; 

  `uvm_object_utils_begin(apb_pkt)
    `uvm_field_int(paddr, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(pwdata, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(pwrite, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(psel, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(penable, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(pready, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(prdata, UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end

  constraint c1 {paddr < 16;};
  constraint c2 {pwdata > 0; pwdata < 150;};

  function new(input string name = "apb_pkt");
      super.new(name);
  endfunction
endclass : apb_pkt
