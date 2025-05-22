// ============================================================================
// Testbench: MIPS32 Pipelined Processor – Array Sum and Average
// Description:
//   This testbench verifies the MIPS32 processor by summing the elements of an
//   array stored in memory and computing the average (integer division).
//   The array begins at memory address 100, and its length is stored in memory[99].
//
//   Result:
//     - Sum is stored in register r3
//     - Average is stored in register r4
//
// Author: Marcin Maslanka
// 
// 
// ============================================================================

module mips32_tb7;

  reg clk1, clk2;
  integer k;

  wire signed [31:0] signed_r5;
  assign signed_r5 = $signed(uut.regfile[5]);


  mips32 uut(clk1, clk2);

  initial begin
    clk1 = 0; clk2 = 0;
    repeat (500) begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;

      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d | r3=%0d | r4=%0d | r5=%0d | r6=%0d | r7=%0d | r9=%0d | mem[100]=%0d | mem[101]=%0d | mem[102]=%0d | mem[103]=%0d",
               $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3], uut.regfile[4], signed_r5, uut.regfile[6], uut.regfile[7], uut.regfile[9], uut.mem[100], uut.mem[101], uut.mem[102], uut.mem[103]);
    end
  end

  initial begin
    // Clear registers
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = 0;

    // Data: N = 4, Array = [10, 20, 30, 40]
    uut.mem[99] = 4;
    uut.mem[100] = 5;
    uut.mem[101] = 20;
    uut.mem[102] = 30;
    uut.mem[103] = 40;

    // Program
    uut.mem[0]  = 32'h28010063; // addi r1, r0, 99      ; r1 = addr of N
    uut.mem[1]  = 32'h0ce77800; // dummy
    uut.mem[2]  = 32'h20210000; // lw   r1, 0(r1)       ; r1 = N
    uut.mem[3]  = 32'h28020000; // addi r2, r0, 0       ; r2 = i = 0
    uut.mem[4]  = 32'h28030000; // addi r3, r0, 0       ; r3 = sum = 0
    uut.mem[5]  = 32'h28060064; // addi r6, r0, 100     ; r6 = base address
    uut.mem[6]  = 32'h0ce77800; // dummy

    // LOOP_START:
    uut.mem[7]  = 32'h00c23800; // add r7, r6, r2  ; r7 = base + i
    uut.mem[8]  = 32'h0ce77800; // dummy
    uut.mem[9]  = 32'h20e70000; // lw r7, 0(r7)         ; r7 = mem[base + i]
    uut.mem[10] = 32'h0ce77800; // dummy
    uut.mem[11] = 32'h00671800; // add r3, r3, r7       ; sum += mem[i]
    uut.mem[12] = 32'h28420001; // addi r2, r2, 1       ; i++
    uut.mem[13] = 32'h0ce77800; // dummy
    uut.mem[14] = 32'h1041482a; // slt r9, r2, r1       ; if i < N
    uut.mem[15] = 32'h0ce77800; // dummy
    uut.mem[16] = 32'h3520fff5; // bneqz r9, -6         ; loop back
    
    // Store sum in r10
    uut.mem[17] = 32'h00605000; // add r10= r3 + r0
    uut.mem[18] = 32'h0ce77800; // dummy

    // Average = sum / N
    uut.mem[19] = 32'h28040000; // addi r4, r0, 0      ; r4 = 0 (quotient)
    //loop:
    uut.mem[20] = 32'h04612800; // sub  r5, r3, r1     ; r5 = r3 - r1
    uut.mem[21] = 32'h0ce77800; // dummy
    uut.mem[22] = 32'h30a50000; // slti r5, r5, 0      ; r5 < 0 ? 
    uut.mem[23] = 32'h0ce77800; // dummy
    uut.mem[24] = 32'h38a00002; // beqz r5, +2
    uut.mem[25] = 32'h0ce77800; // dummy

    // Halt
    uut.mem[26] = 32'hfc000000; // hlt

    uut.mem[27] = 32'h04611800; // sub  r3, r3, r1     ; r3 = r3 - r1
    uut.mem[28] = 32'h0ce77800; // dummy
    uut.mem[29] = 32'h28840001; // addi r4, r4, 1      ; r4++
    uut.mem[30] = 32'h0ce77800; // dummy
    uut.mem[31] = 32'h3800fff4; // beqz r0, -10        ; unconditional jump to loop


    

    uut.pc = 0;
    uut.halted = 0;
    uut.taken_branch = 0;

    #8000;
    $display("Simulation finished: sum = %0d, avg = %0d", uut.regfile[10], uut.regfile[4]);
    $finish;
  end

  initial begin
    $dumpfile("mips32_tb_avg.vcd");
    $dumpvars(0, mips32_tb7);
  end

endmodule
