#include <stdio.h>

#include "obj_dir/Vblinky_led.h"
#include "verilated.h"
#include "verilated_vcd_c.h"  // for trace

static const std::string cwd = "/Users/ghpi/fun/Verilog-tutorial/";

void tick(unsigned int tick_count, Vblinky_led* tb, VerilatedVcdC* tfp) {
  tb->eval();
  if (tfp) tfp->dump(tick_count * 10 - 2);
  tb->clk = 1;
  tb->eval();
  if (tfp) tfp->dump(tick_count * 10);
  tb->clk = 0;
  tb->eval();
  if (tfp) {
    tfp->dump(tick_count * 10 + 5);
    tfp->flush();
  }
}

int main(int argc, char** argv) {
  VerilatedContext* context = new VerilatedContext;
  context->commandArgs(argc, argv);

  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;

  Vblinky_led* tb = new Vblinky_led(context);
  tb->trace(tfp, 99);
  tfp->open(std::string(cwd + "blinky_trace.vcd").c_str());

  unsigned int tick_count = 0;
  int last_led = tb->led;
  for (int i = 0; i < (1 << 8); ++i) {
    tick(++tick_count, tb, tfp);
    if (last_led != tb->led) {
      printf("[%d] led: %d\n", i, tb->led);
    }
    last_led = tb->led;
  }
  tfp->close();
  delete tfp;

  delete tb;
  delete context;

  return 0;
}