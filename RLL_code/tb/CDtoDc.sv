`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.12.2023 12:25:24
// Design Name: 
// Module Name: CDtoDC
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


module CDtoDc();
    
//////////////////////////////
  
    parameter max_bits_in=4;
    parameter polutakt=5;
	parameter max_bits_tabl=8;	
    parameter PERIOD = 10;
     logic en;
	 logic inpt;
	 logic  poluclk ;
     logic clk;
	 logic [5:0] stagetb;
	 logic [5:0] stage1;
	 logic [max_bits_in-1:0] SR_in;
	 logic [max_bits_tabl*2-1:0] SR_out;
	 logic [max_bits_tabl*2-1:0] SR_outd;
     logic  code;
     
     logic [4:0] counter8;
	 logic  voltage_leveltb ;
	 logic [3:0] counter ;
	 logic [3:0] counter1;
	 logic  [2-1:0] Sr_in_MSB;
	 

  always begin
  
   
     #( PERIOD/2 ) clk = ~clk;
     
    
   
end

 always begin
   @(posedge clk) poluclk=1;  #(PERIOD/4) poluclk=0;
   @(negedge clk) poluclk=1;  #(PERIOD/4) poluclk=0;
   
  // @(posedge clk);   poluclk = 1; #(PERIOD/4) poluclk=0; 
  // #(PERIOD/4);  poluclk = 1; #(PERIOD/4) poluclk=0;
 

     
    
   
end
 

     
  Coder Coder  ( 
  .clk(clk), .inpt(inpt), .code(code), .SR_in(SR_in) ,
  . stage(stagetb) ,. counter(counter) ,. Sr_in_MSB(Sr_in_MSB) ,
  .voltage_level(voltage_leveltb) ,. SR_out( SR_out ) ,.en(en)  
  );
  
  
  DC DC  (.poluclk(poluclk), .clk(clk) , .code(code)  ,
    .voltage_level(voltage_leveltb),  .SR_out (SR_outd),. stage1(stage1)
     ,. counter(counter1), .counter8 (counter8)) ;
  
  initial begin
   clk=0;
   poluclk=0;
   
   stagetb=0;
   stage1=0;
   voltage_leveltb=0;
   counter=3'b0; 
   counter8=4'b0;
   counter1=3'b0; 
   en=1'b1;
   code=1'b0;
   inpt = 1'b1;
   #1 inpt = 1'b1;
   #7 inpt = 1'b0;    
   #PERIOD inpt = 1'b1;
   #PERIOD inpt = 1'b1;
   #PERIOD inpt = 1'b0; 
   #PERIOD inpt = 1'b1;
   #PERIOD inpt = 1'b0;
   #PERIOD inpt = 1'b0;   
   #PERIOD inpt = 1'b0;   
   #PERIOD inpt = 1'b1;
   #PERIOD inpt = 1'b1;
   #PERIOD inpt = 1'b0;   
   #PERIOD inpt = 1'b0;
   #PERIOD inpt = 1'b0;
   #PERIOD inpt = 1'bz;
   #PERIOD inpt = 1'bz;
   #PERIOD inpt = 1'bz;
   #PERIOD inpt = 1'bZ;
   #PERIOD inpt = 1'bZ;
   #PERIOD 
   #PERIOD inpt = 1'bZ;
                    
         
         
   $finish;
    end 
    
    
   
  endmodule
