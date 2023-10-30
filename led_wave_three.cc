#include <stdio.h>

#include "obj_dir/Vled_wave_three.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

static const std::string cwd = "/Users/ghpi/fun/Verilog-tutorial/";

void tick(unsigned int tick_count, Vled_wave_three* tb, VerilatedVcdC* tfp) {
  tb->eval();
  tfp->dump(tick_count * 10 - 2);
  tb->clk = 1;
  tb->eval();
  tfp->dump(tick_count * 10);
  tb->clk = 0;
  tb->eval();
  tfp->dump(tick_count * 10 + 5);
  tfp->flush();
}

int main(int argc, char** argv) {
  VerilatedContext* context = new VerilatedContext();
  context->commandArgs(argc, argv);
  context->traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC();
  Vled_wave_three* tb = new Vled_wave_three(context);

  tb->trace(tfp, 99);
  tfp->open(std::string(cwd + "led_wave_three.vcd").c_str());

  unsigned int tick_count = 0;
  for (int i = 0; i < (1 << 8); ++i) {
    tick(++tick_count, tb, tfp);
    if (i == 10) tb->request = 1;
    printf("[%d] r: %d, busy: %d, led: %d\n", i, tb->request, tb->busy,
           tb->led);
  }

  tfp->close();
  delete tfp;
  delete context;

  return 0;
}