`include "test.sv"

module top();
  bit clk, rst; 

  initial begin
      clk = 1'b0;
      forever #5 clk = ~clk;
  end

  initial begin
      repeat(3) @(posedge clk) rst = 1'b0;
      @(negedge clk)           rst = 1'b1;
  end

  initial begin
      run_test("apb_test"); 
  end

  apb_if a_if(clk, rst);
  apb DUT(.clk(clk), .rst(rst), .paddr(a_if.paddr), .psel(a_if.psel), .penable(a_if.penable), .pwrite(a_if.pwrite), .pwdata(a_if.pwdata), .prdata(a_if.prdata), .pready(a_if.pready)); 
endmodule