`include "packet.sv"

class apb_seq extends uvm_sequence;
  `uvm_object_utils(apb_seq);
  apb_pkt pkt; 

  function new(input string name = "apb_pkt");
    super.new(name);
    set_automatic_phase_objection(1);
  endfunction

  virtual task body;
    void'(uvm_config_db #(int)::get(null, "", "pkt_cnt", pkt_cnt));
    assert(pkt_cnt != 0)
    else `uvm_fatal(get_name(), "Sequence - Packet count not set!");
    pkt = apb_pkt::type_id::create("pkt");
    
    repeat(pkt_cnt)
    begin
      start_item(pkt); 
      pkt.randomize(); 
      finish_item(pkt);    
    end
  endtask : body
endclass : apb_seq