#include <cstdio>

#include "obj_dir/Vtxuart_wrapper.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

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

  for (int i = 0; i < (1 << 4); i++) {
    if (i == 4) {
      tb->reset = 1;
    }
    tick(tb, tfp);
    printf("out: %d\n", tb->out);
    printf("----------------------------------\n");
  }

  return 0;
}

void tick(Vtxuart_wrapper* tb, VerilatedVcdC* tfp) {
  tick_count++;
  printf("tick: %u - ", tick_count);
  tb->clk = 1;
  tb->eval();
  tb->clk = 0;
  tb->eval();
}