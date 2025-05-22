// ============================================================================
// Testbench: MIPS32 Pipelined Processor – Find Maximum in Array
// Description:
//   This testbench loads an array from memory and finds the maximum element.
//
//   Input:
//     - memory[99] = N (number of elements)
//     - memory[100...N+99] = array elements
//
//   Output:
//     - r3 = max(array)
//
// Author: Marcin Maslanka
// ============================================================================

module mips32_tb8;

  reg clk1, clk2;
  integer k;

  mips32 uut(clk1, clk2);

  initial begin
    clk1 = 0; clk2 = 0;
    repeat (100) begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;

      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d | r3=%0d (max) | r6=%0d | r7=%0d | r9=%0d | mem[100]=%0d | mem[101]=%0d | mem[102]=%0d | mem[103]=%0d",
               $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3], uut.regfile[6], uut.regfile[7], uut.regfile[9],
               uut.mem[100], uut.mem[101], uut.mem[102], uut.mem[103]);
    end
  end

  initial begin
    // Initialize memory
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = 0;

    uut.mem[99] = 4;         // N = 4
    uut.mem[100] = 2;
    uut.mem[101] = 2;
    uut.mem[102] = 3;
    uut.mem[103] = 2;

    // Program
    uut.mem[0]  = 32'h28010063; // addi r1, r0, 99      ; r1 = addr of N
    uut.mem[1]  = 32'h0ce77800; // dummy
    uut.mem[2]  = 32'h20210000; // lw   r1, 0(r1)       ; r1 = N
    uut.mem[3]  = 32'h28020000; // addi r2, r0, 0       ; r2 = i = 0
    uut.mem[4]  = 32'h28060064; // addi r6, r0, 100     ; r6 = base addr
    uut.mem[5]  = 32'h0ce77800; // dummy
    uut.mem[6]  = 32'h00c23800; // add  r7, r6, r2      ; r7 = base + i
    uut.mem[7]  = 32'h0ce77800; // dummy
    uut.mem[8]  = 32'h20e70000; // lw   r7, 0(r7)       ; r7 = array[0]
    uut.mem[9]  = 32'h0ce77800; // dummy
    uut.mem[10]  = 32'h00e01800; // add  r3, r7, r0      ; r3 = max = array[0]
    
    // LOOP
    uut.mem[11]  = 32'h28420001; // addi r2, r2, 1       ; i++
    uut.mem[12]  = 32'h0ce77800; // dummy
    uut.mem[13]  = 32'h1041482a; // slt  r9, r2, r1      ; if i < N
    uut.mem[14]  = 32'h0ce77800; // dummy
    uut.mem[15]  = 32'h3920000b; // beqz r9, 7         ; exit
    

    // Inside loop
    uut.mem[16] = 32'h00c23800; // add r7, r6, r2       ; r7 = base + i
    uut.mem[17] = 32'h0ce77800; // dummy
    uut.mem[18] = 32'h20e70000; // lw  r7, 0(r7)        ; r7 = array[i]
    uut.mem[19] = 32'h0ce77800; // dummy
    uut.mem[20] = 32'h1067482a; // slt r9, r3, r7       ; if max < array[i]                                                                                                        
    uut.mem[21] = 32'h0ce77800; // dummy
    uut.mem[22] = 32'h39200002; // beqz r9, +2 
    uut.mem[23] = 32'h0ce77800; // dummy
    uut.mem[24] = 32'h00e01800; // add r3, r7, r0       ; r3 = array[i]
    uut.mem[25] = 32'h0ce77800; // dummy
    uut.mem[26] = 32'h3800fff0; // beqz r0, -10         ; jump to LOOP
    uut.mem[27] = 32'h0ce77800; // dummy

    // HALT
    uut.mem[28] = 32'hfc000000;
                                 
    uut.pc = 0;
    uut.halted = 0;                         
    uut.taken_branch = 0;

    #3000;
    $display("Simulation finished: max = %0d", uut.regfile[3]);
    $finish;
  end

  initial begin
    $dumpfile("mips32_tb8.vcd");
    $dumpvars(0, mips32_tb8);
  end

endmodule
