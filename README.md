# MIPS32 Pipelined Processor (Verilog)

This project implements a simplified 5-stage pipelined MIPS32 processor in Verilog HDL. The design is educational and demonstrates instruction flow through pipeline stages: **Instruction Fetch (IF)**, **Instruction Decode (ID)**, **Execute (EX)**, **Memory Access (MEM)**, and **Write Back (WB)**.

![image](https://github.com/user-attachments/assets/1be8173e-3df3-4fc3-a582-f84149911e94)

Source 1: Implementation of 5-Stage 32-Bit Microprocessor Based Without Interlocked Pipelining Stages ; International Journal of Innovative Technology and Exploring Engineering (IJITEE)
ISSN: 2278-3075 (Online), Volume-9 Issue-1, November 2019

Source 2: VERILOG MODELING OF THE PROCESSOR (PART 1) ; https://www.youtube.com/watch?v=NaO-xw6Mlw0&list=PLJ5C_6qdAvBELELTSPgzYkQg3HgclQh-5&index=40

Source 3: https://www.cs.umd.edu/~meesh/411/CA-online/chapter/pipelining-mips-implementation/index.html#:~:text=In%20general%2C%20let%20the%20instruction,%2C%20Ei%2C%20Mi%20and%20Wi.

## 📌 Features

- 32-bit architecture with a 5-stage pipeline
- Register-register and register-immediate ALU instructions
- Memory access: `lw`, `sw`
- Branch instructions: `beqz`, `bneqz`
- Pipelined hazard handling through basic branch prediction and pipeline control
- Halt instruction to stop execution

## 🧪 Testbenches
The following testbenches demonstrate and verify the functionality of the MIPS32 pipelined processor:


| Testbench File  | Folder Name                  | Description                               |
| --------------- | ---------------------------- | ----------------------------------------- |
| `mips32_tb.v`   | `basic_execution`            | Basic instruction and pipeline validation |
| `mips32_tb2.v`  | `memory_and_alu`             | Tests memory access and ALU ops           |
| `mips32_tb3.v`  | `branching_and_control_flow` | Conditional branching and flow control    |
| `mips32_tb4.v`  | `sum_of_n_numbers`           | Looping: sum of first N numbers           |
| `mips32_tb5.v`  | `fibonacci_sequence`         | Fibonacci using memory and loops          |
| `mips32_tb6.v`  | `find_max_in_array`          | Maximum value in array                    |
| `mips32_tb7.v`  | `sum_and_average`            | Sum and average of array elements         |
| `mips32_tb8.v`  | `load_array_find_max`        | Load from memory + find max               |
| `mips32_tb9.v`  | `bubble_sort`                | Bubble sort algorithm                     |
| `mips32_tb10.v` | `integer_division`           | Division using subtraction                |
| `mips32_tb11.v` | `power_function`             | a^b using repeated multiplication         |
| `mips32_tb12.v` | `mode_finder`                | Find most frequent value (mode)           |
| `mips32_tb13.v` | `bit_counting`               | Count set bits (bitwise ops)              |
| `mips32_tb14.v` | `manual_shifts`              | Manual logical shifts                     |
| `mips32_tb15.v` | `fsm_test`                   | 3-state finite state machine              |
| `mips32_tb16.v` | `caesar_cipher`              | Caesar cipher encryption                  |


You can run each testbench in a simulator like Icarus Verilog and observe register/memory changes via $monitor or waveform dump.


## 🛠️ Instructions

### Requirements

- Verilog simulator such as:
  - [Icarus Verilog](http://iverilog.icarus.com/)
- Optional: GTKWave for waveform viewing

### Simulation

1. Compile:

```sh
iverilog -o mips32_tb.vvp mips32_tbxx.v mips32.v
```

Run:

```sh
vvp mips32_tb.vvp
```

(Optional) View waveforms:

```sh
gtkwave mips32_tb.vcd
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

