
`timescale 1ns / 1ps

module Coder( inpt, stage,  SR_in, Sr_in_MSB, SR_out,
Sr_out_MSB, code,clk,en, voltage_level, counter , poluclk
);
	parameter max_bits_in=4;
   parameter polutakt=5;
	parameter max_bits_tabl=8;

	input logic poluclk;


    output logic en;
	input logic inpt;
    input clk;
	output enum logic [5:0] { stateb,state1,state11,state10,
	state0,state01,state00,state011,state010,
	state001,state000, state0011,state0010} stage;
	output logic [max_bits_in-1:0] SR_in;
	output logic [max_bits_tabl*2-1:0] SR_out;
    output logic  code;
	output logic  voltage_level ;
	output logic [3:0] counter ;
	output logic  [2-1:0] Sr_in_MSB;
	output logic [3-1:0] Sr_out_MSB;




	always @(posedge clk) begin

		SR_in <= { SR_in[2:0], inpt };

		if (counter != 3'b100)

		counter <= counter+1'b1;

		else begin counter <= counter; end

		case (stage)

		stateb   : begin Sr_in_MSB <= Sr_in_MSB;  if (inpt)  stage <= state1;  else  stage <=		state0; 				 		  end //1;0

		state1   : begin Sr_in_MSB <= 2'd2; if (inpt) stage <= 	state11	; 	else stage <=	state10;        	      end //11 ; 10

		state11  : begin  Sr_in_MSB <= Sr_in_MSB; if (inpt)  stage <= state1	;	else	stage <= state0;  				  end

		state10  : begin Sr_in_MSB <= Sr_in_MSB; if (inpt)  stage <=	state1	;	else stage <= state0;   				  end

		state0   : begin Sr_in_MSB <= Sr_in_MSB; if (inpt)  stage <= 	state01	;	else	stage <= state00;   				  end //01 ; 00

		state01  : begin Sr_in_MSB <= 2'd1; if (inpt) stage <=	state011 ;	else stage <= state010; 	 	 	  end //011 ; 010

		state011 : begin  Sr_in_MSB <= Sr_in_MSB; if (inpt) stage <= 	state1	;	else	stage <= state0;  			  end

		state010  : begin Sr_in_MSB <= Sr_in_MSB; if (inpt) stage <= 	state1	;	else	stage <= state0;  				  end

		state00   : begin if (inpt) begin Sr_in_MSB <= Sr_in_MSB ;	stage <= state001;  end 	 else begin  stage <= state000;  		Sr_in_MSB <= 1'b1 ; end  end //001 ; 000

		state000  : begin  Sr_in_MSB <= Sr_in_MSB; if (inpt) stage <= 	state1	;	 else stage <=	state0; 				  end

		state001  : begin Sr_in_MSB <= 2'd0; if  (inpt) stage <=	state0011 ; else stage <=	state0010;   	 		  end //0011 ; 0010

		state0011 : begin Sr_in_MSB <= Sr_in_MSB; if (inpt)  stage <=	state1	;	else stage <= state0; 				  end

		state0010 : begin Sr_in_MSB <= Sr_in_MSB; if (inpt)  stage <=	state1	;	else stage <=	state0; 				  end

		default : begin stage <= stateb ; 						en <= 1'b0;				#10						Sr_in_MSB<=Sr_in_MSB; end

		endcase
		end





		always @(posedge clk) begin
		if (counter==3'b100 & en ) begin

		 case (Sr_in_MSB )

		2'd2 : //if (counter2==2'd1)
		    begin



		      case (SR_in [3:2])

		      2'b11 :  begin  SR_out <= {SR_out[13:0],SR_in[3:2]}; en <= 1'b0; code <= ~voltage_level;  	#3 voltage_level <= code; #11 en <= 1'b1;  end

		      2'b10 : begin   SR_out <= {SR_out[13:0],SR_in[3:2]}; en <= 1'b0; code <= voltage_level;  	#5 code <= ~voltage_level;   #3    voltage_level <= code; #5 en <= 1'b1; end

		      endcase
		    end

		2'd1 : //if (counter3==2'd2)
		 begin

	     case (SR_in [3:1])
			3'b011: begin SR_out <= {SR_out[12:0],SR_in[3:1]}; en <= 1'b0; code <= voltage_level; 	#10    code <= ~voltage_level; #3 voltage_level <= code; #15 en <= 1'b1; end

			3'b010: begin SR_out <= {SR_out[12:0],SR_in[3:1]}; en <= 1'b0; code <= ~voltage_level; #3 voltage_level <= code;	#12  code <= ~voltage_level;  #3 voltage_level <= code; #7 en <= 1'b1; end

			3'b000 : begin SR_out <= {SR_out[12:0],SR_in[3:1]}; en <= 1'b0; code <= voltage_level; 	#15 code <= ~voltage_level;  #3 voltage_level <= code; #7 en <= 1'b1; end

			endcase
		end


		2'd0 ://if (counter4==3'd3)
		begin

		case (SR_in)

		  4'b0010: begin SR_out <= {SR_out[11:0],SR_in[3:0]}; code <= voltage_level; en <= 1'b0;	#10  code <= ~voltage_level; #3  voltage_level <= code;  #12 code <= ~voltage_level;#3 voltage_level <= code; #7 en <= 1'b1;  end

		  4'b0011: begin  SR_out <= {SR_out[11:0],SR_in[3:0]}; code <= voltage_level;  en <= 1'b0;	#20 code <= ~voltage_level; #3  voltage_level <= code; #12 en <= 1'b1; end

		default : begin SR_out <= SR_out;   end

		endcase
		end
		endcase
		end

		end






endmodule





