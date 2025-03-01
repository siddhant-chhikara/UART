## UART Core Implementation

## Overview

This repository contains a robust UART (Universal Asynchronous Receiver-Transmitter) implementation in Verilog HDL that features high configurability, complete asynchronous transmission capabilities, and extensive protocol verification. The core supports 32-bit data transfer with configurable parity checking.

## Technical Specifications

- **Architecture**: Full-duplex asynchronous serial communication
- **Data Width**: 32-bit configurable word size
- **Baud Rate**: Programmable clock divider (16x oversampling)
- **Framing**: 1 start bit + 32 data bits + 1 parity bit + 1 stop bit
- **Parity**: Configurable odd/even parity generation and checking
- **Synchronization**: Multi-stage input synchronization for metastability protection
- **Edge Detection**: Precise start bit detection using edge-sensitive triggering
- **Protocol Handling**: Complete state machine for transmit and receive operations

## Key Features

### Transmitter Module
- State-based transmission control
- Programmable baud rate generation
- Dynamic parity calculation (odd/even selectable)
- Busy status signaling for flow control
- Low-level bit timing control

### Receiver Module
- Robust start bit detection using edge sensing
- Mid-bit sampling for noise immunity
- Triple-register synchronization for metastability prevention
- Real-time parity validation
- Frame error detection

### Protocol Implementation
- Start bit verification
- Data bit collection
- Parity generation and validation
- Stop bit integrity checking
- Error detection and reporting

## Performance Characteristics

- **Clock Domain**: Single-clock design for simplified integration
- **Resource Utilization**: Minimal footprint suitable for FPGA/ASIC implementation
- **Verification**: Comprehensive testbench with protocol validation
- **Reliability**: Protected against metastability and signal integrity issues

## Interface Signals

### Transmitter
- `clk`: System clock input
- `rst`: Asynchronous reset
- `data[31:0]`: Parallel data input
- `start`: Transmission control signal
- `parity_type`: 0 = odd parity, 1 = even parity
- `tx`: Serial data output
- `busy`: Transmitter status

### Receiver
- `clk`: System clock input
- `rst`: Asynchronous reset
- `rx`: Serial data input
- `parity_type`: 0 = odd parity, 1 = even parity
- `data[31:0]`: Parallel data output
- `data_ready`: Data valid indicator
- `parity_error`: Parity validation failure signal

## Verification Methodology

The implementation includes a comprehensive self-checking testbench that:
- Simulates complete transmission cycles
- Verifies data integrity across the serial interface
- Tests both odd and even parity modes
- Validates error detection capabilities
- Monitors state transitions and timing parameters

## Applications

This UART core is suitable for:
- System-on-chip (SoC) integration
- FPGA-based communication systems
- Microcontroller interfaces
- Digital signal processor (DSP) communications
- Debug and diagnostic ports
- Protocol bridging applications

## Implementation Notes

The design employs finite state machines (FSM) for both transmitter and receiver, with careful attention to timing requirements and signal integrity. The architecture balances resource efficiency with robust operation through intelligent state encoding and streamlined processing paths.
