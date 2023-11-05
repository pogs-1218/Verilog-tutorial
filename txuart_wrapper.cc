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
  // VerilatedVcdC* tfp = new VerilatedVcdC();
  Vtxuart_wrapper* tb = new Vtxuart_wrapper(context);
  context->commandArgs(argc, argv);

  // context->traceEverOn(true);
  // tb->trace(tfp, 99);
  // tfp->open("");

  bool on_receiving = false;
  bool start = false;
  unsigned int clocks_per_baud = CLOCK_RATE_HZ / BAUDRATE;
  unsigned int clock_counter = 0;
  unsigned int bits = 0;
  unsigned int byte_count = 0;
  unsigned int internal_count = 0;
  for (int i = 0; i < 10 * clocks_per_baud + CLOCK_RATE_HZ; i++) {
    if (tb->status) {
      // Check if it is a start bit
      if (!start && !on_receiving && (tb->out) == 0) {
        printf("tick: %d / start?\n", i);
        start = true;
      }

      if (start) {
        clock_counter++;
        if (clock_counter == (clocks_per_baud / 2)) {
          printf("%d ---------- start: %d\n", tick_count, tb->out);
          on_receiving = true;
          start = false;
          clock_counter = 0;
        }
      }

      if (on_receiving) {
        clock_counter++;
        if (clock_counter == clocks_per_baud) {
          printf("%d ---------- data[%d]: %d\n", tick_count, bits, tb->out);
          bits++;
          clock_counter = 0;
          // The length of data bits is 8-bits
          if (bits > 7) break;
        }
      }
    }
    tick(tb, nullptr);
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
