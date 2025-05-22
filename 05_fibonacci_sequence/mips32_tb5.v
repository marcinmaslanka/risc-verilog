// ============================================================================
// Testbench: MIPS32 Pipelined Processor - Fibonacci Sequence
// Description:
//   This testbench verifies the MIPS32 processor by computing the first N Fibonacci numbers.
//   The value of N is stored in memory, and the computed Fibonacci numbers are stored in another memory location.
//
// Author: Marcin Maslanka  
// 
// ============================================================================

module mips32_tb5;

  // Clock signals for pipeline stages
  reg clk1, clk2;

  // Loop index for initialization
  integer k;

  // Instantiate the Device Under Test (DUT)
  mips32 uut(clk1, clk2);

  // Clock generation
  initial begin
    clk1 = 0; clk2 = 0;
    repeat (200) 
    begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;

      // Display key register and memory values
      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d | r3=%0d | r4=%0d | r5=%0d | r6=%0d | r7=%0d | mem[200]=%0d",
               $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3], uut.regfile[4], uut.regfile[5], uut.regfile[6], uut.regfile[7], uut.mem[200]);

    end
  end

  // Program: Fibonacci sequence calculation
  initial begin
    // Initialize registers
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = 0;

    // Load N into memory[100] (N = 10 → first 10 Fibonacci numbers)
    uut.mem[100] = 10;  // N = 10

    // Instruction memory setup
    uut.mem[0]  = 32'h28010064; // addi r1, r0, 100         ; r1 = 100 (mem addr)
    uut.mem[1]  = 32'h0ce77800; // dummy   
    uut.mem[2]  = 32'h20210000; // lw   r1, 0(r1)           ; r1 = mem[100] = N
    uut.mem[3]  = 32'h28020000; // addi r2, r0, 0           ; r2 = i = 0
    uut.mem[4]  = 32'h28030000; // addi r3, r0, 0           ; r3 = Fib(i-1) = 0
    uut.mem[5]  = 32'h28040001; // addi r4, r0, 1           ; r4 = Fib(i-2) = 1
    uut.mem[6]  = 32'h280600c8; // addi r6, r0, 200         ; r6 = address pointer (mem[200])
    uut.mem[7]  = 32'h0ce77800; // dummy

    // loop:
    
             
    uut.mem[8]  = 32'h00642800; // add  r5, r3, r4          ; r5 = Fib(i) = Fib(i-1) + Fib(i-2)
    uut.mem[9]  = 32'h0ce77800; // dummy
    uut.mem[10] = 32'h24c50000; // sw   r5, 0(r6)           ; mem[200] = Fib(i)
    uut.mem[11] = 32'h0ce77800; // dummy
    uut.mem[12] = 32'h00801800; // add r3 = r4 + r0
    uut.mem[13] = 32'h0ce77800; // dummy 
    uut.mem[14] = 32'h00a02000; // add r4 = r5 + r0
    uut.mem[15] = 32'h0ce77800; // dummy
    uut.mem[16] = 32'h28420001; // addi r2, r2, 1           ; i++
    uut.mem[17] = 32'h0ce77800; // dummy
    uut.mem[18] = 32'h28c60001; // addi r6, r6, 1           ; mem addr++
    uut.mem[19] = 32'h0ce77800; // dummy
    uut.mem[20] = 32'h1041382a; // slt  r7, r2, r1         ; if i < N → r7 = 1
    uut.mem[21] = 32'h0ce77800; // dummy
    uut.mem[22] = 32'h34e0fff1; // bneqz r7, -9             ; if r7 = 0, goto loop

    uut.mem[23] = 32'hfc000000; // hlt                      ; halt

    // Reset processor state
    uut.pc = 0;
    uut.halted = 0;
    uut.taken_branch = 0;

    #5000; // Let the simulation run

    // Show result
    $display("Fibonacci sequence stored in memory[200] (expected 55 numbers).");
  end

  // VCD waveform dump
  initial begin
    $dumpfile("mips32_tb5.vcd");
    $dumpvars(0, mips32_tb5);
    #5000;
    $display("Simulation finished.");
    $finish;
  end

endmodule
