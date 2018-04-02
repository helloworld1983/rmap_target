onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /RMAPTargetTop_TB/uRMAPTargetTop/clk
add wave -noupdate /RMAPTargetTop_TB/uRMAPTargetTop/rst
add wave -noupdate -expand -group FIFOs /RMAPTargetTop_TB/uRMAPTargetTop/txWriteEnable
add wave -noupdate -expand -group FIFOs -radix hexadecimal /RMAPTargetTop_TB/uRMAPTargetTop/txDataIn
add wave -noupdate -expand -group FIFOs /RMAPTargetTop_TB/uRMAPTargetTop/txFull
add wave -noupdate -expand -group FIFOs /RMAPTargetTop_TB/uRMAPTargetTop/rxReadEnable
add wave -noupdate -expand -group FIFOs -radix hexadecimal /RMAPTargetTop_TB/uRMAPTargetTop/rxDataOut
add wave -noupdate -expand -group FIFOs /RMAPTargetTop_TB/uRMAPTargetTop/rxEmpty
add wave -noupdate -expand -group Wishbone /RMAPTargetTop_TB/uRMAPTargetTop/cycOut
add wave -noupdate -expand -group Wishbone /RMAPTargetTop_TB/uRMAPTargetTop/stbOut
add wave -noupdate -expand -group Wishbone -radix hexadecimal /RMAPTargetTop_TB/uRMAPTargetTop/adrOut
add wave -noupdate -expand -group Wishbone /RMAPTargetTop_TB/uRMAPTargetTop/selOut
add wave -noupdate -expand -group Wishbone /RMAPTargetTop_TB/uRMAPTargetTop/datIn
add wave -noupdate -expand -group Wishbone -radix hexadecimal /RMAPTargetTop_TB/uRMAPTargetTop/datOut
add wave -noupdate -expand -group Wishbone /RMAPTargetTop_TB/uRMAPTargetTop/weOut
add wave -noupdate -expand -group Wishbone /RMAPTargetTop_TB/uRMAPTargetTop/ackIn
add wave -noupdate -expand -group Wishbone /RMAPTargetTop_TB/uRMAPTargetTop/errIn
add wave -noupdate -expand -group {Status & config} -radix hexadecimal /RMAPTargetTop_TB/uRMAPTargetTop/rmapErrorCode
add wave -noupdate -expand -group {Status & config} /RMAPTargetTop_TB/uRMAPTargetTop/errorIndication
add wave -noupdate -expand -group {Status & config} /RMAPTargetTop_TB/uRMAPTargetTop/writeDataIndication
add wave -noupdate -expand -group {Status & config} /RMAPTargetTop_TB/uRMAPTargetTop/readDataIndication
add wave -noupdate -expand -group {Status & config} /RMAPTargetTop_TB/uRMAPTargetTop/rmwDataIndication
add wave -noupdate -expand -group {Status & config} -radix hexadecimal /RMAPTargetTop_TB/uRMAPTargetTop/configKey
add wave -noupdate -expand -group {Status & config} -radix hexadecimal /RMAPTargetTop_TB/uRMAPTargetTop/logicalAddress
add wave -noupdate -expand -group {Status & config} /RMAPTargetTop_TB/uRMAPTargetTop/addrInvalid
add wave -noupdate -expand -group {Status & config} /RMAPTargetTop_TB/uRMAPTargetTop/dataLengthInvalid
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/configKey
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/logicalAddress
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/rmapLogicalAddress
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/rmapCommand
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/rmapKey
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/rmapExtendedAddress
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/rmapAddress
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/rmapDataLength
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/requestAuthorization
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/authorizeAck
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/rejectAck
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/replyStatus
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/addrInvalid
add wave -noupdate -expand -group Authenticator /RMAPTargetTop_TB/uRMAPTargetTop/uRMAPAuthentication/dataLengthInvalid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {45 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 172
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {723 ps}
