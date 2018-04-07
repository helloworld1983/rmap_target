# Modification of RMAP target core

## Aim

Original IP core has some issues with portability and ease of use. 
The main aim of this project is to simplify IP usage and instantiation. 

Additional goals are:
* Make IP core more flexible.
* Adapt the design both for FPGA and ASIC.
* Improve core data throughput.

## Motivation

Nowadays RMAP protocol is widely used in SpaceWire networks. In its turn, SpaceWire networks are widely used in space applications and satellites. By improving this IP core I hope to contribute to the future of space technology.

## Folder structure

**./doc** : documentation for the project.

**./src** : all VHDL and Verilog/SystemVerilog synthesisable source files.  
**./src/Altera** : files from the original project for FIFO(2Kx8) and CRC table for Altera.  
**./src/Xilinx** : files from the original project for FIFO(2Kx8) and CRC table for Xilinx.

**./sim** : files for simulation.  
**./sim/simple\_tbench** : simple SystemVerilog testbench. Just shows functionality.  
**./sim/uvm\_tbench**    : main UVM testbench.  
**./sim/modelsim**       : file lists and .tcl scripts for modelsim.

## Progress

### Already done:

1. Simple authentication module (supports single write with a reply, single read, incrementing read, RMW commands).
2. SystemVerilog modules for CRC table and FIFO (not verified properly).
3. Manual check of main operations with simple testbench.

### Immediate objectives:

1. Make good UVM testbench.
2. Provide some documentation.
3. Improve speed of reading and writing to/from FIFO interfaces.
4. Make a project on <https://www.edaplayground.com/>

## Useful documentation:

* SpaceWire - Remote memory access protocol (ECSS-E-ST-50-52C, 5 February 2010).
* Wishbone B4 specification (2010 OpenCores).
* Atmel SpaceWire Router AT7910E User guide (good example of typical application for RMAP IP).
