

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.12.2023 01:44:25
// Design Name: 
// Module Name: DC
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


module DC #( 

    parameter [1:0] s11=2'b11, s10=2'b10,
    parameter [2:0] s000=3'b000, s011=3'b011, s010=3'b010,
    parameter [3:0] s0010=4'b0010, s0011=4'b0011,
    parameter polutakt=5,
	parameter max_bits_tabl=8
	
	)
	
	(
	 input     clk,
     input      code,
     input      voltage_level,
     input      poluclk,
     output logic [3:0] counter,
      output logic [4:0] counter8,
     
     output enum logic [0:5] { stateidle, stateN,stateR,stateNN,stateNRNN,stateNNNRNN,
     stateNNNNRNN,stateRN,stateRNN,stateRNNN,stateRNNRNN, stateNR,stateNNN,
	stateNNNR , stateNNNN, stateNNR , stateNNRNNR, stateNNRNN, stateNNRNNN ,
	 stateNRN, stateNNNNR, stateNNNNRN, stateNNNNRNNN, stateNNRN, stateRNNR, 
	 stateRNNRN, stateNNNRN, stateNNRNNRN, stateNNRNNRNN} stage1,
	 output logic [15:0] SR_out
	);
	
 
   
always_ff @(posedge poluclk) begin 
		
		
		
    if (counter8 != 4'b1000)
		
		counter8 <= counter8+1'b1;
		
	 else  counter8 <= counter8; 
		end
		
		
		always_ff @(posedge clk) begin 
		
		
		
    if ((counter != 3'b100)  )
		
		counter <= counter+1'b1;
		
	 else  counter <= counter; 
		end

	

always @(posedge poluclk   ) begin
	if ((counter==4'b0100) & (counter8 == 4'b1000))
	begin
	#1
	 case (stage1)
	stateidle :  if( (code&voltage_level)|(~code&(~(voltage_level))))   stage1<=stateN ; else stage1 <= stateR; 
	
	stateN : if( code==voltage_level) stage1<=stateNN;   else stage1 <= stateNR; 
	
	stateR : if( (code&voltage_level)|(~code&(~(voltage_level))))   stage1<=stateRN ;  else stage1 <= stateR; 
	
	stateNN    :  if( code==voltage_level)  stage1<= stateNNN ; else stage1 <= stateNNR; 
	
	stateNR    : if( code==voltage_level)  stage1<=stateNRN ; else stage1 <= stateR; 
	
	stateNNN   :   if( code==voltage_level)  stage1<=stateNNNN ; else stage1 <= stateNNNR; 
	
	stateNNNN   :  if( code==voltage_level)  stage1<=stateN ; else stage1 <= stateNNNNR; 
	
	stateNNNNR   :  if( code==voltage_level)  stage1<=stateNNNNRN ; else stage1 <= stateR; 

	stateNNNNRN   : if( code==voltage_level)  stage1<=stateNNNNRNN ; else stage1 <= stateR; 
	
	
	
	stateNNNNRNN   :  if( code==voltage_level) begin stage1<=stateNNNNRNNN ;  SR_out<={SR_out [11:0], s0011} ;end  else stage1 <= stateR;   //0011
	
   stateNNNNRNNN   :   if( code==voltage_level)  stage1<=stateN ; else stage1 <= stateR; //0011
	
	stateNNR  :  if( code==voltage_level)  stage1<=stateNNRN ; else stage1 <= stateR; 
	
	stateNNRN   :  if( code==voltage_level)  stage1<=stateNNRNN ;  else stage1 <= stateR;  
	
	stateNNRNN   :  if( code==voltage_level)  begin stage1<=stateNNRNNN ;  SR_out<={SR_out [12:0], s011} ; end else stage1 = stateNNRNNR; //011
	
	stateNNRNNN    :  if( code==voltage_level)  stage1<=stateN ; else stage1 <= stateR; //011
	
	stateNRN    :  if( code==voltage_level) begin  stage1<=stateNRNN ;  SR_out<={SR_out [13:0], s10} ; end else stage1 <= stateR;  //10
	
	stateNRNN  : #1 if( code==voltage_level)  stage1<=stateN ;   else stage1 <= stateR;   //10
	  
    stateRN  :  if( code==voltage_level)  stage1<=stateRNN ; else stage1 <= stateR;  
    
    stateRNN  :  if( code==voltage_level) begin  stage1<=stateRNNN ; SR_out<={SR_out [13:0], s11} ; end  else stage1 <= stateRNNR;   //11
    
    stateRNNN  :  #1 if  ( code==voltage_level)   stage1<=stateN ; else stage1 <= stateR;  //11
    
    stateRNNR  :  if( code==voltage_level)  stage1<=stateRNNRN ; else stage1 <= stateR;   
    
    stateRNNRN  :  if( code==voltage_level)  begin stage1<=stateRNNRNN ;  SR_out<={SR_out [12:0], s010} ; end  else stage1 <= stateR;   //010
    
    stateRNNRNN    :  if( code==voltage_level)  stage1<=stateN ; else stage1 <= stateR;  //010
    
    stateNNNR   :  if( code==voltage_level)  stage1<=stateNNNRN ; else stage1 <= stateR; 
    
    stateNNNRN   :  if( code==voltage_level) begin stage1<=stateNNNRNN;  SR_out<={SR_out [12:0], s000} ;end  else stage1 <= stateR;  //000
    
    stateNNNRNN   :   if( code==voltage_level)  stage1<=stateN ; else stage1 <= stateR; //000
    
    stateNNRNNR   :  if( code==voltage_level)  stage1<=stateNNRNNRN ; else stage1 <= stateR;  
    
    stateNNRNNRN   :  if( code==voltage_level) begin stage1<=stateNNRNNRNN ;  SR_out<={SR_out [11:0], s0010} ; end  else stage1 <= stateR;   //0010
    
    stateNNRNNRNN  :  if( code==voltage_level)  stage1<=stateN ; else stage1 <= stateR;  //0010
	
	
	default: stage1 <= stateidle;
    
	
	
	
	
	endcase
	end
	end
	
	
	
endmodule
