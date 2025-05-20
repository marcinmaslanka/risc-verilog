// ============================================================================
// Testbench: MIPS32 Pipelined Processor – Manual Logical Shifts (Left/Right)
//
// Description:
// - Performs manual left shift on r1 using repeated addition
// - Performs manual right shift on r1 using subtraction loop
//
// Author: Marcin Maslanka
// ============================================================================
module mips32_tb14;

  reg clk1, clk2;
  integer k;

  mips32 uut(clk1, clk2);

  initial begin
    clk1 = 0; clk2 = 0;
    repeat (200) begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;
      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d | r3=%0d | r4=%0d | r5=%0d | r6=%0d | r7=%0d | r8=%0d | r9=%0d", 
               $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3], uut.regfile[4], uut.regfile[5], uut.regfile[6], uut.regfile[7], uut.regfile[8], uut.regfile[9]);
    end
  end

  initial begin
    // Clear registers
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = 0;

    // -------------------------
    // Manual Logical Left Shift
    // -------------------------
    uut.mem[0]  = 32'h2801001d; // addi r1, r0, 29     ; r1 = 29
    uut.mem[1]  = 32'h28020000; // addi r2, r0, 0      ; r2 = 0 (left shift result)
    uut.mem[2]  = 32'h28030000; // addi r3, r0, 0      ; r3 = 0 (right shift result)
    uut.mem[3]  = 32'h28040000; // addi r4, r0, 0      ; r4 = i (loop index)
    uut.mem[4]  = 32'h28080003; // addi r8, r0, 3      ; shift amount = 3
    uut.mem[5]  = 32'h2802001d; // addi r2, r0, 29     ; r2 = original value
    uut.mem[6]  = 32'h0ce77800; // dummy

    // LSHIFT_LOOP:
    uut.mem[7]  = 32'h10884800; // slt r9, r4, r8
    uut.mem[8]  = 32'h0ce77800; // dummy
    uut.mem[9]  = 32'h35200003; // bneqz r9, do_lshift
    uut.mem[10]  = 32'h0ce77800; // dummy
    uut.mem[11]  = 32'h38000007; // beqz r0, skip_rshift
    uut.mem[12]  = 32'h0ce77800; // dummy

    // do_lshift:
    uut.mem[13] = 32'h00421000; // add r2, r2, r2      ; r2 *= 2
    uut.mem[14] = 32'h0ce77800; // dummy
    uut.mem[15] = 32'h28840001; // addi r4, r4, 1      ; i++
    uut.mem[16] = 32'h0ce77800; // dummy
    uut.mem[17] = 32'h3800fff5; // beqz r0, LSHIFT_LOOP
    uut.mem[18] = 32'h0ce77800; // dummy

    // -------------------------
    // Manual Logical Right Shift
    // -------------------------
    // skip_rshift:
    uut.mem[19] = 32'h2805001d; // addi r5, r0, 29     ; r5 = original value
    uut.mem[20] = 32'h28060000; // addi r6, r0, 0      ; r6 = i
    uut.mem[21] = 32'h28070000; // addi r7, r0, 0      ; r7 = temp result

    // RSHIFT_LOOP:
    uut.mem[22] = 32'h10c84800; // slt r9, r6, r8
    uut.mem[23] = 32'h0ce77800; // dummy
    uut.mem[24] = 32'h35200003; // bneqz r9, do_rshift
    uut.mem[25] = 32'h0ce77800; // dummy
    uut.mem[26] = 32'h3800001f; // beqz r0, done
    uut.mem[27] = 32'h0ce77800; // dummy

    // do_rshift:
    uut.mem[28] = 32'h28a9fffe; // addi r9, r5, -2
    uut.mem[29] = 32'h0ce77800; // dummy
    uut.mem[30] = 32'h30e90000; // slti r9, r9, 0
    uut.mem[31] = 32'h0ce77800; // dummy
    uut.mem[32] = 32'h35200004; // bneqz r9, skip_sub
    uut.mem[33] = 32'h0ce77800; // dummy
    uut.mem[34] = 32'h28a5fffe; // addi r5, r5, -2
    uut.mem[35] = 32'h28e70001; // addi r7, r7, 1
    uut.mem[36] = 32'h0ce77800; // dummy

    // skip_sub:
    uut.mem[37] = 32'h28c60001; // addi r6, r6, 1
    uut.mem[38] = 32'h0ce77800; // dummy
    uut.mem[39] = 32'h3800ffee; // beqz r0, RSHIFT_LOOP
    uut.mem[40] = 32'h0ce77800; // dummy

    // done:
    uut.mem[41] = 32'h00e01800; // add r3, r7, r0      ; r3 = shifted result
    uut.mem[42] = 32'h0ce77800; // dummy
    uut.mem[43] = 32'hfc000000; // halt

    uut.pc = 0;
    uut.halted = 0;
    uut.taken_branch = 0;

    #3000;
    $display("Finished: LSHIFT(r1)<<3 = %0d | RSHIFT(r1)>>3 = %0d", uut.regfile[2], uut.regfile[3]);
    $finish;
  end

  initial begin
    $dumpfile("mips32_tb.vcd");
    $dumpvars(0, mips32_tb14);
  end
endmodule
