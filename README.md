# MIPS32 Pipelined Processor (Verilog)

This project implements a simplified 5-stage pipelined MIPS32 processor in Verilog HDL. The design is educational and demonstrates instruction flow through pipeline stages: **Instruction Fetch (IF)**, **Instruction Decode (ID)**, **Execute (EX)**, **Memory Access (MEM)**, and **Write Back (WB)**.

## 📌 Features

- 32-bit architecture with a 5-stage pipeline
- Register-register and register-immediate ALU instructions
- Memory access: `lw`, `sw`
- Branch instructions: `beqz`, `bneqz`
- Pipelined hazard handling through basic branch prediction and pipeline control
- Halt instruction to stop execution

## 🧪 Testbenches
The following testbenches demonstrate and verify the functionality of the MIPS32 pipelined processor:

File	Description
- mips32_tb.v	Basic testbench to validate instruction execution and processor pipeline.
- mips32_tb2.v	Adds memory read/write tests and validates ALU operations.
- mips32_tb3.v	Verifies conditional branching and program flow control.
- mips32_tb4.v	Tests loop execution by calculating the sum of the first N natural numbers.
- mips32_tb5.v	Calculates the Fibonacci sequence up to N elements, storing results in memory.

You can run each testbench in a simulator like Icarus Verilog and observe register/memory changes via $monitor or waveform dump.


## 🛠️ Instructions

### Requirements

- Verilog simulator such as:
  - [Icarus Verilog](http://iverilog.icarus.com/)
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

| Instruction                             | Type   | Description                          |
|-----------------------------------------|--------|--------------------------------------|
| `add`, `sub`, `and`, `or`, `slt`, `mul` | R-type | ALU operations                       |
| `addi`, `subi`, `slti`                  | I-type | Immediate ALU operations             |
| `lw`, `sw`                              | I-type | Load/store word from/to memory       |
| `beqz`, `bneqz`                         | I-type | Branch if equal/not equal to zero    |
| `hlt`                                   | I-type | Halt processor execution             |


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

