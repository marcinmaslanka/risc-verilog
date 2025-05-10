// ============================================================================
// Testbench: MIPS32 Pipelined Processor - Sum of First N Natural Numbers
// Description:
//   This testbench verifies the functionality of a pipelined MIPS32 processor
//   by computing the sum of the first N natural numbers using a simple loop.
//   The input value N is stored at memory address 100, and the resulting sum
//   is written to memory address 101.
//
//   Program Flow:
//     - Load N from memory[100]
//     - Initialize sum = 0 and index i = 1
//     - Loop: sum += i; i++ until i >= N
//     - Store sum into memory[101]
//
// Author: Marcin Maslanka  
// Date: 06.05.2025
// ============================================================================

module mips32_tb4;

  // Clock signals for pipeline stages
  reg clk1, clk2;

  // Loop index for initialization
  integer k;

  // Instantiate the Device Under Test (DUT)
  mips32 uut(clk1, clk2);

  // Clock generation
  initial begin
    clk1 = 0; clk2 = 0;
    repeat (100) begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;

      // Display key register and memory values
      $monitor("t=%0t | pc=%0d | r1(N)=%0d | r2(sum)=%0d | r3(i)=%0d | r4(cond)=%0d | mem[100]=%0d | mem[101]=%0d",
               $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3], uut.regfile[4], uut.mem[100], uut.mem[101]);
    end
  end

  // Program: Sum of first N natural numbers
  initial begin
    // Initialize registers
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = 0;

    // Load N into memory[100]
    uut.mem[100] = 10;  // N = 10 → Expected sum = 55

    // Instruction memory setup
    uut.mem[0]  = 32'h28010064; // addi r1, r0, 100       ; r1 = address of N (100)
    uut.mem[1]  = 32'h0ce77800; // dummy
    uut.mem[2]  = 32'h20210000; // lw   r1, 0(r1)         ; r1 = mem[100] = N
    uut.mem[3]  = 32'h28020000; // addi r2, r0, 0         ; sum = 0 (r2)
    uut.mem[4]  = 32'h28030001; // addi r3, r0, 1         ; i = 1 (r3)
    uut.mem[5]  = 32'h0ce77800; // dummy

    // loop:
    uut.mem[6]  = 32'h00431000; // add  r2, r2, r3        ; sum += i
    uut.mem[7]  = 32'h0ce77800; // dummy
    uut.mem[8]  = 32'h28630001; // addi r3, r3, 1         ; i++
    uut.mem[9]  = 32'h0ce77800; // dummy
    uut.mem[10] = 32'h1023202a; // slt  r4, r3, r1        ; r4 = (i < N) ? 1 : 0
    uut.mem[11] = 32'h0ce77800; // dummy
    uut.mem[12] = 32'h3880fff9; // bneqz r4, -7           ; if r4 != 0, jump to loop

    // Store result
    uut.mem[13] = 32'h28010065; // addi r1, r0, 101       ; r1 = address to store result
    uut.mem[14] = 32'h0ce77800; // dummy
    uut.mem[15] = 32'h24220000; // sw   r2, 0(r1)         ; mem[101] = sum

    uut.mem[16] = 32'hfc000000; // hlt                    ; halt

    // Reset processor state
    uut.pc = 0;
    uut.halted = 0;
    uut.taken_branch = 0;

    #3000; // Let the simulation run

    // Show result
    $display("Sum = %0d (expected 55)", uut.mem[101]);
  end

  // VCD waveform dump
  initial begin
    $dumpfile("mips32_tb.vcd");
    $dumpvars(0, mips32_tb4);
    #3000;
    $display("Simulation finished.");
    $finish;
  end

endmodule
