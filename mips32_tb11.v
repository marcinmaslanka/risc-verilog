// ============================================================================
// Testbench: MIPS32 Pipelined Processor – Bubble Sort
//
// Description : Testbench for a simple MIPS32 processor that calculates a^b
//               using repeated multiplication.
//               Registers used:
//               - r1: base (a)
//               - r2: exponent (b)
//               - r3: result = a^b
//               - r4: loop counter
//               - r9: comparison flag for slt
//
// Author: Marcin Maslanka
// 
// ============================================================================

module mips32_tb11;

  reg clk1, clk2;
  integer k;

  mips32 uut(clk1, clk2);

  initial begin
    clk1 = 0; clk2 = 0;
    repeat (200) begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;
      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d | r3=%0d | r4=%0d | r9=%0d",
               $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3], uut.regfile[4], uut.regfile[9]);
    end
  end

  initial begin
    // Clear registers
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = 0;

    // Inputs
    // a = 3, b = 4 → result = 81
    uut.regfile[1] = 3; // base a
    uut.regfile[2] = 4; // exponent b

    // Program
    // r1 = a, r2 = b, r3 = result, r4 = counter
    uut.mem[0] = 32'h28030001; // addi r3, r0, 1     ; result = 1
    uut.mem[1] = 32'h28040000; // addi r4, r0, 0     ; i = 0
    uut.mem[2] = 32'h0ce77800; // dummy

    // LOOP:
    uut.mem[3] = 32'h1082482a; // slt  r9, r4, r2     ; if i < b
    uut.mem[4] = 32'h0ce77800; // dummy
    uut.mem[5] = 32'h39200008; // beqz r9, END
    uut.mem[6] = 32'h0ce77800; // dummy
    uut.mem[7] = 32'h14611800; // mul r3, r3, r1      ; result *= a (assumes pseudo instruction or macro)
    uut.mem[8] = 32'h0ce77800; // dummy
    uut.mem[9] = 32'h28840001; // addi r4, r4, 1      ; i++
    uut.mem[10] = 32'h0ce77800; // dummy
    uut.mem[11] = 32'h3800fff7; // beqz r0, -6         ; loop
    uut.mem[12] = 32'h0ce77800; // dummy
    
    
    uut.mem[13] = 32'hfc000000; // halt

    uut.pc = 0;
    uut.halted = 0;
    uut.taken_branch = 0;

    #2000;
    $display("Finished: a=3, b=4 → a^b=%0d", uut.regfile[3]);
    $finish;
  end

  initial begin
    $dumpfile("mips32_tb.vcd");
    $dumpvars(0, mips32_tb11);
  end
endmodule
