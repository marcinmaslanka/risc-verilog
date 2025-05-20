// ============================================================================
// Testbench: MIPS32 Pipelined Processor – Simple FSM (3-State Traffic Light)
//
// Description:
// - Simulates a simple FSM: RED → GREEN → YELLOW → RED ...
// - Uses state variable in r1 and loops through 3 states
//
// Author: Marcin Maslanka
// ============================================================================
module mips32_tb15;

  reg clk1, clk2;
  integer k;

  mips32 uut(clk1, clk2);

  initial begin
    clk1 = 0; clk2 = 0;
    repeat (200) begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;
      $monitor("t=%0t | pc=%0d | r1=%0d | r2=%0d |r3=%0d |r4=%0d | r5=%0d | r6=%0d | r9=%0d", 
               $time, uut.pc, uut.regfile[1], uut.regfile[2], uut.regfile[3], uut.regfile[4], uut.regfile[5], uut.regfile[6], uut.regfile[9]);
    end
  end

  initial begin
    // Clear registers
    for (k = 0; k < 32; k = k + 1)
      uut.regfile[k] = 0;

    // --- FSM STATE CONSTANTS ---
    uut.mem[0]  = 32'h28020000; // addi r2, r0, 0 ; RED
    uut.mem[1]  = 32'h28030001; // addi r3, r0, 1 ; GREEN
    uut.mem[2]  = 32'h28040002; // addi r4, r0, 2 ; YELLOW

    // --- INITIAL STATE & COUNTER ---
    uut.mem[3]  = 32'h28010000; // addi r1, r0, 0 ; state = RED
    uut.mem[4]  = 32'h28050000; // addi r5, r0, 0 ; counter = 0
    uut.mem[5]  = 32'h28060006; // addi r6, r0, 6 ; max iterations
    uut.mem[6]  = 32'h0ce77800; // dummy

    // --- FSM_LOOP ---
    uut.mem[7]  = 32'h10a64800; // slt r9, r5, r6
    uut.mem[8]  = 32'h0ce77800; // dummy
    uut.mem[9]  = 32'h35200002; // bneqz r9, FSM_CONT
    uut.mem[10]  = 32'h0ce77800; // dummy
    uut.mem[11]  = 32'hfc000000; // halt
    uut.mem[12]  = 32'h0ce77800; // dummy

    // FSM_CONT:
    // Check current state: RED
    uut.mem[13] = 32'h10224800; // slt r9, r1, r2 ; r1 < RED? (never true)
    uut.mem[14] = 32'h0ce77800; // dummy
    uut.mem[15] = 32'h10414800; // slt r9, r2, r1 ; RED < r1?
    uut.mem[16] = 32'h0ce77800; // dummy
    uut.mem[17] = 32'h35200004; // bneqz r9, not_red
    uut.mem[18] = 32'h0ce77800; // dummy

    // state == RED → go to GREEN
    uut.mem[19] = 32'h28010001; // addi r1, r0, 1 ; r1 = GREEN
    uut.mem[20] = 32'h0ce77800; // dummy
    uut.mem[21] = 32'h3800000b; // beqz r0         ;jump next_state
    uut.mem[22] = 32'h0ce77800; // dummy

    // not_red:
    // state == GREEN → go to YELLOW
    uut.mem[23] = 32'h10614800; // slt r9, r3, r1 ; GREEN < r1?
    uut.mem[24] = 32'h0ce77800; // dummy
    uut.mem[25] = 32'h35200005; // bneqz r9, not_green
    uut.mem[26] = 32'h0ce77800; // dummy
    uut.mem[27] = 32'h28010002; // addi r1, r0, 2 ; r1 = YELLOW
    uut.mem[28] = 32'h0ce77800; // dummy
    uut.mem[29] = 32'h38000003; // beqz r0          ;jump next_state
    uut.mem[30] = 32'h0ce77800; // dummy

    // not_green:
    // state == YELLOW → go to RED
    uut.mem[31] = 32'h28010000; // addi r1, r0, 0 ; r1 = RED
    uut.mem[32] = 32'h0ce77800; // dummy

    // next_state:
    uut.mem[33] = 32'h28a50001; // addi r5, r5, 1 ; counter++
    uut.mem[34] = 32'h0ce77800; // dummy
    uut.mem[35] = 32'h3800ffe3; // beqz r0          ;jump FSM_LOOP
    uut.mem[36] = 32'h0ce77800; // dummy

    uut.pc = 0;
    uut.halted = 0;
    uut.taken_branch = 0;

    #3000;
    $display("Finished FSM Testbench");
    $finish;
  end

  initial begin
    $dumpfile("mips32_tb.vcd");
    $dumpvars(0, mips32_tb15);
  end
endmodule
