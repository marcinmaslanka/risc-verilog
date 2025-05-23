# MIPS32 Pipelined Processor – Basic Testbench

This project demonstrates the functionality of a 5-stage pipelined MIPS32 processor using a simple test program that performs a series of arithmetic operations.

## 🔧 Files

- `mips32.v` – RTL implementation of the pipelined MIPS32 processor.
- `mips32_tb.v` – Testbench to verify core processor functionality.
- `mips32_tb.vcd` – Optional output waveform file (generated after simulation).
- `README.md` – Documentation file (you are reading it!).

## 📋 Description

The testbench initializes the processor and loads a basic program into instruction memory. This program demonstrates the execution of `addi`, `add`, and `hlt` instructions, validating register file updates and instruction flow.

### Program Instructions

```verilog
uut.mem[0] = 32'h2801000a; // addi r1, r0, 10       ; r1 = 10
uut.mem[1] = 32'h28020014; // addi r2, r0, 20       ; r2 = 20
uut.mem[2] = 32'h28030019; // addi r3, r0, 25       ; r3 = 25
uut.mem[3] = 32'h00222000; // add  r4, r1, r2       ; r4 = r1 + r2 = 30
uut.mem[4] = 32'h0ce77800; // inert dummy instruction (no operation)
uut.mem[5] = 32'h00832800; // add  r5, r4, r3       ; r5 = r4 + r3 = 55
uut.mem[6] = 32'hfc000000; // hlt                   ; stop execution
```

## Final Register Values
`
  Register	Value
  r1	10
  r2	20
  r3	25
  r4	30
  r5	55
`

## ▶️ How to Run (Using Icarus Verilog)
Compile the design:

```bash
iverilog -o mips32_tb.out mips32.v mips32_tb.v
```

Run the simulation:

```bash
vvp mips32_tb.out
```

View waveform:

```bash
gtkwave mips32_tb.vcd
```

## 📽️ Video Explanation
The simulation traces how MIPS32 instructions are fetched, decoded, executed, and how registers are updated over time.

Instruction fetch and decode

Register file initialization

Pipeline timing with dummy instruction

Final values in registers

## 💡 Notes
This testbench uses dual clocks clk1 and clk2 for pipeline stage control.

The simulation ends automatically after 20 cycles or when a hlt instruction is executed.

## 📁 Folder Structure (Suggested)

```bash
/mips32/
├── mips32.v          # Processor RTL
├── mips32_tb.v       # Testbench
├── mips32_tb.vcd     # Waveform (after simulation)
├── README.md         # Documentation
```

## 📜 License
This project is open-source and free to use for educational and personal purposes. Feel free to fork, modify, and share.

## ✍️ Author
Marcin Maslanka

Feel free to contribute or submit improvements!
