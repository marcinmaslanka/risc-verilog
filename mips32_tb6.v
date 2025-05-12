// ============================================================================
// Testbench: MIPS32 Pipelined Processor - Array Reversal
// Description:
//   This testbench verifies the MIPS32 processor by reversing an array of N integers
//   in memory in-place. Array starts at memory[100].
//
// Author: Marcin Maslanka
// Date: 11.05.2025
// ============================================================================

module mips32_tb6;

  // Clock signals for pipeline stages
  reg clk1, clk2;
  integer k;

  // Instantiate DUT
  mips32 uut(clk1, clk2);

  // Clock generation
  initial begin
    clk1 = 0; clk2 = 0;
    repeat (100) begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;
      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d | r3=%0d | r4=%0d | r5=%0d | r6=%0d | r7=%0d | r8=%0d | r9=%0d | mem[100]=%0d | mem[101]=%0d | mem[102]=%0d | mem[103]=%0d" ,
               $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3], uut.regfile[4], uut.regfile[5], uut.regfile[6], uut.regfile[7], uut.regfile[8], uut.regfile[9], uut.mem[100], uut.mem[101], uut.mem[102], uut.mem[103]);
    end
  end

  // Program: Reverse N elements at memory[100]
  initial begin
    // Initialize registers
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = 0;

    // Load memory with example data: N = 4, array = [10, 20, 30, 40]
    uut.mem[99] = 4;       // mem[99] = N
    uut.mem[100] = 10;
    uut.mem[101] = 20;
    uut.mem[102] = 30;
    uut.mem[103] = 40;

    // Program: reverse array in-place
    uut.mem[0]  = 32'h28010063; // addi r1, r0, 99      ; r1 = addr of N
    uut.mem[1]  = 32'h0ce77800; // dummy
    uut.mem[2]  = 32'h20210000; // lw   r1, 0(r1)       ; r1 = N
    uut.mem[3]  = 32'h28020000; // addi r2, r0, 0       ; i = 0
    uut.mem[4]  = 32'h28060064; // addi r6, r0, 100     ; base addr
    uut.mem[5]  = 32'h0ce77800; // dummy


    // indices: r4 = base+i, r5 = base+N−1−i
    uut.mem[6] = 32'h00c22000; // add r4, r6, r2       ; r4 = base+i
    uut.mem[7] = 32'h0ce77800; // dummy
    uut.mem[8] = 32'h04221800;  // sub r3 = r1 - r2     ; r3 = N - i
    uut.mem[9] = 32'h0ce77800; // dummy
    uut.mem[10] = 32'h2863ffff; // addi r3, r3, -1      ; r3 = N - i - 1
    uut.mem[11] = 32'h0ce77800; // dummy
    uut.mem[12] = 32'h00c32800; // add r5, r6, r3       ; r5 = base + (N-i-1)
   

    // temp = mem[r4], mem[r4] = mem[r5], mem[r5] = temp
    uut.mem[13] = 32'h20870000; // lw   r7, 0(r4)
    uut.mem[14] = 32'h20a80000; // lw   r8, 0(r5)
    uut.mem[15] = 32'h0ce77800; // dummy
    uut.mem[16] = 32'h24a70000; // sw   r7, 0(r5)
    uut.mem[17] = 32'h24880000; // sw   r8, 0(r4)
    uut.mem[18] = 32'h0ce77800; // dummy

    // i = i + 1
    uut.mem[19] = 32'h28420001; // addi r2, r2, 1
    uut.mem[20] = 32'h0ce77800; // dummy
    uut.mem[20] = 32'h1041482a; // slt  r9, r2, r1     ; if i < N
    uut.mem[21] = 32'h0ce77800; // dummy
    uut.mem[22] = 32'h34e0ffee; // bneqz r9, -15 ; jump to loop_start

    uut.mem[23] = 32'hfc000000; // hlt

    // Reset processor state
    uut.pc = 0;
    uut.halted = 0;
    uut.taken_branch = 0;

    #2000; // Run simulation
    $display("Memory after reversal:");
    for (k = 100; k < 104; k = k + 1)
      $display("mem[%0d] = %0d", k, uut.mem[k]);
  end

  // VCD waveform dump
  initial begin
    $dumpfile("mips32_tb.vcd");
    $dumpvars(0, mips32_tb6);
    #2000;
    $display("Simulation finished.");
    $finish;
  end

endmodule
