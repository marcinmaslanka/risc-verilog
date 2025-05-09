// ============================================================================
// Testbench: MIPS32 Pipelined Processor (5-Stage)
// Description:
//   This testbench instantiates and verifies the functionality of a
//   5-stage pipelined MIPS32 processor. It simulates a small program that:
//     - Initializes a register with a memory address,
//     - Loads a value from memory,
//     - Performs a looped multiplication using load, addi, subi, bneqz,
//     - Stores the result back to memory,
//     - Halts execution.
//
//   All required instructions and data are manually loaded into memory,
//   and waveform output is generated for post-simulation inspection.
//
// Author: Marcin Maslanka  
// Date: 06.05.2025
// ============================================================================

module mips32_tb3;

  // Clock signals for two-phase clocking
  reg clk1, clk2;

  // Loop index for initialization
  integer k;

  // Instantiate the Device Under Test (DUT)
  mips32 uut(clk1, clk2);

  // Clock generation: alternating clk1 and clk2 phases
  initial begin
    clk1 = 0;
    clk2 = 0;
    repeat (50) begin
      #5 clk1 = 1; #5 clk1 = 0;  // Positive edge of clk1
      #5 clk2 = 1; #5 clk2 = 0;  // Positive edge of clk2
    end
  end

  // Initial setup: register file, instruction memory, data memory
  initial begin
    // Initialize all registers: R0 = 0, R1 = 1, ..., R31 = 31
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = k;

    // Program: multiply mem[200] by itself (factorial-style loop) and store result in mem[198]
    uut.mem[0]  = 32'h280a00c8; // addi r10, r0, 200      ; r10 = 200
    uut.mem[1]  = 32'h28020001; // addi r2, r0, 1         ; r2 = 1
    uut.mem[2]  = 32'h0e94a000; // dummy                  ; pipeline delay
    uut.mem[3]  = 32'h21430000; // lw   r3, 0(r10)        ; r3 = mem[200]
    uut.mem[4]  = 32'h0e94a000; // dummy
    uut.mem[5]  = 32'h14431000; // mul  r2, r2, r3        ; r2 *= r3
    uut.mem[6]  = 32'h2c630001; // subi r3, r3, 1         ; r3 -= 1
    uut.mem[7]  = 32'h0e94a000; // dummy
    uut.mem[8]  = 32'h3460fffc; // bneqz r3, loop         ; loop if r3 != 0
    uut.mem[9]  = 32'h2542fffe; // sw   r2, -2(r10)       ; mem[198] = r2
    uut.mem[10] = 32'hfc000000; // hlt                    ; halt

    // Initialize data memory
    uut.mem[200] = 7;           // initial loop counter (e.g., factorial of 7)

    // Reset processor state
    uut.halted        = 0;
    uut.pc            = 0;
    uut.taken_branch  = 0;

    // Allow simulation to run
    #2000;

    // Output final results
    $display("Final memory content:");
    $display("  mem[200] = %2d", uut.mem[200]);
    $display("  mem[198] = %2d", uut.mem[198]);  // Expected factorial(7) = 5040
  end

  // Waveform output for GTKWave and debugging
  initial begin
    $dumpfile("mips32_tb.vcd");
    $dumpvars(0, mips32_tb3);
    $monitor("t=%0t | R2=%4d", $time, uut.regfile[2]); 
    #3000;
    $display("Simulation finished.");
    $finish;
  end

endmodule
