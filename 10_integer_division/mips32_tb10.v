// ============================================================================
// Testbench: MIPS32 Pipelined Processor – Bubble Sort
//
// Description : This testbench verifies a MIPS32 processor implementation by
//               performing integer division (quotient and remainder) of two
//               values stored in memory. It uses a subtraction loop to emulate
//               division: a = 23, b = 5 → a / b = 4 (quotient), 3 (remainder).
//
//               Registers used:
//               - r1: dividend (a)
//               - r2: divisor (b)
//               - r3: quotient
//               - r4: remainder
//               - r5: temporary pointer to memory
//               - r8: result of comparison (slt)
//
// Author: Marcin Maslanka
// 
// ============================================================================


module mips32_tb10;

  reg clk1, clk2;
  integer k;

  mips32 uut(clk1, clk2);

  initial begin
    clk1 = 0; clk2 = 0;
    repeat (70) begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;
      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d | r3=%0d | r4=%0d | r5=%0d | r6=%0d | r8=%0d | mem[100]=%0d | mem[101]=%0d",
               $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3], uut.regfile[4], uut.regfile[5], uut.regfile[6], uut.regfile[8],
               uut.mem[100], uut.mem[101]);
    end
  end

  initial begin
    // Clear registers
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = 0;

     // Initialize memory: store a and b
    uut.mem[100] = 23; // a = dividend
    uut.mem[101] = 5;  // b = divisor

    // Program:
    uut.mem[0] = 32'h28050064; // addi r5, r0, 100   ; r5 = address of a
    uut.mem[1] = 32'h0ce77800; // dummy
    uut.mem[2] = 32'h20a10000; // lw   r1, 0(r5)      ; r1 = a
    uut.mem[3] = 32'h0ce77800; // dummy
    uut.mem[4] = 32'h28050065; // addi r5, r0, 101   ; r5 = address of b
    uut.mem[5] = 32'h0ce77800; // dummy
    uut.mem[6] = 32'h20a20000; // lw   r2, 0(r5)      ; r2 = b
    uut.mem[7] = 32'h28030000; // addi r3, r0, 0      ; r3 = 0 (quotient)
    uut.mem[8] = 32'h0ce77800; // dummy

    //DIV_LOOP:
    uut.mem[9]  = 32'h10224000; // slt  r8, r1, r2      ; if a < b
    uut.mem[10] = 32'h0ce77800; // dummy
    uut.mem[11] = 32'h35000007; // beqz r8, EXIT        ; if !(b < a) goto DONE
    uut.mem[12] = 32'h0ce77800; // dummy
    uut.mem[13] = 32'h04220800; // sub  r1, r1, r2      ; a = a - b
    uut.mem[14] = 32'h0ce77800; // dummy
    uut.mem[15] = 32'h28630001; // addi r3, r3, 1       ; quotient++
    uut.mem[16] = 32'h0ce77800; // dummy
    uut.mem[17] = 32'h3800fff7; // beqz r0, -5          ; goto DIV_LOOP
    uut.mem[18] = 32'h0ce77800; // dummy

    //DONE:
    uut.mem[19] = 32'h00202000; // add r4, r1, r0; // remainder = a
    uut.mem[20] = 32'hfc000000; // halt

    uut.pc = 0;
    uut.halted = 0;
    uut.taken_branch = 0;

    #2000;
    $display("Finished: a=23, b=5 → quotient=%0d, remainder=%0d", uut.regfile[3], uut.regfile[4]);
    $finish;
  end

  initial begin
    $dumpfile("mips32_tb.vcd");
    $dumpvars(0, mips32_tb10);
  end
endmodule
