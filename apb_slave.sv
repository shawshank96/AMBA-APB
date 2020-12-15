`timescale 1ns/1ps

module apb
#(
    ADDRWIDTH 8
    DATAWIDTH 32
)
(
    input                        clk,
    input                        rst,
    input [ADDRWIDTH-1:0]        paddr,
    input                        pwrite,
    input                        psel, 
    input                        penable, 
    input logic [DATAWIDTH-1:0]  pwdata,
    output logic [DATAWIDTH-1:0] prdata,
    output logic                 pready
);

logic [DATAWIDTH-1:0] mem [256];
logic [1:0] apb_st; 
parameter IDLE = 0;
parameter SETUP = 1;
parameter ACCESS = 2;

always@(posedge clk or negedge rst)
begin
    if(!rst)    apb_st <= IDLE;
    else
    begin
        case(apb_st)
            IDLE: begin
                if(psel)    apb_st <= SETUP;
            end

            SETUP: begin
                if(psel)
                begin
                    if(penable)     apb_st <= ACCESS; 
                end
                else                apb_st <= IDLE; 
            end

            ACCESS: begin
                if(psel)
                begin
                    if(penable)
                    begin
                        if(pwrite)      begin mem[paddr] <= pwdata;     pready <= 1; end
                        else            begin prdata     <= mem[paddr]; pready <= 1; end
                    end
                    else           apb_st <= SETUP;
                end
                else               apb_st <= IDLE; 
            end
        endcase
    end
end
endmodule