#include <stdio.h>

#include "obj_dir/Vstrobe.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

static const std::string cwd = "/Users/ghpi/fun/Verilog-tutorial/";

void tick(unsigned int tick_count, Vstrobe* tb, VerilatedVcdC* tfp) {
  tb->eval();
  tfp->dump(tick_count * 10 - 2);
  tb->clk = 0;
  tb->eval();
  tfp->dump(tick_count * 10);
  tb->clk = 1;
  tb->eval();
  tfp->dump(tick_count * 10 + 2);
  tfp->flush();
}

int main(int argc, char** argv) {
  auto context = std::make_unique<VerilatedContext>();
  context->commandArgs(argc, argv);
  Verilated::traceEverOn(true);
  auto tfp = new VerilatedVcdC();
  auto tb = new Vstrobe();
  tb->trace(tfp, 99);
  tfp->open(std::string(cwd + "strobe_trace.vcd").c_str());

  unsigned int tick_count = 0;
  int last_led = tb->led;
  for (int i = 0; i < (1 << 8); ++i) {
    tick(++tick_count, tb, tfp);
    last_led = tb->led;
  }

  tfp->close();
  delete tfp;
  delete tb;

  return 0;
}