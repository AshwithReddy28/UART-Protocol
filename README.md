# UART Transmitter using Verilog HDL

A simple **UART Transmitter** designed using **Verilog HDL** and simulated in **AMD Vivado**.

This project was built to understand UART communication, baud-rate generation, FSM-based design, and the FPGA RTL-to-synthesis flow.

## 📌 Project Overview

UART (Universal Asynchronous Receiver Transmitter) is a widely used asynchronous serial communication protocol.

In this project, an 8-bit data value is converted into a serial UART frame consisting of:

```text
Idle → Start Bit → 8 Data Bits → Stop Bit
```

The transmitter sends the **least significant bit (LSB) first**.

For example, when transmitting:

```text
0x41 = 01000001
```

the data bits are transmitted as:

```text
1 0 0 0 0 0 1 0
```

## ⚙️ Design

The UART transmitter is implemented using a **Finite State Machine (FSM)** with four states:

```text
       ┌────────┐
       │  IDLE  │
       └───┬────┘
           │ tx_start
           ▼
       ┌────────┐
       │ START  │
       └───┬────┘
           │
           ▼
       ┌────────┐
       │  DATA  │
       └───┬────┘
           │ 8 bits transmitted
           ▼
       ┌────────┐
       │  STOP  │
       └───┬────┘
           │
           ▼
         IDLE
```

### FSM States

| State   | Function                         |
| ------- | -------------------------------- |
| `IDLE`  | Waits for a transmission request |
| `START` | Sends the UART start bit (`0`)   |
| `DATA`  | Sends 8 data bits, LSB first     |
| `STOP`  | Sends the stop bit (`1`)         |

## 🔢 UART Configuration

| Parameter       | Value  |
| --------------- | ------ |
| Clock Frequency | 10 MHz |
| Baud Rate       | 115200 |
| Data Bits       | 8      |
| Parity          | None   |
| Stop Bits       | 1      |
| Frame Format    | 8N1    |

The number of clock cycles required for one UART bit is calculated as:

```text
CLKS_PER_BIT = CLK_FREQ / BAUD_RATE
```

For this design:

```text
CLKS_PER_BIT = 10,000,000 / 115,200
             ≈ 87 clock cycles
```

## 🧩 Module Interface

### Inputs

| Signal         | Description            |
| -------------- | ---------------------- |
| `clk`          | System clock           |
| `rst`          | Reset                  |
| `tx_start`     | Starts transmission    |
| `data_in[7:0]` | 8-bit data to transmit |

### Outputs

| Signal | Description                                |
| ------ | ------------------------------------------ |
| `tx`   | UART serial output                         |
| `busy` | Indicates that transmission is in progress |

## 🛠️ Tools Used

* **Verilog HDL**
* **AMD Vivado**
* Behavioral Simulation
* RTL Elaboration
* Logic Synthesis

## 🧪 Simulation

The design was verified using a Verilog testbench in Vivado.

The testbench sends sample ASCII characters through the UART transmitter and observes the `tx` and `busy` signals.

Example:

```text
Data = 0x41
ASCII = 'A'
```

Expected UART frame:

```text
Idle    Start    Data Bits          Stop
  1       0      1 0 0 0 0 0 1 0      1
```

## 📊 Design Flow

```text
UART Protocol Understanding
          ↓
Baud Rate Calculation
          ↓
FSM Design
          ↓
Verilog RTL Coding
          ↓
Behavioral Simulation
          ↓
RTL Elaboration
          ↓
Synthesis
```

## 📁 Repository Structure

```text
UART-Transmitter/
│
├── uart.v
├── uart_tb.v
├── README.md
│
└── screenshots/
    ├── uart_code.png
    ├── simulation.png
    ├── rtl_schematic.png
    └── synthesized_schematic.png
```

## 📚 What I Learned

Through this project, I gained hands-on experience with:

* UART serial communication
* Finite State Machine design
* Verilog registers and counters
* Baud-rate timing
* RTL design
* Behavioral simulation
* RTL elaboration
* FPGA synthesis flow
* Debugging digital designs using waveforms

## 🚀 Future Improvements

Some possible extensions to this project:

* [ ] UART Receiver
* [ ] UART TX/RX Loopback
* [ ] Configurable baud rate
* [ ] Parity-bit support
* [ ] FIFO-based UART
* [ ] FPGA hardware testing
* [ ] PC-to-FPGA communication

## 👨‍💻 Author

**Guda Ashwith Reddy**

Electronics & Communication Engineering
Interested in **VLSI, FPGA and Digital Design**

---

⭐ This project is part of my learning journey in **Verilog HDL, FPGA design and VLSI**.
