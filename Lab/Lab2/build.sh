#!/usr/bin/env bash
iverilog -o mem spimemory.v inputconditioner.v shiftregister.v datamemory.v
vvp mem
