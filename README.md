# 🔄 UART Core (Verilog) – Full-Duplex Serial Communication IP

## ⚡ Overview

This project presents a fully configurable **UART (Universal Asynchronous Receiver-Transmitter)** core written in **Verilog HDL**, tailored for **full-duplex serial communication** in custom digital systems. It supports **32-bit data transmission**, configurable parity, and robust error detection, making it suitable for **SoCs**, **FPGAs**, and **embedded communication subsystems**.

## 📐 Technical Specifications

* **Data Width:** 32-bit (configurable)
* **Baud Rate:** 9600 bps (programmable via clock divider)
* **Oversampling:** 16x for accurate bit detection
* **Framing Format:** 1 start bit, 32 data bits, 1 parity bit, 1 stop bit
* **Parity:** Configurable (odd/even)
* **Architecture:** Full-duplex asynchronous communication
* **Synchronization:** Multi-stage metastability protection
* **State Machines:** Clean FSMs for both TX and RX


## 🔧 Features

### 📤 Transmitter

* State-driven TX FSM for deterministic behavior
* Clock divider-based baud rate control
* Real-time parity bit generation (odd/even)
* `busy` signal for transmission control
* Bit-accurate edge-aligned output logic

### 📥 Receiver

* Start bit detection using edge sensitivity
* Mid-bit sampling for noise immunity
* Triple flip-flop synchronization for input stability
* Frame and parity error detection
* Outputs: `data_ready`, `parity_error`, `framing_error`

---

## 🔄 Protocol Workflow

* Start bit recognition
* Data reception/transmission
* Parity bit generation and validation
* Stop bit confirmation
* Status/error signal generation

---

## ⚙️ Performance Metrics

* **Clock Domain:** Single clock operation for easy integration
* **Resource Use:** Low footprint, synthesis-optimized
* **Reliability:** High noise immunity and metastability resistance
* **Verification:** Exhaustive testbench with edge case testing

---

## 🔌 I/O Interface

### ➤ Transmitter Ports

* `clk` – Clock input
* `rst` – Asynchronous reset
* `data[31:0]` – Input parallel data
* `start` – Trigger for data transmission
* `parity_type` – 0 = odd, 1 = even parity
* `tx` – Serial output
* `busy` – Transmission status flag

### ➤ Receiver Ports

* `clk` – Clock input
* `rst` – Asynchronous reset
* `rx` – Serial data input
* `parity_type` – 0 = odd, 1 = even parity
* `data[31:0]` – Output parallel data
* `data_ready` – Valid data signal
* `parity_error` – Indicates parity mismatch
* `framing_error` – Indicates stop bit fault

---

## 🧪 Testbench & Verification

* Functional simulation of full TX-RX loop
* Coverage for edge conditions and noise scenarios
* Parity mismatch and frame error injection
* Clock stretching and protocol timing checks

---

## 💡 Applications

* SoC UART interfaces
* FPGA communication peripherals
* Microcontroller UART modules
* Debug/monitor ports
* Inter-chip communication links
* Protocol converters

---

## 📝 Implementation Notes

The design leverages **FSMs** for efficient TX/RX management, balances **performance and footprint**, and is ready for **synthesis and deployment** on FPGA or ASIC platforms. Emphasis is placed on **robust parity and framing error handling** for mission-critical applications.
