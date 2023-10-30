#include <stdio.h>
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "obj_dir/Vwishbone.h"

unsigned int tick_count = 0;
static const std::string cwd = "/Users/ghpi/fun/Verilog-tutorial/";

unsigned int wb_read(Vwishbone* tb, VerilatedVcdC* tfp, unsigned int a);
void wb_write(Vwishbone* tb, VerilatedVcdC* tfp, unsigned int a,
              unsigned int b);
void tick(Vwishbone* tb, VerilatedVcdC* tfp);

int main(int argc, char** argv) {
  VerilatedContext* context = new VerilatedContext();
  VerilatedVcdC* tfp = new VerilatedVcdC();
  Vwishbone* tb = new Vwishbone(context);
  context->commandArgs(argc, argv);
  context->traceEverOn(true);
  tb->trace(tfp, 99);
  tfp->open(std::string(cwd + "wishbone3.vcd").c_str());

  printf("initial state: 0x%02x\n", wb_read(tb, tfp, 0));
  for (int i = 0; i < 2; ++i) {
    for (int j = 0; j < 5; ++j) {
      tick(tb, tfp);
    }

    wb_write(tb, tfp, 0, 0);
    tick(tb, tfp);

    unsigned int state = 0;
    unsigned int last_state = 0;
    unsigned int last_led = 0;

    // until Led walker is done.
    while ((state = wb_read(tb, tfp, 0)) != 0) {
      if ((state != last_state) || (tb->led != last_led)) {
        printf("state: %d . led: %d\n", state, tb->led);
      }
      tick(tb, tfp);
      last_state = state;
      last_led = tb->led;
    }
  }

  tfp->close();
  delete tfp;
  delete context;

  return 0;
}

unsigned int wb_read(Vwishbone* tb, VerilatedVcdC* tfp, unsigned int a) {
  tb->cyc = tb->stb = 1;
  tb->we = 0;
  tb->eval();
  tb->addr = a;

  while (tb->stall) tick(tb, tfp);
  tick(tb, tfp);
  tb->stb = 0;

  while (!tb->ack) tick(tb, tfp);
  tb->cyc = 0;

  return tb->o_data;
}

void wb_write(Vwishbone* tb, VerilatedVcdC* tfp, unsigned int a,
              unsigned int v) {
  tb->cyc = tb->stb = 1;
  tb->we = 1;
  tb->eval();
  tb->addr = a;
  tb->i_data = v;

  while (tb->stall) tick(tb, tfp);
  tick(tb, tfp);
  tb->stb = 0;

  while (!tb->ack) tick(tb, tfp);
  tb->cyc = 0;
}

void tick(Vwishbone* tb, VerilatedVcdC* tfp) {
  tick_count += 1;

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
