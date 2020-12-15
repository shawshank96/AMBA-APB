/* ----------------------------------------------------------------------------
Author: Shashank Shivashankar
Date: 12/14/2020
---------------------------------------------------------------------------- */

`uvm_analysis_imp_decl(_from_omon);
`uvm_analysis_imp_decl(_from_imon);

`define DATAWIDTH 32

class apb_scbd extends uvm_scoreboard;
  `uvm_component_utils(apb_scbd);
  uvm_analysis_imp_from_omon #(apb_pkt, apb_scbd) omon_ap;
  uvm_analysis_imp_from_imon #(apb_pkt, apb_scbd) imon_ap;

  bit [`DATAWIDTH-1:0] imon_prdata;
  bit [`DATAWIDTH-1:0] omon_prdata;

  apb_pkt pkt1, pkt2;
  event compare_pkt;

  int match, mismatch;

  function new(input string name, input uvm_component parent);
      super.new(name, parent);
  endfunction

  virtual function void build_phase(input uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("SCBD", "Start of build phase", UVM_MEDIUM);
      imon_ap = new("imon_ap", this);
      omon_ap = new("omon_ap", this);
      `uvm_info("SCBD", "End of build phase", UVM_MEDIUM);
  endfunction : build_phase

  virtual function void write_from_imon(input apb_pkt pkt);
      `uvm_info("SCBD", $sformatf("imon read data = %0d", pkt.prdata), UVM_MEDIUM);
      imon_prdata = pkt.prdata; 
      pkt1 = pkt;
      -> compare_pkt;
  endfunction : write_from_imon

  virtual function void write_from_omon(input apb_pkt pkt);
      `uvm_info("SCBD", $sformatf("omon read data = %0d", pkt.prdata), UVM_MEDIUM);
      omon_prdata = pkt.prdata; 
      pkt2 = pkt;
  endfunction : write_from_omon

  task run_phase(input uvm_phase phase);
    forever begin
       @(compare_pkt);
       $display("pkt1 ##############");
       pkt1.print();
       $display("pkt2 @@@@@@@@@@@@@"); 
       pkt2.print();
       if(pkt1.compare(pkt2))
       begin
           match++;
           $display("@%0d pkt matched", $time);
       end
       else
       begin
           mismatch++;
           $display("@%0d pkt mismatch", $time);
       end
    end
  endtask : run_phase

  virtual function void report_phase(input uvm_phase phase);
      `uvm_info("SCBD: report phase", $sformatf("no. of matches = %0d", match), UVM_MEDIUM);
      `uvm_info("SCBD: report phase", $sformatf("no. of mismatches = %0d", mismatch), UVM_MEDIUM);

      if(mismatch == 0)
      begin
        display("***********************************************");
		$display("***********************************************");
		$display("*****************SUCCESS***********************");
		$display("***********************************************");
		$display("***********************************************");
      end
      else
      begin
        display("***********************************************");
		$display("***********************************************");
		$display("*****************FAILURE***********************");
		$display("***********************************************");
		$display("***********************************************");
      end
  endfunction : report_phase
endclass : apb_scbd
