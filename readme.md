# Modification of RMAP target core

## Features

## Folder structure

**/doc** : documentation for the project.

**/src** : all VHDL and Verilog/SystemVerilog synthesisable source files.  
**/src/Altera** : files from the original project for FIFO(2Kx8) and CRC table for Altera.  
**/src/Xilinx** : files from the original project for FIFO(2Kx8) and CRC table for Xilinx.

**/sim** : files for simulation.  
**/sim/modelsim** : file lists and .tcl scripts for modelsim.

## Useful documentation:

* SpaceWire - Remote memory access protocol (ECSS-E-ST-50-52C, 5 February 2010).
* Wishbone B4 specification (2010 OpenCores).
* Atmel SpaceWire Router AT7910E User guide (good example of typical application for RMAP IP).
