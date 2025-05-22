// ============================================================================
// Testbench: MIPS32 Pipelined Processor
// Description:
//   This testbench instantiates and verifies the functionality of the
//   5-stage pipelined MIPS32 processor by simulating a short program
//   consisting of addi and add instructions, followed by a halt.
//
//   The processor is tested with manually initialized register values and
//   program instructions loaded into memory.
//
// Author: Marcin Maslanka  
// 
// ============================================================================

module mips32_tb;

  // Clock signals for pipeline stages
  reg clk1, clk2;

  // Loop index for initialization and result display
  integer k;

  // Instantiate the Device Under Test (DUT)
  mips32 uut(clk1, clk2);

  // Clock generation: alternating clk1 and clk2
  initial begin
    clk1 = 0;
    clk2 = 0;
    repeat (20) begin
      #5 clk1 = 1; #5 clk1 = 0; // Positive edge of clk1
      #5 clk2 = 1; #5 clk2 = 0; // Positive edge of clk2

      // Display key register and memory values
      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d | r3=%0d |r4=%0d | r5=%0d",
               $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3],uut.regfile[4], uut.regfile[5]);
    end
  end

  // Initial setup: Register values, program instructions, processor state
  initial begin
    // Initialize register file: R0 to R31 = 0 to 31
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = k;

    // Load instruction memory with test program
    uut.mem[0] = 32'h2801000a; // addi r1, r0, 10   ; r1 = 10
    uut.mem[1] = 32'h28020014; // addi r2, r0, 20   ; r2 = 20
    uut.mem[2] = 32'h28030019; // addi r3, r0, 25   ; r3 = 25
    uut.mem[3] = 32'h00222000; // add  r4, r1, r2   ; r4 = r1 + r2 = 30
    uut.mem[4] = 32'h0ce77800; // (dummy/inert instruction)
    uut.mem[5] = 32'h00832800; // add  r5, r4, r3   ; r5 = r4 + r3 = 55
    uut.mem[6] = 32'hfc000000; // hlt              ; halt the processor

    // Reset processor state
    uut.halted = 0;
    uut.pc = 0;
    uut.taken_branch = 0;

    // Wait for simulation to complete
    #280;

    // Display result registers R0 to R5
    for (k = 0; k < 6; k = k + 1)
      $display("R%1d = %2d", k, uut.regfile[k]);
  end

  // VCD waveform generation
  initial begin
    $dumpfile("mips32_tb.vcd");
    $dumpvars(0, mips32_tb);
    #300;
    $display("Simulation finished.");
    $finish;
  end

endmodule
