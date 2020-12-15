`define ADDRWIDTH 8
`define DATAWIDTH 32

interface apb_if(input bit clk, rst); 
  logic [`ADDRWIDTH-1:0] paddr;
  logic [`DATAWIDTH-1:0] pwdata, prdata; 
  logic psel, penable, pwrite; 
  logic pready;

  clocking CB_drv @ (posedge clk);
    output paddr;
    output pwdata;
    output psel; 
    output penable;
    output pwrite;
  endclocking 

  clocking CB_imon @ (posedge clk);
    input paddr;
    input pwdata; 
    input psel; 
    input penable; 
    input pwrite;
  endclocking

  clocking CB_omon @ (posedge clk);
    input prdata;
    input pready; 
  endclocking

  modport DUT_if(clocking CB_drv);
  modport IMON_if(clocking CB_imon);
  modport OMON_if(clocking CB_omon);
endinterface