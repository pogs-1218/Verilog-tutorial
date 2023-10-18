import sys
import os

if len(sys.argv[1]) < 2:
  print('More argument')
  exit()

target = sys.argv[1]
executable = f'obj_dir/V{target}'

verilator_command = f'verilator -Wall -cc {target}.v --exe {target}.cc'
print('Verilating...')
print('   ', verilator_command)
if os.system(verilator_command):
  print('verilating error')
  exit()

make_command = f'cd obj_dir && make -f V{target}.mk'
print('Building...')
print('   ', make_command)
if os.system(make_command):
  print('make error')

os.system(executable)