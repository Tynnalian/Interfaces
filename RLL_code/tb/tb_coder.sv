`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2023 18:36:02
// Design Name: 
// Module Name: tb_coder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////





module tb_coder();
    
//////////////////////////////
  
parameter max_bits_in=4;
   parameter polutakt=5;
	parameter max_bits_tabl=8;
	parameter [3:0] stateb=0,state1=1,state11=2,state10=3,state0=4,state01=5,state00=12,state011=6,state010=7,state001=8,state000=9, state0011=10,state0010=11;
	
  parameter PERIOD = 10;
    reg en;
	 reg inpt;
	 
   reg clk;
	 reg [5:0] stage;
	 reg [max_bits_in-1:0] SR_in;
	 reg [max_bits_tabl*2-1:0] SR_out;
    reg  code;
	 reg  voltage_level ;
	 reg [3:0] counter ;
	 reg  [2-1:0] Sr_in_MSB;
	 reg [3-1:0] Sr_out_MSB;

  always begin
  
    clk = 1'b0;
    #( PERIOD/2 ) clk = 1'b1;
    #( PERIOD/2 );
    
  end
//////////////////////////////
    



 Coder dut ( .clk(clk), .inpt(inpt), .code(code), .SR_in(SR_in) ,. stage(stage) ,. counter(counter) ,. Sr_in_MSB(Sr_in_MSB) ,.voltage_level(voltage_level) ,. SR_out( SR_out ) ,.en(en));

  initial begin
   stage=stateb;
   counter=3'b0;  
    inpt = 1'b1;
    code=1'b0;
   #10 inpt = 1'b0;
   #10 inpt = 1'b1;
   #10 inpt = 1'b1;    
   #10 inpt = 1'b0;
   #10 inpt = 1'b0;
   #10 inpt = 1'b1; 
   #10 inpt = 1'b0;
   #10 inpt = 1'b0;
   #10 inpt = 1'b0;   
   #10 inpt = 1'b0;   
   #10 inpt = 1'b1;      
   $finish;
    end
 
endmodule