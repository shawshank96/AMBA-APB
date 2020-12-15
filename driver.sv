/* ----------------------------------------------------------------------------
Author: Shashank Shivashankar
Date: 12/15/2020
---------------------------------------------------------------------------- */

class apb_drv extends uvm_driver #(apb_pkt);
  `uvm_component_utils(apb_drv);

  virtual apb_if.DUT_if vif;
  int pkt_cnt; 

  function new(input string name, input uvm_component parent);
      super.new(name, parent);
  endfunction

  virtual function void build_phase(input uvm_phase phase);
     super.build_phase(phase);
     `uvm_info("DRV", "Start of build phase", UVM_MEDIUM);
     void'(uvm_config_db #(virtual apb_if.DUT_if)::get(null, "uvm_test_top.env.iagt", "drv_dut", vif));
     assert(vif != null)
     else   `uvm_fatal(get_name(), "VIF in driver is not set!");
     `uvm_info("DRV", "End of build phase", UVM_MEDIUM);
  endfunction : build_phase

  virtual task run_phase(input uvm_phase phase);
    forever begin
        wait(top.rst);
        pkt_cnt = pkt_cnt + 1;
        `uvm_info("DRV", "Before get_next_item", UVM_MEDIUM);
        seq_item_port.get_next_item(req);
        drv_dut(req);
        `uvm_info("DRV", "After get_next_item", UVM_MEDIUM);
        seq_item_port.item_done();
    end
  endtask : run_phase

  task drv_dut(input apb_pkt pkt);
    begin
        @(vif.CB_drv)
        `uvm_info("DRV:drive", "Driving packet started", UVM_MEDIUM);
        vif.CB_drv.paddr <= pkt.paddr;
        vif.CB_drv.pwdata <= pkt.pwdata;
        vif.CB_drv.psel <= pkt.psel; 
        vif.CB_drv.penable <= pkt.penable;
        vif.CB_drv.pwrite <= pkt.pwrite;
        `uvm_info("DRV:drive", $sformatf("@%0d pkt: address: %0d, data = %0d, select = %0d, enable = %0d, write = %0d", pkt_cnt, pkt.paddr, pkt.pwdata, pkt.psel, pkt.penable, pkt.pwrite), UVM_HIGH);
        `uvm_info("DRV:drive", "Drviing packet ended", UVM_MEDIUM);
    end
  endtask : drv_dut
endclass : apb_drv
