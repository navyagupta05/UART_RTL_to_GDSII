#!/bin/sh
set -e
[ $# -ge 4 ] || { echo "usage: $0 <top> <liberty.lib> <clk_period_ns> <verilog files...>" >&2; exit 1; }
top=$1; lib=$2; period=$3; shift 3
out="synth_$top"
period_ps=$(awk "BEGIN{printf \"%d\", $period*1000}")
mkdir -p "$out"

sed -E 's/^( *cell \("sky130_fd_sc_hd__(lpflow_|probe_p_8|probec_p_8)[^"]*"\) \{)$/\1\n        dont_use : true;/' "$lib" > "$out/synth_cells.lib"

cat > "$out/synth.ys" <<YS
read_liberty -lib -ignore_miss_dir -setattr blackbox $out/synth_cells.lib
read_verilog -sv $*
hierarchy -check -top $top
synth -top $top -flatten
opt -purge
dfflibmap -liberty $out/synth_cells.lib
abc -liberty $out/synth_cells.lib -D $period_ps
setundef -zero
splitnets
opt_clean -purge
hilomap -singleton -hicell sky130_fd_sc_hd__conb_1 HI -locell sky130_fd_sc_hd__conb_1 LO
insbuf -buf sky130_fd_sc_hd__buf_2 A X
check
tee -o $out/${top}_stat.rpt stat -liberty $out/synth_cells.lib
write_verilog -noattr -noexpr -nohex -nodec $out/${top}_netlist.v
YS

yosys -l "$out/yosys.log" -s "$out/synth.ys"
