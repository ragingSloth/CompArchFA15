#!/usr/bin/env bash

iverilog -o test regfile.t.v regfile.v mux32.v register32.v decoders.v
vvp test
