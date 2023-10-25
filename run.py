import sys
import os

trace = False

param_dic = {}
param_width = os.getenv("WIDTH")
if(param_width != None):
  param_dic["WIDTH"] = param_width

trace_env = os.getenv("TRACE")
if(trace_env != None):
  trace = bool(trace_env)

if len(sys.argv[1]) < 2:
  print('More argument')
  exit()

target = sys.argv[1]
executable = f'obj_dir/V{target}'

verilator_command = f'verilator -Wall'
if trace:
  verilator_command += ' --trace'
verilator_command += "".join([f" -G{k}={v}" for k, v in param_dic.items()])
verilator_command += f' -cc {target}.v --exe {target}.cc' 

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