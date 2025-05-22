// ============================================================================
// Testbench: MIPS32 Pipelined Processor
// Description:
//   This testbench displays register and memory values after each step.
//   It loads a small program that reads a value from memory,
//   adds 45 to it, and writes it back.
//
//   Waveform output is also generated for debugging via GTKWave.
//
// Author: Marcin Maslanka  
// 
// ============================================================================

module mips32_tb2;

  // Clock signals for both phases
  reg clk1, clk2;

  // Loop variable
  integer k;

  // Device Under Test (DUT): instance of the processor
  mips32 uut(clk1, clk2);

  // Clock generator: alternates rising edges for clk1 and clk2
  initial 
  begin
    clk1 = 0; clk2 = 0;

    // 50 clock cycles (each iteration represents one full cycle)
    repeat (50) 
    begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;

      // Display key register and memory values
      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d | mem[120]=%0d | mem[121]=%0d",
               $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.mem[120], uut.mem[121]);
    end
  end

  // Initialization of memory and registers
  initial
  begin
    // Initialize register file: R0 to R31 = 0 to 31
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = k;
    // Initialize memory: mem[120] = 85
    uut.mem[120] = 85;
        

    // Load program instructions (machine code)
    uut.mem[0] = 32'h28010078; // addi r1, r0, 120       ; r1 = 120
    uut.mem[1] = 32'h0ce77800; // dummy instruction      ; pipeline spacing
    uut.mem[2] = 32'h20220000; // lw   r2, 0(r1)         ; r2 = mem[120]
    uut.mem[3] = 32'h0ce77800; // dummy
    uut.mem[4] = 32'h2842002d; // addi r2, r2, 45        ; r2 += 45
    uut.mem[5] = 32'h0ce77800; // dummy
    uut.mem[6] = 32'h24220001; // sw   r2, 1(r1)         ; mem[121] = r2
    uut.mem[7] = 32'hfc000000; // hlt                    ; halt execution

  
    // Initialize control signals
    uut.pc = 0;
    uut.halted = 0;
    uut.taken_branch = 0;

    // Waveform output setup
    $dumpfile("mips32_tb.vcd");         // Output file for GTKWave
    $dumpvars(0, mips32_tb2);           // Dump all variables in this module
    #300;
    $display("Simulation finished.");
    $finish;                                                       

  end

endmodule
