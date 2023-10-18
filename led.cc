#include <cstdio>

#include "obj_dir/Vled.h"
#include "verilated.h"

int main(int argc, char** argv) {
  VerilatedContext* contextp = new VerilatedContext;
  contextp->commandArgs(argc, argv);

  Vled* led = new Vled(contextp);
  for (int i = 0; i < 5; i++) {
    led->i_sw = i & 1;
    led->eval();
    printf("%d - %d\n", led->i_sw, led->o_led);
  }
  led->final();
  delete led;
  delete contextp;

  return 0;
}