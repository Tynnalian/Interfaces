`timescale 1ns / 1ps

module Coder( inpt, stage,  SR_in, Sr_in_MSB, SR_out, Sr_out_MSB, code,clk,en, voltage_level, counter , poluclk, counter2, counter3, counter4);
	parameter max_bits_in=4;
   parameter polutakt=5;
	parameter max_bits_tabl=8;
	parameter [3:0] stateb=0,state1=1,state11=2,state10=3,state0=4,state01=5,state00=12,state011=6,state010=7,state001=8,state000=9, state0011=10,state0010=11;
	input wire poluclk;
	output reg [1:0] counter2;
	output reg [1:0] counter3;
	output reg [2:0] counter4;
	
    output reg en;
	input wire inpt;
   input clk;
	output reg [5:0] stage;
	output reg [max_bits_in-1:0] SR_in;
	output reg [max_bits_tabl*2-1:0] SR_out;
   output reg  code;
	output reg  voltage_level ;
	 output reg [3:0] counter ;
	output reg  [2-1:0] Sr_in_MSB;
	output reg [3-1:0] Sr_out_MSB;
	
	initial begin
	voltage_level=1'b0;
	end
	
	
	always @(posedge clk) begin 
		
		SR_in = { SR_in[2:0], inpt };
		
		if (counter != 3'b100)
		
		counter = counter+1'b1;
		
		else begin counter = counter; end
		
		case (stage) 
		 
		stateb : begin stage =inpt ? 	state1 	:		state0; 				 Sr_in_MSB=Sr_in_MSB; 		  end //1;0
		
		state1 : begin stage= inpt ? 	state11	:		state10;        	Sr_in_MSB=2'd2;      end //11 ; 10
		
		state11 :begin stage =inpt ? 	state1	:		state0;  				Sr_in_MSB=Sr_in_MSB;   end
		
		state10 :begin stage =inpt ? 	state1	:		state0;   				Sr_in_MSB=Sr_in_MSB;  end
		
		state0 : begin stage= inpt ? 	state01	:		state00;   				Sr_in_MSB=Sr_in_MSB;  end //01 ; 00
		
		state01 : begin stage= inpt ?	state011	:		state010; 	 	 	Sr_in_MSB=2'd1;  end //011 ; 010
		
		state011: begin stage =inpt ? 	state1	:		state0;  			Sr_in_MSB=Sr_in_MSB;  end
		
		state010: begin stage =inpt ? 	state1	:		state0;  				Sr_in_MSB=Sr_in_MSB;  end
		
		state00 : begin stage = inpt	?	state001	:		state000;  		 	Sr_in_MSB= inpt ? Sr_in_MSB : 1'b1 ;  end //001 ; 000
		
		state000: begin stage =inpt ? 	state1	:		state0; 				Sr_in_MSB=Sr_in_MSB;  end
		
		state001 : begin stage = inpt ?	state0011:		state0010;   	 		Sr_in_MSB=2'd0;  end //0011 ; 0010
		
		state0011: begin stage =inpt ? 	state1	:		state0; 				Sr_in_MSB=Sr_in_MSB;  end
		
		state0010: begin stage =inpt ? 	state1	:		state0; 				Sr_in_MSB=Sr_in_MSB;  end
		
		default : begin stage=stateb ; 						en =1'b0;				#10						Sr_in_MSB=Sr_in_MSB; end
		
		endcase
		end
		
		
		
	
		
		 
		
		
		
		
		
		always @(posedge clk) begin
		if (counter==3'b100 &en ) begin
		
		 case (Sr_in_MSB )
		
		2'd2 : //if (counter2==2'd1) 
		    begin 
		
		
		
		      case (SR_in [3:2])
		
		      2'b11 :  begin  SR_out = {SR_out[13:0],SR_in[3:2]}; en=1'b0; code = ~voltage_level;  	#3 voltage_level = code; #11en=1'b1;  end 
		
		      2'b10 : begin   SR_out = {SR_out[13:0],SR_in[3:2]}; en=1'b0; code = voltage_level;  	#5 code = ~voltage_level;   #3    voltage_level = code; #5 en=1'b1; end
		
		      endcase
		    end
		
		2'd1 : //if (counter3==2'd2) 
		 begin  
		
	     case (SR_in [3:1])
			3'b011: begin SR_out = {SR_out[12:0],SR_in[3:1]}; en=1'b0; code = voltage_level; 	#10    code = ~voltage_level; #3 voltage_level = code; #15 en=1'b1; end
		 
			3'b010: begin SR_out = {SR_out[12:0],SR_in[3:1]}; en=1'b0; code = ~voltage_level; #3 voltage_level = code;	#12  code = ~voltage_level;  #3 voltage_level = code; #7 en=1'b1; end
		 
			3'b000 : begin SR_out = {SR_out[12:0],SR_in[3:1]}; en=1'b0; code = voltage_level; 	#15 code = ~voltage_level;  #3 voltage_level = code; #7 en=1'b1; end
		
			endcase
		end	
		
		
		2'd0 ://if (counter4==3'd3)  
		begin  
		
		case (SR_in)
		
		  4'b0010: begin SR_out = {SR_out[11:0],SR_in[3:0]}; code = voltage_level; en=1'b0;	#10  code = ~voltage_level; #3  voltage_level = code;  #12 code = ~voltage_level;#3 voltage_level = code; #7 en=1'b1;  end
		  
		  4'b0011: begin  SR_out = {SR_out[11:0],SR_in[3:0]}; code = voltage_level;  en=1'b0;	#20 code = ~voltage_level; #3  voltage_level = code; #12 en=1'b1; end
		
		default : begin SR_out=SR_out;   end
		 
		endcase
		end
		endcase
		end
		
		end
		//always @(posedge en) begin
	 // case(SR_in)
		// 4'bXX11: begin code = ~voltage_level; 	#15 voltage_level = code; end
		 
		// 4'bXX10: begin code = voltage_level;  	#5 code = ~voltage_level; #10 voltage_level = code; end
		 
		// 4'bX011: begin code = voltage_level; 	#10 code = ~voltage_level; # 15 voltage_level = code; end
		 
		// 4'bX010: begin code = ~voltage_level; 	#10 code = ~voltage_level; #10 voltage_level = code; end
		 
		// 4'bX000 : begin code = voltage_level; 	#15 code = ~voltage_level; #10 voltage_level = code; end
		 
		// 4'b0011: begin code = voltage_level; 	#10 code = ~voltage_level; #10 code=~voltage_level; 		#10 voltage_level = code; end
		 
		// 4'b0010: begin code = voltage_level; 	#20 code = ~voltage_level; #30 voltage_level = code; end
		
		//default : begin code = voltage_level ; 		voltage_level=code; end
		
		//endcase
 
		 
		 
		
		

endmodule 
		//always @(posedge en) begin
	 // case(SR_in)
		// 4'bXX11: begin code <= ~voltage_level; 	#15 voltage_level <= code; end
		 
		// 4'bXX10: begin code <= voltage_level;  	#5 code <= ~voltage_level; #10 voltage_level <= code; end
		 
		// 4'bX011: begin code <= voltage_level; 	#10 code <= ~voltage_level; # 15 voltage_level <= code; end
		 
		// 4'bX010: begin code <= ~voltage_level; 	#10 code <= ~voltage_level; #10 voltage_level <= code; end
		 
		// 4'bX000 : begin code <= voltage_level; 	#15 code <= ~voltage_level; #10 voltage_level <= code; end
		 
		// 4'b0011: begin code <= voltage_level; 	#10 code <= ~voltage_level; #10 code<=~voltage_level; 		#10 voltage_level <= code; end
		 
		// 4'b0010: begin code <= voltage_level; 	#20 code <= ~voltage_level; #30 voltage_level <= code; end
		
		//default : begin code <= voltage_level ; 		voltage_level<=code; end
		
		//endcase
 
		 
		 
		
		

