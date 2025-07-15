# 🚀 UART RX/TX Controller - Verilog Design

[![Verilog](https://img.shields.io/badge/Verilog-FF0000?logo=verilog)](https://en.wikipedia.org/wiki/Verilog)
[![UART](https://img.shields.io/badge/Protocol-UART-009688)](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter)
[![EDA Playground](https://img.shields.io/badge/Tested_on-EDA_Playground-4285F4)](https://www.edaplayground.com)

A fully parameterized UART controller with configurable baud rates, tested in Riviera-PRO and GTKWave.
This design supports both transmitting and receiving serial data with 16x oversampling for improved noise resilience. 
It is modular, configurable, and verified using Riviera-PRO and GTKWave. Ideal for FPGA or ASIC-based embedded systems.


## 📂 Repository Structure
```
UART_RX_TX-Verilog-Design/
├── src/                         # RTL Source Files
│ ├── baudRateGenerator.sv       # Clock divider (16x oversampling)
│ ├── defines.v                  # Configuration macros
│ ├── design.sv                  # Top-level UART controller
│ ├── uart_rx_controller.sv      # Receiver module
│ └── uart_tx_controller.v       # Transmitter module
│
├── tb/ # Testbench
│ └── testbench.sv               # Verification environment
│
└── scripts/                     # Automation
└── run.sh                       # Simulation script (Riviera-PRO)
```

## 🔥 Key Features
- **Dual-mode operation**: TX-only, RX-only, or full duplex
- **Baud rate customization**: 115200 default (configurable in `defines.v`)
- **16x oversampling**: Robust noise-resistant receiver
- **Self-test capability**: Loopback verification mode

## 📊 Simulation Results
![GTKWave Screenshot](C:\Users\SAMSUNG\OneDrive\Desktop\UART_RX_TX-Verilog-Design\docs\GTKWaves.png)  
*Verified in Riviera-PRO 2023.04 with 100% test coverage*

✅ **Test Cases Passed**:
- TX → RX byte transfer (8'h01 to 8'hFF)
- Baud rate tolerance ±3%
- Start/stop bit error handling

## 🧪 Try It Online

You can run this UART RX/TX Verilog project directly in your browser:

👉 **[Simulate on EDA Playground](https://edaplayground.com/x/8xj5)**  
*(No setup needed – powered by Aldec Riviera-PRO)*

## 📄 License

This project is licensed under the [MIT License](LICENSE).




