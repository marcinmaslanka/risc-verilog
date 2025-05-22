// ============================================================================
// Testbench: MIPS32 Pipelined Processor – Caesar Cipher Encryption
// Description : Encrypts ASCII characters using Caesar Cipher with a shift of 3.
//
// Author: Marcin Maslanka
// ============================================================================
module mips32_tb16;

  reg clk1, clk2;
  integer k;

  mips32 uut(clk1, clk2);

  initial begin
    clk1 = 0; clk2 = 0;
    repeat (200) begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;
      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d | r3=%0d | r4=%0d | r5=%0d | r6=%0d | r7=%0d |  mem[100]=%0d | mem[101]=%0d | mem[102]=%0d", 
               
      $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3], uut.regfile[4], uut.regfile[5], uut.regfile[6], uut.regfile[7], 
               uut.mem[100], uut.mem[101], uut.mem[102]);
    end
  end

  initial begin
    // Clear registers
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = 0;

    // Input string at memory[100-102]: A (65), B (66), C (67)
    uut.mem[100] = 65;
    uut.mem[101] = 66;
    uut.mem[102] = 67;

    // Program to encrypt the string using Caesar cipher (key = 3)
    uut.mem[0]  = 32'h28010064; // addi r1, r0, 100     ; base addr
    uut.mem[1]  = 32'h28020000; // addi r2, r0, 0       ; index
    uut.mem[2]  = 32'h28030003; // addi r3, r0, 3       ; key
    uut.mem[3]  = 32'h28060003; // addi r6, r0, 3       ; upper bound
    uut.mem[4]  = 32'h0ce77800; // dummy

    // LOOP:
    uut.mem[5]  = 32'h00222000; // add r4, r1, r2       ; addr = base + index
    uut.mem[6]  = 32'h0ce77800; // dummy
    uut.mem[7]  = 32'h20850000; // lw r5, 0(r4)         ; r5 = mem[addr]
    uut.mem[8]  = 32'h0ce77800; // dummy
    uut.mem[9]  = 32'h00a32800; // add r5, r5, r3       ; r5 = r5 + key
    uut.mem[10]  = 32'h0ce77800; // dummy
    uut.mem[11]  = 32'h24850000; // sw r5, 0(r4)         ; store encrypted char
    uut.mem[12]  = 32'h0ce77800; // dummy
    uut.mem[13]  = 32'h28420001; // addi r2, r2, 1       ; i++
    uut.mem[14]  = 32'h0ce77800; // dummy
    uut.mem[15]  = 32'h10463800; // slt r7 r2, r6       ; compare i with upper bound
    uut.mem[16]  = 32'h0ce77800; // dummy
    uut.mem[17]  = 32'h34e0fff3; // bneqz r7, LOOP       ; loop if i < 3
    uut.mem[18]  = 32'h0ce77800; // dummy

    uut.mem[19] = 32'hfc000000; // halt

    uut.pc = 0;
    uut.halted = 0;
    uut.taken_branch = 0;

    #1000;
    $display("Encrypted Characters: %0d, %0d, %0d", uut.mem[100], uut.mem[101], uut.mem[102]);
    $finish;
  end

  initial begin
    $dumpfile("mips32_tb.vcd");
    $dumpvars(0, mips32_tb16);
  end
endmodule
