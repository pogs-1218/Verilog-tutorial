#include <cstdio>

#include "obj_dir/Vtxuart_wrapper.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#define CLOCK_RATE_HZ 100000000  // 100Mhz
#define BAUDRATE 115200          // 115,200bps

unsigned int tick_count = 0;

void tick(Vtxuart_wrapper* tb, VerilatedVcdC* tfp);

int main(int argc, char** argv) {
  VerilatedContext* context = new VerilatedContext();
  VerilatedVcdC* tfp = new VerilatedVcdC();
  Vtxuart_wrapper* tb = new Vtxuart_wrapper(context);
  context->commandArgs(argc, argv);

  context->traceEverOn(true);
  tb->trace(tfp, 99);
  tfp->open("");

  bool on_receiving = false;
  unsigned int clocks_per_baud = CLOCK_RATE_HZ / BAUDRATE;
  unsigned int clock_counter = 0;
  unsigned int bits = 0;
  unsigned int byte_count = 0;
  unsigned int internal_count = 0;
  for (int i = 0; i < 10 * clocks_per_baud + CLOCK_RATE_HZ; i++) {
    if (tb->status) {
      // printf("tick: %d\n", tick_count);
      if (!on_receiving && (tb->out) == 0) {
        printf("start?\n");
        on_receiving = true;
      }
      if (on_receiving) {
        // printf("tick: %d\n", tick_count);
        clock_counter++;
        if (clock_counter == clocks_per_baud / 2) {
          bits++;
          printf("%d ---------- catch: %d\n", tick_count, tb->out);
          clock_counter = 0;
        }
      }
    }
    // read ... how?
    // In warpper, to send 'h', 8-bits * clocks per baud
    // At least, 8 * 868 + 100,000,000

    tick(tb, tfp);
  }

  return 0;
}

void tick(Vtxuart_wrapper* tb, VerilatedVcdC* tfp) {
  tick_count++;
  tb->clk = 1;
  tb->eval();
  tb->clk = 0;
  tb->eval();
}