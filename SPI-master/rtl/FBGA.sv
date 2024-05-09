`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2023 21:32:21
// Design Name: 
// Module Name: FPGA
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


// Общение ПЛИС и устройств по SPI
module FPGA #( parameter COUNT_BITS = 8, COUNT_SECONDARY = 3 )(

    //////////////////////////////////////
    
    input CLK,
    input Reset,
    
    //////////////////////////////////////
    
    input [1:0] Mode, // CPOL_CPHA
    
    input write_ready,
    input read_ready,
    
    input [COUNT_BITS - 1:0] data_to_send,
    input [1:0] secondary_num_i,
    input flag_inv_i,
    
    //////////////////////////////////////

    input MISO,
    output reg MOSI,
    output reg SCLK,
    output reg [ COUNT_SECONDARY - 1:0 ] CS,
    
    //////////////////////////////////////
    
    output reg ready_send,
    output reg ready_read,
    
    output reg [ COUNT_BITS - 1:0 ] recieved_data
    
);
    
    reg [1:0] state;
    reg [31:0] bit_count;
    reg [COUNT_BITS - 1:0] buffer;
    
    parameter IDLE = 2'b00;
    parameter MAIN_OUT = 2'b01;
    parameter MAIN_IN = 2'b10;
    
    //////////////////////////////////////
    
    initial begin
    
        state <= IDLE;
        ready_send <= 1'b1;   
        ready_read <= 1'b1;  
        bit_count <= 32'd0;
        
        CS <= 3'b110;
        SCLK <= 1'bZ; 
        MOSI <= 1'bZ;
        
        recieved_data <= 8'd0;
    
    end

    always @( posedge CLK or negedge CLK ) begin
    
        if ( Reset ) begin
        
            state <= IDLE;
            ready_send <= 1'b1;
            ready_read <= 1'b1;     
            bit_count <= 32'd0;
            
            CS <= 3'b110;
            SCLK <= 1'bZ; 
            MOSI <= 1'bZ;
            
            recieved_data <= 8'd0;
        
        end else
        
            case ( state )
            
                IDLE: begin
                
                    if ( write_ready ) begin
                    
                        state <= MAIN_OUT;
                        ready_send <= 1'b0;
                        
                    end else if ( read_ready ) begin
                    
                        state <= MAIN_IN;
                        ready_read <= 1'b0;
                    
                    end else begin
                    
                        state <= IDLE;
                        ready_send <= 1'b1; 
                        ready_read <= 1'b1;    
                        bit_count <= 32'd0;
                        
                        CS <= 3'b110;
                        SCLK <= 1'bZ; 
                        MOSI <= 1'bZ;   
                    
                    end

                end
                
                MAIN_OUT: begin
                
                    case ( Mode )
                    
                        2'b00: begin
                            
                            SCLK <= CLK;
                            
                            if ( CLK ) begin
                                
                                CS[ secondary_num_i ] <= 1'b1 ^ flag_inv_i;
                                
                                MOSI <= data_to_send[ COUNT_BITS - 1 - bit_count ];
                                bit_count <= bit_count + 32'd1;
                                
                                if ( bit_count >= COUNT_BITS - 1 )
                                
                                    ready_send <= 1'b1;
                                    
                                else
                                
                                    ready_send <= 1'b0;
                                    
                                if ( bit_count == COUNT_BITS ) begin
                                
                                    bit_count <= 32'd0;
                                    CS[ secondary_num_i ] <= 1'b0 ^ flag_inv_i;
                                    MOSI <= 1'bZ;
                                    
                                    if ( write_ready ) state <= MAIN_OUT;
                                    else if ( read_ready ) state <= MAIN_IN;
                                    else state <= IDLE;                   
                                    
                                end
                                
                            end
                        end
                        
                        2'b01: begin
                        
                            SCLK <= CLK;
                            
                            if ( !CLK ) begin
                                
                                CS[ secondary_num_i ] <= 1'b1 ^ flag_inv_i;
                                
                                MOSI <= data_to_send[ COUNT_BITS - 1 - bit_count ];
                                bit_count <= bit_count + 32'd1;
                                
                                if ( bit_count >= COUNT_BITS - 1 )
                                
                                    ready_send <= 1'b1;
                                    
                                else
                                
                                    ready_send <= 1'b0;
                                    
                                if ( bit_count == COUNT_BITS ) begin
                                
                                    bit_count <= 32'd0;
                                    
                                    CS[ secondary_num_i ] <= 1'b0 ^ flag_inv_i;
                                    MOSI <= 1'bZ;
            
                                    if ( write_ready ) state <= MAIN_OUT;
                                    else if ( read_ready ) state <= MAIN_IN;
                                    else state <= IDLE;
                                    
                                end
                            end
                        end
                        
                        2'b10: begin
                            
                            SCLK <= ~CLK;
                            
                            if ( CLK ) begin
                                
                                CS[ secondary_num_i ] <= 1'b1 ^ flag_inv_i;
                                
                                MOSI <= data_to_send[ COUNT_BITS - 1 - bit_count ];
                                bit_count <= bit_count + 32'd1;
                                
                                if ( bit_count >= COUNT_BITS - 1 )
                                
                                    ready_send <= 1'b1;
                                    
                                else
                                
                                    ready_send <= 1'b0;
                                    
                                if ( bit_count == COUNT_BITS ) begin
                                
                                    bit_count <= 32'd0;
                                    CS[ secondary_num_i ] <= 1'b0 ^ flag_inv_i;
                                    MOSI <= 1'bZ;

                                    if ( write_ready ) state <= MAIN_OUT;
                                    else if ( read_ready ) state <= MAIN_IN;
                                    else state <= IDLE;

                                end
                                
                            end
                        end
                        
                        2'b11: begin
                        
                            SCLK <= ~CLK;
                            
                            if ( !CLK ) begin
                                
                                CS[ secondary_num_i ] <= 1'b1 ^ flag_inv_i;
                                
                                MOSI <= data_to_send[ COUNT_BITS - 1 - bit_count ];
                                bit_count <= bit_count + 32'd1;
                                
                                if ( bit_count >= COUNT_BITS - 1 )
                                
                                    ready_send <= 1'b1;
                                    
                                else
                                
                                    ready_send <= 1'b0;
                                    
                                if ( bit_count == COUNT_BITS ) begin
                                
                                    bit_count <= 32'd0;
                                    CS[ secondary_num_i ] <= 1'b0 ^ flag_inv_i;
                                    MOSI <= 1'bZ;
                                    
                                    if ( write_ready ) state <= MAIN_OUT;
                                    else if ( read_ready ) state <= MAIN_IN;
                                    else state <= IDLE;
                                    
                                end
                            end
                        end
                    
                    endcase 
                
                end
                
                MAIN_IN: begin
                
                    case ( Mode )
                    
                        2'b00: begin
                            
                            SCLK <= CLK;
                            
                            if ( CLK ) begin
                                
                                CS[ secondary_num_i ] <= 1'b1 ^ flag_inv_i;
                                
                                buffer[ COUNT_BITS - 1 - bit_count ] <= MISO;
                                bit_count <= bit_count + 32'd1;
                                
                                if ( bit_count >= COUNT_BITS - 1 )
                                
                                    ready_read <= 1'b1;
                                    
                                else
                                
                                    ready_read <= 1'b0;
                                    
                                if ( bit_count == COUNT_BITS ) begin
                                
                                    bit_count <= 32'd0;
                                    CS[ secondary_num_i ] <= 1'b0 ^ flag_inv_i;
                                    
                                    recieved_data <= buffer;
                                    
                                    if ( write_ready ) state <= MAIN_OUT;
                                    else if ( read_ready ) state <= MAIN_IN;
                                    else state <= IDLE;
                                    
                                end
                                
                            end
                        end
                        
                        2'b01: begin
                        
                            SCLK <= CLK;
                            
                            if ( !CLK ) begin
                                
                                CS[ secondary_num_i ] <= 1'b1 ^ flag_inv_i;
                                
                                buffer[ COUNT_BITS - 1 - bit_count ] <= MISO;
                                bit_count <= bit_count + 32'd1;
                                
                                if ( bit_count >= COUNT_BITS - 1 )
                                
                                    ready_read <= 1'b1;
                                    
                                else
                                
                                    ready_read <= 1'b0;
                                    
                                if ( bit_count == COUNT_BITS ) begin
                                
                                    bit_count <= 32'd0;
                                    CS[ secondary_num_i ] <= 1'b0 ^ flag_inv_i;
                                    
                                    recieved_data <= buffer;
                                    
                                    if ( write_ready ) state <= MAIN_OUT;
                                    else if ( read_ready ) state <= MAIN_IN;
                                    else state <= IDLE;
                                    
                                end
                            end
                        end
                        
                        2'b10: begin
                            
                            SCLK <= ~CLK;
                            
                            if ( CLK ) begin
                                
                                CS[ secondary_num_i ] <= 1'b1 ^ flag_inv_i;
                                
                                buffer[ COUNT_BITS - 1 - bit_count ] <= MISO;
                                bit_count <= bit_count + 32'd1;
                                
                                if ( bit_count >= COUNT_BITS - 1 )
                                
                                    ready_read <= 1'b1;
                                    
                                else
                                
                                    ready_read <= 1'b0;
                                    
                                if ( bit_count == COUNT_BITS ) begin
                                
                                    bit_count <= 32'd0;
                                    CS[ secondary_num_i ] <= 1'b0 ^ flag_inv_i;
                                    
                                    recieved_data <= buffer;
                                    
                                    if ( write_ready ) state <= MAIN_OUT;
                                    else if ( read_ready ) state <= MAIN_IN;
                                    else state <= IDLE;
                                    
                                end
                                
                            end
                        end
                        
                        2'b11: begin
                        
                            SCLK <= ~CLK;
                            
                            if ( !CLK ) begin
                            
                                CS[ secondary_num_i ] <= 1'b1 ^ flag_inv_i;
                                
                                buffer[ COUNT_BITS - 1 - bit_count ] <= MISO;
                                bit_count <= bit_count + 32'd1;
                                
                                if ( bit_count >= COUNT_BITS - 1 )
                                
                                    ready_read <= 1'b1;
                                    
                                else
                                
                                    ready_read <= 1'b0;
                                    
                                if ( bit_count == COUNT_BITS ) begin
                                
                                    bit_count <= 32'd0;
                                    CS[ secondary_num_i ] <= 1'b0 ^ flag_inv_i;
                                    
                                    recieved_data <= buffer;
                                    
                                    if ( write_ready ) state <= MAIN_OUT;
                                    else if ( read_ready ) state <= MAIN_IN;
                                    else state <= IDLE;
                                    
                                end
                            end
                        end
                    
                    endcase
     
                end
                
                default: state <= IDLE;
                
            endcase
    
    end

endmodule
