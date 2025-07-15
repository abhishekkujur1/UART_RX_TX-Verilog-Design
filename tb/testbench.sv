// Code your testbench here


//`timescale 1ns/100ps
`include "defines.v"

module UART_TB ();

// Testbench uses a 25 MHz clock, want to interface to 115200 baud UART , 25000000 / 115200 = 217 	Clocks Per Bit
	parameter c_CLOCK_PERIOD_NS = 40;  
	parameter c_CLKS_PER_BIT = 217;    
	parameter c_BIT_PERIOD = 8680;    

// Initialize Variables
	reg Clock = 0;
	reg reset_n = 0;

`ifdef UART_TX_ONLY
    wire Tx_Done;
    reg Tx_Ready = 0;
    wire Tx_Active;
    wire Tx_Data;
    reg [7:0] Tx_Byte = 0;
`elsif UART_RX_ONLY
    wire [7:0] Rx_Byte;
    reg UART_Rx = 0;
    wire Rx_Done;
`else
    wire Rx_Done;
    wire [7:0] Rx_Byte;
    reg [7:0] Tx_Byte = 0;
    reg Tx_Ready = 0;

    
    reg [7:0] DataToSend[0:7] = {8'h01, 8'h10, 8'h22, 8'h32, 8'h55, 8'hAA, 8'hAB, 8'h88};
    reg [7:0] DataToSend_1[0:7] = {8'h21, 8'h11, 8'h32, 8'h77, 8'hA0, 8'h0B, 8'hBB, 8'hFF};
    reg [7:0] DataReceived[0:7];
    integer ii;
`endif
  
 
// Add these wire declarations
wire Tx_Active;
wire Tx_Data; 
wire Tx_Done;
  
  
`ifdef UART_TX_ONLY
uart_controller #(.CLOCK_RATE(25000000), .BAUD_RATE(115200)) XUART_TX(
    .clk        (Clock),
    .reset_n    (reset_n),
    .i_Tx_Ready (Tx_Ready),
    .i_Tx_Byte  (Tx_Byte),
    .o_Tx_Active(Tx_Active),
    .o_Tx_Data  (Tx_Data),
    .o_Tx_Done  (Tx_Done)
);

`elsif UART_RX_ONLY
uart_controller #(.CLOCK_RATE(25000000), .BAUD_RATE(115200), .RX_OVERSAMPLE(16)) XUART_RX(
    .clk        (Clock),
    .reset_n    (reset_n),
    .i_Rx_Data  (UART_Rx),
    .o_Rx_Done  (Rx_Done),
    .o_Rx_Byte  (Rx_Byte)
);

`else
// Full mode (TX + RX)
uart_controller #(.CLOCK_RATE(25000000), .BAUD_RATE(115200), .RX_OVERSAMPLE(16)) XUART(
    .clk        (Clock),
    .reset_n    (reset_n),
    .i_Tx_Ready (Tx_Ready),
    .i_Tx_Byte  (Tx_Byte),
    .o_Tx_Active(Tx_Active),
    .o_Tx_Data  (Tx_Data),
    .o_Tx_Done  (Tx_Done),
    .i_Rx_Data  (Tx_Data), // Loopback connection
    .o_Rx_Done  (Rx_Done),
    .o_Rx_Byte  (Rx_Byte)
);
`endif
  
  
  

// Clock Generator
always #(c_CLOCK_PERIOD_NS/2) Clock <= !Clock;

`ifdef UART_TX_ONLY // UART TX Controller Test
    reg [7:0] DataToSend_TX = 8'b01010101;
    initial begin
        #5 reset_n = 1;
        @(posedge Clock);
        @(posedge Clock);
        Tx_Ready = 1'b1;
        @(posedge Clock); Tx_Byte = DataToSend_TX;
        #100000;
        $finish();
    end

`elsif UART_RX_ONLY // UART RX Controller Test
    reg [7:0] DataToSend_RX = 8'b01010101;
    integer i;
    initial begin
        #5 reset_n = 1;
        @(posedge Clock); UART_Rx = 0; // Start bit
        
        for(i=0; i < 8; i = i+1) begin
          #(217*40); // Wait one bit period
            @(posedge Clock); UART_Rx = DataToSend_RX[i]; // Data bits
        end
        
        #85000;
        $finish();
    end

`else // UART TX + RX Controller Test (Loopback)
    initial begin
        #5 reset_n = 1;
        @(posedge Clock);
        @(posedge Clock);
        Tx_Ready <= 1'b1;
        
        for (ii = 0; ii < 8; ii = ii + 1) begin
            Tx_Byte = DataToSend[ii];
            @(posedge Rx_Done);
            DataReceived[ii] = Rx_Byte;
            
            if (DataToSend[ii] == DataReceived[ii])
                $display("Test Passed - Correct Byte Received. TX Data Byte = %h, RX Data Byte = %h", 
                        DataToSend[ii], DataReceived[ii]);
            else
                $display("Test Failed - Incorrect Byte Received. TX Data Byte = %h, RX Data Byte = %h", 
                        DataToSend[ii], DataReceived[ii]);
        end
        
        $finish();
    end
`endif

// Required to dump signals to EPWave
  initial begin
    $dumpfile("waves.vcd");
    $dumpvars(0);
  end
endmodule
   
