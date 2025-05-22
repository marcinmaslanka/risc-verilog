// ============================================================================
// Testbench: MIPS32 Pipelined Processor – Bubble Sort
// Description:
//   This testbench sorts a small array of integers using bubble sort.
//
//   Input:
//     - memory[99] = N (number of elements)
//     - memory[100...N+99] = array elements
//
//   Output:
//     - Sorted array in memory[100...N+99]
//
// Author: Marcin Maslanka
// 
// ============================================================================

module mips32_tb9;

  reg clk1, clk2;
  integer k;

  mips32 uut(clk1, clk2);

  initial begin
    clk1 = 0; clk2 = 0;
    repeat (500) begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;

      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d | r3=%0d | r4=%0d | r5=%0d| r6=%0d | r7=%0d | r8=%0d | r9=%0d | mem[100]=%0d | mem[101]=%0d | mem[102]=%0d | mem[103]=%0d", 
               $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3], uut.regfile[4], uut.regfile[5], uut.regfile[6], uut.regfile[7], uut.regfile[8], uut.regfile[9],
               uut.mem[100], uut.mem[101], uut.mem[102], uut.mem[103]);
    end
  end

  initial begin
    // Initialize register file
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = 0;

    // Initialize memory
    uut.mem[99]  = 4;         // N = 4
    uut.mem[100] = 10;
    uut.mem[101] = 25;
    uut.mem[102] = 50;
    uut.mem[103] = 20;

    // Program
    uut.mem[0]  = 32'h28050063; // addi r5, r0, 99     ; r5 = addr of N
    uut.mem[1]  = 32'h0ce77800; // dummy
    uut.mem[2]  = 32'h20a50000; // lw   r5, 0(r5)      ; r5 = N
    uut.mem[3]  = 32'h28060064; // addi r6, r0, 100    ; r6 = base addr

    // Outer loop: i = 0
    uut.mem[4]  = 32'h28010000; // addi r1, r0, 0
    uut.mem[5]  = 32'h0ce77800; // dummy

    // OUTER_LOOP:
    uut.mem[6]  = 32'h1025482a; // slt  r9, r1, r5     ; if i < N
    //uut.mem[6]  = 32'h28090000; // addi r9,r0, 0        ; test
    uut.mem[7]  = 32'h0ce77800; // dummy
    uut.mem[8]  = 32'h39200036; // beqz r9, END        ; EXIT
    uut.mem[9]  = 32'h28020000; // addi r2, r0, 0      ; j = 0
    uut.mem[10] = 32'h0ce77800; // dummy

    // INNER_LOOP:
    uut.mem[11] = 32'h04a14800; // sub r9, r5, r1
    uut.mem[12] = 32'h0ce77800; // dummy
    uut.mem[13] = 32'h2929ffff; // addi r9, r9, -1
    uut.mem[14] = 32'h0ce77800; // dummy
    uut.mem[15] = 32'h1049482a; // slt  r9, r2, r9     ; if j < N - i - 1
    //uut.mem[15] = 32'h28090000; // addi r9,r0, 0        ; test
    uut.mem[16] = 32'h0ce77800; // dummy
    uut.mem[17] = 32'h39200016; // beqz r9, INCR_I     ; if not, increment i
    uut.mem[18] = 32'h00c23800; // add  r7, r6, r2     ; r7 = base + j
    uut.mem[19] = 32'h0ce77800; // dummy
    uut.mem[20] = 32'h20e30000; // lw   r3, 0(r7)      ; r3 = A[j]
    uut.mem[21] = 32'h28490001; // addi r9, r2, 1      ; r9 = j + 1
    uut.mem[22] = 32'h0ce77800; // dummy
    uut.mem[23] = 32'h00c94800; // add  r9, r6, r9     ; r9 = base + j + 1
    uut.mem[24] = 32'h0ce77800; // dummy
    uut.mem[25] = 32'h29280000; // addi r8, r9,0      ; 
    uut.mem[26] = 32'h21240000; // lw   r4, 0(r9)      ; r4 = A[j+1]
    uut.mem[27] = 32'h0ce77800; // dummy
    uut.mem[28] = 32'h1083482a; // slt  r9, r4, r3     ; if A[j+1] < A[j]
    //uut.mem[27] = 32'h28090000; // addi r9,r0, 0        ; test
    uut.mem[29] = 32'h0ce77800; // dummy
    uut.mem[30] = 32'h39200005; // beqz r9, SKIP_SWAP  ; if not, skip swap
    uut.mem[31] = 32'h0ce77800; // dummy
    uut.mem[32] = 32'h24e40000; // sw   r4, 0(r7)      ; A[j] = A[j+1]
    uut.mem[33] = 32'h0ce77800; // dummy
    uut.mem[34] = 32'h25030000; // sw   r3, 0(r8)      ; A[j+1] = A[j]
    uut.mem[35] = 32'h0ce77800; // dummy
    
    // SKIP_SWAP:
    uut.mem[36] = 32'h28420001; // addi r2, r2, 1      ; j++
    uut.mem[37] = 32'h0ce77800; // dummy
    uut.mem[38] = 32'h3800ffe4; // beqz r0, -27        ; goto INNER_LOOP
    uut.mem[39] = 32'h0ce77800; // dummy

    // INCR_I:
    uut.mem[40] = 32'h28210001; // addi r1, r1, 1       ; i++
    uut.mem[41] = 32'h0ce77800; // dummy
    uut.mem[42] = 32'h3800ffdb; // beqz r0, -dc            ; goto OUTER_LOOP
    uut.mem[43] = 32'h0ce77800; // dummy

    // END:
    uut.mem[44] = 32'hfc000000; // halt

    uut.pc = 0;
    uut.halted = 0;
    uut.taken_branch = 0;

    #5000;
    $display("Simulation finished: sorted array = %0d, %0d, %0d, %0d",
             uut.mem[100], uut.mem[101], uut.mem[102], uut.mem[103]);
    $finish;
  end

  initial begin
    $dumpfile("mips32_tb9.vcd");
    $dumpvars(0, mips32_tb9);
  end

endmodule
