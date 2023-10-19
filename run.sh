#!/bin/zsh

mkdir build
iverilog -Wall -o build/$1 $1.v
vvp build/$1