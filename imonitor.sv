/* ----------------------------------------------------------------------------
Author: Shashank Shivashankar
Date: 12/14/2020
---------------------------------------------------------------------------- */

`define ADDRWIDTH 8
`define DATAWIDTH 32

class apb_imon extends uvm_monitor;
  `uvm_component_utils(apb_imon);

  virtual apb_if.IMON_if vif; 
  uvm_analysis_port #(apb_pkt) imon_scbd; 

  int pkt_rxd; 
  apb_pkt pkt; 
  logic [`DATAWIDTH-1:0] temp_mem [*];
  logic [`DATAWIDTH-1:0] temp_data; 
  logic [`DATAWIDTH-1:0] temp_addr;
  logic temp_psel, temp_pwrite, temp_penable;

  function new(input string name, input uvm_component parent);
      super.new(name, parent);
  endfunction  

  virtual function void build_phase(input uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("IMON", "Start of build phase", UVM_MEDIUM);
      void'(uvm_config_db #(virtual apb_if.IMON_if)::get(null, "uvm_test_top.env.iagt", "drv_imon", vif));
      assert(vif != null)
      else `uvm_fatal(get_name(), "VIF in IMON is not set!");
      imon_scbd = new("imon_scbd", this);  
      `uvm_info("IMON", "End of build phase", UVM_MEDIUM);
  endfunction : build_phase

  task run_phase(input uvm_phase phase);
    pkt = apb_pkt::type_id::create("pkt");
    `uvm_info("IMON", "Start of run phase", UVM_MEDIUM);
    forever begin
        wait(top.rst)
        @(vif.CB_imon)
        begin
            temp_data = vif.CB_imon.pwdata;
            temp_addr = vif.CB_imon.paddr; 
            temp_psel = vif.CB_imon.psel;
            temp_penable = vif.CB_imon.penable; 
            temp_pwrite = vif.CB_imon.pwrite;

            if(temp_psel && temp_penable)
            begin
                if(temp_pwrite)
                begin
                    $display("@%0d Writing now", $time);
                    temp_mem[temp_paddr] = temp_data;
                end

                else
                begin
                    $display("@%0d Reading now", $time);
                    pkt.prdata <= temp_mem[vif.CB_imon.paddr]; 
                end
            end
            else
                $$display("@%0d IDLE", $time);
            `uvm_info("IMON: Run phase", $sformatf("Contents of associative array is: %p", temp_mem), UVM_MEDIUM);
            `uvm_info("IMON: Run phase", $sformatf("pkt num: %0d, address = %0d, data = %0d, write = %0d, sel = %0d, enable = %0d, read data = %0d", pkt_rxd, temp_addr, temp_data, temp_pwrite, temp_psel, temp_penable, pkt.prdata), UVM_MEDIUM);
            imon_scbd.write(pkt);
        end
    end
    `uvm_info("IMON", "End of run phase", UVM_MEDIUM);
  endtask : run_phase
endclass : apb_imon
