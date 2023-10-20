#!/bin/zsh

out_dir=build
target=$1

if [ ! -d $out_dir ]; then
  mkdir $out_dir
fi
iverilog -Wall -o $out_dir/$target $target.v
vvp $out_dir/$target

# copy a vcd file to the shared directory
if [ -f $target.vcd ]; then
  cp $target.vcd ~/Shared
fi