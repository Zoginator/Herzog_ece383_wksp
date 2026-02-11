transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib activehdl/xpm
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../Lab _2.gen/sources_1/ip/clk_wiz_1" -l xpm -l xil_defaultlib \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93  \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93  \
"../../../Lab _2.gen/sources_1/ip/clk_wiz_1/clk_wiz_1_sim_netlist.vhdl" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../Lab _2.gen/sources_1/ip/clk_wiz_1" -l xpm -l xil_defaultlib \
"../../../Lab _2.srcs/sources_1/imports/C27Soren.Herzog/OneDrive - afacademy.af.edu/Documents/Schoolwork Sem6 2026 Spring/M1 - ECE 383 CSYS/Lab/Lab 2/lab2_code_for_cadets_2026/audio_init.v" \

vcom -work xil_defaultlib -93  \
"../../../Lab _2.srcs/sources_1/imports/C27Soren.Herzog/OneDrive - afacademy.af.edu/Documents/Schoolwork Sem6 2026 Spring/M1 - ECE 383 CSYS/Lab/Lab 2/lab2_code_for_cadets_2026/TWICtl.vhd" \
"../../../Lab _2.srcs/sources_1/imports/C27Soren.Herzog/OneDrive - afacademy.af.edu/Documents/Schoolwork Sem6 2026 Spring/M1 - ECE 383 CSYS/Lab/Lab 2/lab2_code_for_cadets_2026/i2s_ctl.vhd" \
"../../../Lab _2.srcs/sources_1/imports/C27Soren.Herzog/OneDrive - afacademy.af.edu/Documents/Schoolwork Sem6 2026 Spring/M1 - ECE 383 CSYS/Lab/Lab 2/lab2_code_for_cadets_2026/Audio_Codec_Wrapper.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

