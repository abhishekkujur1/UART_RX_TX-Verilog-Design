// defines.v - Configuration switches for UART controller

// Uncomment ONLY ONE of these based on your test mode:
// `define UART_TX_ONLY    // Test only the transmitter
// `define UART_RX_ONLY    // Test only the receiver
                          // Leave both commented for full loopback test

// Clock and Baud Rate Configuration
`define CLOCK_RATE  25000000  // 25 MHz system clock
`define BAUD_RATE   115200    // Standard baud rate
`define RX_OVERSAMPLE 16      // Oversampling rate for RX

// UART Protocol Parameters
`define DATA_BITS   8         // 8 data bits
`define STOP_BITS   1         // 1 stop bit
`define PARITY      "NONE"    // "NONE", "EVEN", or "ODD"

// Simulation Control
`define SIM_CYCLES  100000    // Maximum simulation cycles