`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2023 21:34:08
// Design Name: 
// Module Name: FBGA_tb
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


`timescale 1ns / 1ps

module FPGA_tb();

  reg CLK_tb; 
  parameter PERIOD = 10;  

  always 
    begin

      CLK_tb = 1'b0;
      #( PERIOD / 2 ) CLK_tb = 1'b1;
      #( PERIOD / 2 );

    end

  reg Reset_tb;
  reg [ 1 : 0 ] Mode_tb;
  reg [ 7 : 0 ] data_to_send_tb;

  reg write_ready_tb, 
      read_ready_tb;

  reg [ 1 : 0 ] secondary_num_tb;

  reg flag_inv_tb;

  wire [ 2 : 0 ] CS_tb;

  wire SCLK_tb,
       MOSI_tb;

  reg MISO_tb;

  wire ready_send_tb, 
       ready_read_tb;

  wire [ 7 : 0 ] recieved_data_tb;

  reg [ 7 : 0 ] data_to_recieve_tb;

  integer i;

  FPGA #( 8, 3 )
  DUT 
  (

    .CLK            ( CLK_tb           ),
    .Reset          ( Reset_tb         ),

    .Mode           ( Mode_tb          ),

    .data_to_send   ( data_to_send_tb  ),
    .write_ready    ( write_ready_tb   ),
    .read_ready      ( read_ready_tb    ),
    .secondary_num_i( secondary_num_tb ),
    .flag_inv_i     ( flag_inv_tb      ),
  
    .MISO           ( MISO_tb          ),
    .MOSI           ( MOSI_tb          ),
    .CS             ( CS_tb            ),
    .SCLK           ( SCLK_tb          ),

    .ready_send     ( ready_send_tb    ),
    .ready_read     ( ready_read_tb    ),
    .recieved_data  ( recieved_data_tb )

  );

  reg  [ 3 : 0 ] to_decode;
  wire [ 6 : 0 ] decoded_data;

  DC DC 
  ( 
  
    .X( to_decode    ), 
    .Y( decoded_data )
    
  );
  
  initial 
    begin

      //////Сброс//////////////

      Reset_tb       <= 1'd1;
      read_ready_tb  <= 1'd0;
      write_ready_tb <= 1'd0;
      MISO_tb        <= 1'dZ;

      @( posedge CLK_tb ); #1;
      Reset_tb <= 1'b0;

      // Настроим датчик температуры //

      // Отправим адрес регистра конфигурации //

      Mode_tb          <= 2'b10;
      flag_inv_tb      <= 1'b0;
      secondary_num_tb <= 2'b00;

      data_to_send_tb <= 8'h80;
      write_ready_tb  <= 1'b1;

      ////////////////////////////

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      ////////////////////////////

      @( posedge ready_send_tb ); // Адрес отправлен

      // Отправляем настройку //

      data_to_send_tb <= 8'b11100110;
      write_ready_tb  <= 1'b1;

      ////////////////////////////

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      ////////////////////////////

      @( posedge ready_send_tb ); // Датчик настроен

      // Отправляем адрес целой части температуры //

      data_to_send_tb <= 8'h02;
      write_ready_tb  <= 1'b1;

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      @( posedge ready_send_tb ); // Адрес отправлен

      //////Чтение//////

      Mode_tb <= 2'b11;

      data_to_recieve_tb <= 8'b00001010;
      read_ready_tb      <= 1'd1;

      for ( i = 0; i < 8; i = i + 1 ) 
        begin
      
          @( negedge CLK_tb );
          MISO_tb <= data_to_recieve_tb[ 7 - i ];

          if ( i == 1 )
            read_ready_tb <= 1'd0;

        end

      @( posedge ready_read_tb );
      MISO_tb <= 1'dZ;

      // Отправляем адрес дробной части температуры //

      Mode_tb <= 2'b10;

      data_to_send_tb <= 8'h01;
      write_ready_tb  <= 1'b1;

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      @( posedge ready_send_tb ); // Адрес отправлен

      //////Чтение//////

      Mode_tb <= 2'b11;

      data_to_recieve_tb <= 8'b00100000;
      read_ready_tb      <= 1'b1;

      for ( i = 0; i < 8; i = i + 1 ) 
        begin
      
          @( negedge CLK_tb );
          MISO_tb <= data_to_recieve_tb[ 7 - i ];

          if ( i == 1 )
            read_ready_tb <= 1'b0;

        end

      @( posedge ready_read_tb );
      MISO_tb <= 1'bZ; 

      /////Настроим на ручной режим//////////

      Mode_tb <= 2'b10;

      data_to_send_tb <= 8'h80; // Адрес
      write_ready_tb  <= 1'b1;

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      @( posedge ready_send_tb );

      ///////////////////////////////

      data_to_send_tb <= 8'b11100111; // Настройка
      write_ready_tb  <= 1'b1;

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      @( posedge ready_send_tb );

      // Отправляем адрес целой части температуры //

      data_to_send_tb <= 8'h02;
      write_ready_tb  <= 1'b1;

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      @( posedge ready_send_tb ); // Адрес отправлен

      //////Чтение//////

      Mode_tb <= 2'b11;

      data_to_recieve_tb <= 8'b00001010;
      read_ready_tb      <= 1'b1;

      for ( i = 0; i < 8; i = i + 1 ) 
        begin
      
          @( negedge CLK_tb );
          MISO_tb <= data_to_recieve_tb[ 7 - i ];

          if ( i == 1 )
            read_ready_tb <= 1'b0;

        end

      @( posedge ready_read_tb );
      MISO_tb <= 1'bZ;

      // Отправляем адрес дробной части температуры //

      Mode_tb <= 2'b10;

      data_to_send_tb <= 8'h01;
      write_ready_tb  <= 1'b1;

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      @( posedge ready_send_tb ); // Адрес отправлен

      //////Чтение//////

      Mode_tb <= 2'b11;

      data_to_recieve_tb <= 8'b00100000;
      read_ready_tb      <= 1'b1;

      for ( i = 0; i < 8; i = i + 1 )
        begin
      
          @( negedge CLK_tb );
          MISO_tb <= data_to_recieve_tb[ 7 - i ];

          if ( i == 1 )
            read_ready_tb <= 1'b0;

        end

      @( posedge ready_read_tb );
      MISO_tb <= 1'bZ;

      ////////АЦП////////////////////

      Mode_tb     <= 2'b00;
      flag_inv_tb <= 1'b1;

      data_to_send_tb  <= 8'b0000_1000; // WR_REG
      write_ready_tb   <= 1'b1;
      secondary_num_tb <= 2'b01;

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      @( posedge ready_send_tb );

      ///////////////////////////////

      data_to_send_tb <= 8'b0000_0010; // DATA_COF
      write_ready_tb  <= 1'b1;

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      @( posedge ready_send_tb );

      ///////////////////////////////

      data_to_send_tb <= 8'b0000_0011; // SPI-11
      write_ready_tb  <= 1'b1;

      @( posedge CLK_tb );#1;
      write_ready_tb <= 1'b0;

      @( posedge ready_send_tb );

      ///////////////////////////////

      data_to_send_tb <= 8'b0001_0000; // RD_REG
      write_ready_tb  <= 1'b1;

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      @( posedge ready_send_tb );

      ///////////////////////////////

      data_to_send_tb <= 8'b0000_0000; // SYSTEM_STATUS
      write_ready_tb  <= 1'b1;

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      @( posedge ready_send_tb );

      ///////////////////////////////

      data_to_send_tb <= 8'b0000_0000; // Ничего не значит
      write_ready_tb  <= 1'b1;

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      ///////////////////////////////

      @( posedge ready_send_tb );

      read_ready_tb      <= 1'b1;
      data_to_recieve_tb <= 8'b11001000;

      for ( i = 0; i < 8; i = i + 1 ) 
        begin
      
          @( posedge CLK_tb );
          MISO_tb <= data_to_recieve_tb[ 7 - i ];

          if ( i == 1 )
            read_ready_tb <= 1'b0;

        end

      @( posedge ready_read_tb );
      MISO_tb <= 1'bZ; 

      //////////////////Индикаторы/////////////////////////

      #100;

      to_decode <= recieved_data_tb[ 7 : 4 ];

      #1;

      ////////////////////////////////////////

      data_to_send_tb <= { 1'b0, decoded_data };

      Mode_tb          <= 2'b00;
      flag_inv_tb      <= 1'b1;
      secondary_num_tb <= 2'b10;

      write_ready_tb   <= 1'b1;

      ////////////////////////////

      @( posedge CLK_tb ); #1;
      write_ready_tb <= 1'b0;

      ////////////////////////////

      @( posedge ready_send_tb ); 

      ////////////////////////////////////////////////

      to_decode <= recieved_data_tb[ 3 : 0 ];

      #1;

      ////////////////////////////////////////

      data_to_send_tb <= { 1'b0, decoded_data };

      write_ready_tb  <= 1'b1;

      ////////////////////////////

      #10;
      write_ready_tb <= 1'b0;

      ////////////////////////////

      @( posedge ready_send_tb );
      $finish;

    end
  
endmodule
