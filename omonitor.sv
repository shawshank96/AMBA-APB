class apb_omon extends uvm_monitor;
  `uvm_component_utils(apb_omon);

  virtual apb_if.OMON_if vif;
  int pkt_rxd;
  apb_pkt pkt; 
  uvm_analysis_port #(apb_pkt) omon_scbd;

  function new(input string name, input uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(input uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("OMON", "Strat of build phase", UVM_MEDIUM);
      void'(uvm_config_db #(virtual apb_if.OMON_if)::get(null, "uvm_test_top.env.oagt", "dut_omon", vif));
      assert(vif != null)
      else `uvm_fatal(get_name(), "VIF in omon is not set!");
      omon_scbd = new("omon_scbd", this);
      `uvm_info("OMON", "End of build phase", UVM_MEDIUM);
  endfunction : build_phase

  task run_phase(input uvm_phase phase);
    `uvm_info("OMON", "Start of run phase", UVM_MEDIUM);
    pkt = apb_pkt::type_id::create("pkt", this);
    forever begin
        wait(top.rst)
        @(vif.CB_omon)
        begin
            pkt_rxd = pkt_rxd + 1;
            pkt.prdata = vif.CB_omon.prdata; 
            `uvm_info("OMON", $sformatf("omon rxd = %0d, output read data from dut = %0d", pkt_rxd, pkt.prdata), UVM_MEDIUM);
            omon_scbd.write(pkt);
        end
    end
    `uvm_info("OMON", "End of run phaes", UVM_MEDIUM);    
  endtask
endclass : apb_omon