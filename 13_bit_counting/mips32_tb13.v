// ============================================================================
// Testbench: MIPS32 Pipelined Processor – Count Set Bits
//
// Description : This testbench counts the number of set bits (1’s) in a
//               register using bitwise AND and shift operations.
//
//               - r1: Value to count bits from
//               - r2: Count of set bits
//               - r3: Loop index (0 to 31)
//               - r4: Temporary register for AND
//               - r5: Copy of r1 for shifting
//
// Author      : Marcin Maslanka
// ============================================================================
module mips32_tb13;

  reg clk1, clk2;
  integer k;

  mips32 uut(clk1, clk2);

  initial begin
    clk1 = 0; clk2 = 0;
    repeat (5000) begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;
      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d | r3=%0d | r4=%0d | r5=%0d | r6=%0d | r7=%0d |  r8=%0d | r9=%0d | r10=%0d",               
      $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3], uut.regfile[4], uut.regfile[5], uut.regfile[6], uut.regfile[7], uut.regfile[8], uut.regfile[9], uut.regfile[10]);
    end
  end

  initial begin
    // Clear registers
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = 0;

    // Initialize program: Count set bits in r1 = 29 (binary: 0001 1101 → 4 bits set)
    uut.mem[0]  = 32'h2801001d; // addi r1, r0, 29        ;1d
    uut.mem[1]  = 32'h28020000; // addi r2, r0, 0      ; count = 0
    uut.mem[2]  = 32'h28030000; // addi r3, r0, 0      ; i = 0
    uut.mem[3]  = 32'h2805001d; // addi r5, r0, 29     ; copy of r1
    uut.mem[4]  = 32'h280a0001; // addi r10, r0, 1     ; constant 1
    uut.mem[5]  = 32'h0ce77800; // dummy

    // LOOP:
    uut.mem[6]  = 32'h08aa2000; // and r4, r5, r10      ; r4 = r5 & 1
    uut.mem[7]  = 32'h0ce77800; // dummy
    uut.mem[8]  = 32'h38800003; // beqz r4, SKIP_INC
    uut.mem[9]  = 32'h0ce77800; // dummy
    uut.mem[10] = 32'h28420001; // addi r2, r2, 1      ; count++
    uut.mem[11] = 32'h0ce77800; // dummy

    // SKIP_INC:
    uut.mem[12] = 32'h28630001; // addi r3, r3, 1      ; i++
    uut.mem[13] = 32'h28080008; // addi r8, r0, 8     ; upper bound
    uut.mem[14] = 32'h0ce77800; // dummy
    uut.mem[15] = 32'h10684800; // slt  r9, r3, r8
    uut.mem[16] = 32'h0ce77800; // dummy
    uut.mem[17] = 32'h39200014; // bneqz r9, DONE
    uut.mem[18] = 32'h0ce77800; // dummy

    // Right shift r5 by 1 implemented as division by 2
    uut.mem[19] = 32'h28a6fffe; // addi r6, r5, -2
    uut.mem[20] = 32'h0ce77800; // dummy
    uut.mem[21] = 32'h30c60000; // slti r6, r6, 0      ; r6 < 0 ? 
    uut.mem[22] = 32'h0ce77800; // dummy
    uut.mem[23] = 32'h34c00007; // bneqz r6, +8
    uut.mem[24] = 32'h0ce77800; // dummy
    uut.mem[25] = 32'h28a5fffe; // addi r5, r5, -2
    uut.mem[26] = 32'h0ce77800; // dummy
    uut.mem[27] = 32'h28e70001; // addi r7, r7, 1      ; r7++
    uut.mem[28] = 32'h0ce77800; // dummy
    uut.mem[29] = 32'h3800fff5; // beqz r0, -10        ; unconditional jump
    uut.mem[30] = 32'h0ce77800; // dummy
    
    // Result of Division
    uut.mem[31] = 32'h00e02800; // add r5 r7 r0       ; r5 = r7
    uut.mem[32] = 32'h0ce77800; // dummy
    uut.mem[33] = 32'h28070000; // addi r7 r0 0      ; r7 = 0
    uut.mem[34] = 32'h0ce77800; // dummy
    uut.mem[35] = 32'h3800ffe2; // beqz r0, LOOP
    uut.mem[36] = 32'h0ce77800; // dummy

    // DONE:
    uut.mem[37] = 32'hfc000000; // halt

    uut.pc = 0;
    uut.halted = 0;
    uut.taken_branch = 0;

    #10000;
    $display("Finished: Number of 1’s in r1 = %0d", uut.regfile[2]);
    $finish;
  end

  initial begin
    $dumpfile("mips32_tb.vcd");
    $dumpvars(0, mips32_tb13);
  end
endmodule
