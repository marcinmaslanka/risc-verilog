# MIPS32 Pipelined Processor (Verilog)

This project implements a simplified 5-stage pipelined MIPS32 processor in Verilog HDL. The design is educational and demonstrates instruction flow through pipeline stages: **Instruction Fetch (IF)**, **Instruction Decode (ID)**, **Execute (EX)**, **Memory Access (MEM)**, and **Write Back (WB)**.

## 📌 Features

- 32-bit architecture with a 5-stage pipeline
- Register-register and register-immediate ALU instructions
- Memory access: `lw`, `sw`
- Branch instructions: `beqz`, `bneqz`
- Pipelined hazard handling through basic branch prediction and pipeline control
- Halt instruction to stop execution

## 📁 Repository Structure

mips32/
├── mips32.v # Main Verilog source file
├── README.md # This file
├── testbench.v # (Optional) Testbench for simulation
└── mem_init.hex # (Optional) Memory initialization file


## 🛠️ Instructions

### Requirements

- Verilog simulator such as:
  - [Icarus Verilog](http://iverilog.icarus.com/)
  - [ModelSim / QuestaSim](https://eda.sw.siemens.com/en-US/ic/modelsim/)
  - Synopsys VCS or Cadence Xcelium
- Optional: GTKWave for waveform viewing

### Simulation

1. Compile:

```sh
iverilog -o mips32_tb mips32.v testbench.v
```

Run:

```sh
vvp mips32_tb
```

(Optional) View waveforms:

```sh
gtkwave dump.vcd
```

## 🧪 Supported Instructions
Instruction	Type	Description
```
add, sub, and, or, slt, mul	R-type	ALU operations
addi, subi, slti	I-type	Immediate ALU operations
lw, sw	I-type	Load/store word from/to memory
beqz, bneqz	I-type	Branch if equal/not equal zero
hlt	I-type	Halt processor execution
```

## 📦 Parameters
Register File: 32 registers (32-bit each)

Memory: 1024 words (32-bit each)

Instruction Format: MIPS-like 32-bit

## 📈 Pipeline Stages
```rust
IF  -> ID  -> EX  -> MEM -> WB
```
Each stage runs on either clk1 or clk2 to emulate instruction flow and parallelism.


## 🙋‍♂️ Contributions
Contributions, bug reports, and feature requests are welcome! Fork this repository and create a pull request.

---

