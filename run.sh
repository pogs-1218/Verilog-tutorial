#!/bin/zsh

out_dir="build"

if [ ! -d $out_dir ]; then
  mkdir build
fi
iverilog -Wall -o build/$1 $1.v
vvp build/$1