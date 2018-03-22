vlib work

# compile
vlog -work work       ../../src/RMAPTargetIPCRCRom.sv
vlog -work work       ../../src/RMAPTargetIPFIFO.sv
vcom -work work -2008 ../../src/RMAPTargetIPPackage.vhdl
vcom -work work -2008 ../../src/RMAPTargetIPDecoder.vhdl
vcom -work work -2008 ../../src/RMAPTargetIPDMAController.vhdl
vcom -work work -2008 ../../src/RMAPTargetIP.vhdl
vlog -work work       ../../src/RMAPAuthenticator.sv
vlog -work work       ../../src/RMAPTargetTop.sv
vlog -work work       ../tbench/RMAPTargetTop_TB.sv

# simulate
vsim RMAPTargetTop_TB

# some windows
view structure
view signals
view wave

# signals
do wave.do

# run
run -all