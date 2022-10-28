onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /processorrv_tb/clk
add wave -noupdate /processorrv_tb/reset
add wave -noupdate /processorrv_tb/iAddr
add wave -noupdate /processorrv_tb/iDataIn
add wave -noupdate /processorrv_tb/dWrEn
add wave -noupdate /processorrv_tb/dRdEn
add wave -noupdate -divider {New Divider}
add wave -noupdate -childformat {{/processorrv_tb/i_processor/RegsRISCV/regs(0) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(1) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(2) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(3) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(4) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(5) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(6) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(7) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(8) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(9) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(10) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(11) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(12) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(13) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(14) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(15) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(16) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(17) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(18) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(19) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(20) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(21) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(22) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(23) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(24) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(25) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(26) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(27) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(28) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(29) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(30) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(31) -radix hexadecimal}} -expand -subitemconfig {/processorrv_tb/i_processor/RegsRISCV/regs(0) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(1) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(2) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(3) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(4) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(5) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(6) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(7) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(8) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(9) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(10) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(11) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(12) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(13) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(14) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(15) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(16) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(17) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(18) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(19) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(20) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(21) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(22) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(23) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(24) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(25) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(26) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(27) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(28) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(29) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(30) {-radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(31) {-radix hexadecimal}} /processorrv_tb/i_processor/RegsRISCV/regs
add wave -noupdate -divider {PC values}
add wave -noupdate -radix unsigned /processorrv_tb/i_processor/PC_reg
add wave -noupdate -radix unsigned /processorrv_tb/i_processor/PC_next
add wave -noupdate -radix unsigned /processorrv_tb/i_processor/PC_plus4
add wave -noupdate /processorrv_tb/i_processor/Alu_Op2
add wave -noupdate /processorrv_tb/i_processor/forwardA
add wave -noupdate /processorrv_tb/i_processor/forwardB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {160036 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {858574 ps}
