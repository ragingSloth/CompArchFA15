vlog -reportprogress 300 -work work FullAdder.v
vsim -voptargs="+acc" testFullAdder
#add wave -position insertpoint \
sim:/testFullAdder/a \
sim:/testFullAdder/b \
sim:/testFullAdder/sum \
sim:/testFullAdder/carryout \
sim:/testFullAdder/overflow \

run -all
#wave zoom full