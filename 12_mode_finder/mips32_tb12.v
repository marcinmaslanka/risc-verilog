// ============================================================================
// Testbench: MIPS32 Pipelined Processor – Mode / Frequency Count
//
// Description : This testbench tests a MIPS32 processor by calculating
//               the mode (most frequent number) from a small dataset
//               stored in memory at addresses 100–107.
//
//               - r1: Outer loop index (i)
//               - r2: Inner loop index (j)
//               - r3: Count for current value
//               - r4: Mode value
//               - r5: Max frequency
//               - r6: Data value being compared
//               - r7: Temporary value for comparisons
//
// Author      : Marcin Maslanka
// ============================================================================
module mips32_tb12;

  reg clk1, clk2;
  integer k;

  mips32 uut(clk1, clk2);

  initial begin
    clk1 = 0; clk2 = 0;
    repeat (5000) begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;
      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d | r3=%0d | r4=%0d | r5=%0d | r6=%0d | r7=%0d | r8=%0d | r9=%0d | r10=%0d",
               $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3], uut.regfile[4],uut.regfile[5], uut.regfile[6], uut.regfile[7], uut.regfile[8], uut.regfile[9], uut.regfile[10]);
    end
  end

  initial begin
    // Clear registers
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = 0;

    // Load sample dataset into memory
    uut.mem[100] = 1;
    uut.mem[101] = 2;
    uut.mem[102] = 3;
    uut.mem[103] = 4;
    uut.mem[104] = 8;
    uut.mem[105] = 6;
    uut.mem[106] = 7;
    uut.mem[107] = 8;

    // --- Program begins ---
    // Outer loop: for each i = 0 to 7
    //  r1: i
    //  r6: value = mem[100 + i]
    //  r3: count = 0
    //  Inner loop: for each j = 0 to 7
    //  r2: j
    //  r7: value = mem[100 + j]
    //    if value == mem[100 + j] → count++
    //  if count > max_count → max_count = count, mode = value
    //  i++
    //  if i < 8 → repeat outer loop
    //  Done: halt

    // Initialize constants
    uut.mem[0]  = 32'h28010000; // addi r1, r0, 0        ; i = 0
    uut.mem[1]  = 32'h28040000; // addi r4, r0, 0        ; mode = 0
    uut.mem[2]  = 32'h28050000; // addi r5, r0, 0        ; max_count = 0
    uut.mem[3]  = 32'h0ce77800; // dummy

    // OUTER_LOOP:
    uut.mem[4]  = 32'h28060000; // addi r6, r0, 0        ; clear value
    uut.mem[5]  = 32'h28020000; // addi r2, r0, 0        ; j = 0
    uut.mem[6]  = 32'h0ce77800; // dummy
    uut.mem[7]  = 32'h280a0064; // addi r10, r0, 100      ; base address
    uut.mem[8]  = 32'h0ce77800; // dummy
    uut.mem[9]  = 32'h01413000; // add  r6, r10, r1       ; addr = 100 + i
    uut.mem[10]  = 32'h0ce77800; // dummy
    uut.mem[11]  = 32'h20c60000; // lw   r6, 0(r6)        ; r6 = mem[100 + i]
    uut.mem[12]  = 32'h0ce77800; // dummy
    uut.mem[13]  = 32'h28030000; // addi r3, r0, 0        ; count = 0
    uut.mem[14]  = 32'h0ce77800; // dummy

    // INNER_LOOP:
    uut.mem[15] = 32'h0ce77800; // dummy
    uut.mem[16] = 32'h0ce77800; // dummy
    uut.mem[17] = 32'h01423800; // add r7, r10, r2        ; r7 = 100 + j
    uut.mem[18] = 32'h0ce77800; // dummy
    uut.mem[19] = 32'h20e70000; // lw r7, 0(r7)
    uut.mem[20] = 32'h0ce77800; // dummy
    uut.mem[21] = 32'h04e64800; // sub  r9, r7, r6     ; r9 = r7 - r6
    uut.mem[22] = 32'h0ce77800; // dummy
    uut.mem[23] = 32'h39200009; // beqz r9, +9         ; jump to INC
    uut.mem[24] = 32'h0ce77800; // dummy
    uut.mem[25] = 32'h28420001; // addi r2, r2, 1        ; j++
    uut.mem[26] = 32'h0ce77800; // dummy
    uut.mem[27] = 32'h30480008; // slti r8, r2, 8
    uut.mem[28] = 32'h0ce77800; // dummy
    uut.mem[29] = 32'h39000007; // beqz r8, COMPARE
    uut.mem[30] = 32'h0ce77800; // dummy
    uut.mem[31] = 32'h3800fff1; // beqz r0, -16        ; jump back to INNER_LOOP [15]
    uut.mem[32] = 32'h0ce77800; // dummy

    // INC:
    uut.mem[33] = 32'h28630001; // addi r3, r3, 1        ; count++
    uut.mem[34] = 32'h0ce77800; // dummy
    uut.mem[35] = 32'h3800fff5; // beqz r0    ;jump back to inner loop [26]
    uut.mem[36] = 32'h0ce77800; // dummy

    // COMPARE count to max
    uut.mem[37] = 32'h10a34000; // slt r8, r5, r3        ; if max_count < count
    uut.mem[38] = 32'h0ce77800; // dummy
    uut.mem[39] = 32'h39000005; // beqz r8, SKIP_UPDATE
    uut.mem[40] = 32'h0ce77800; // dummy
    uut.mem[41] = 32'h28650000; // addi r5, r3, 0        ; max_count = count
    uut.mem[42] = 32'h0ce77800; // dummy
    uut.mem[43] = 32'h28c40000; // addi r4, r6, 0        ; mode = value
    uut.mem[44] = 32'h0ce77800; // dummy

    // SKIP_UPDATE:
    uut.mem[45] = 32'h28210001; // addi r1, r1, 1        ; i++
    uut.mem[46] = 32'h0ce77800; // dummy
    uut.mem[47] = 32'h30280008; // slti r8, r1, 8
    uut.mem[48] = 32'h0ce77800; // dummy
    uut.mem[49] = 32'h3500ffd2; // bneqz r8, OUTER_LOOP
    uut.mem[50] = 32'h0ce77800; // dummy

    // DONE
    uut.mem[51] = 32'hfc000000; // halt

    // Init CPU state
    uut.pc = 0;
    uut.halted = 0;
    uut.taken_branch = 0;

    #26000;
    $display("Finished: mode=%0d with frequency=%0d", uut.regfile[4], uut.regfile[5]);
    $finish;
  end

  initial begin
    $dumpfile("mips32_tb.vcd");
    $dumpvars(0, mips32_tb12);
  end
endmodule
