# Modification of RMAP target core

## Introduction

Nowadays RMAP protocol is widely used in SpaceWire networks. SpaceWire networks is widely used in space applications and satellites. So, by improving this IP core I hope to contribute in the future of space technology.

## Aim

The main aim of this project is to simplify the use of this IP core. 

Additional goals are:
* Make IP core more flexible 
* Adapt the design both for FPGA and ASIC 

## Progress

### Already done:

1. Simple authentication module (supports single write with reply, single read, incrementing read, RMW commands)
2. SystemVerilog modules for CRC table and FIFO (not verified)

### Immediate objectives:

1. Make good SystemVerilog testbench 
2. Verify current functionality
3. Provide some documentation
4. Make project on <https://www.edaplayground.com/>


