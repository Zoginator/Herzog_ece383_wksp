vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv "+incdir+../../../Lab _2.gen/sources_1/ip/clk_wiz_1" \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm  -93  \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../Lab _2.gen/sources_1/ip/clk_wiz_1/clk_wiz_1_sim_netlist.vhdl" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../Lab _2.gen/sources_1/ip/clk_wiz_1" \
"../../../Lab _2.srcs/sources_1/imports/C27Soren.Herzog/OneDrive - afacademy.af.edu/Documents/Schoolwork Sem6 2026 Spring/M1 - ECE 383 CSYS/Lab/Lab 2/lab2_code_for_cadets_2026/audio_init.v" \

vcom -work xil_defaultlib  -93  \
"../../../Lab _2.srcs/sources_1/imports/C27Soren.Herzog/OneDrive - afacademy.af.edu/Documents/Schoolwork Sem6 2026 Spring/M1 - ECE 383 CSYS/Lab/Lab 2/lab2_code_for_cadets_2026/TWICtl.vhd" \
"../../../Lab _2.srcs/sources_1/imports/C27Soren.Herzog/OneDrive - afacademy.af.edu/Documents/Schoolwork Sem6 2026 Spring/M1 - ECE 383 CSYS/Lab/Lab 2/lab2_code_for_cadets_2026/i2s_ctl.vhd" \
"../../../Lab _2.srcs/sources_1/imports/C27Soren.Herzog/OneDrive - afacademy.af.edu/Documents/Schoolwork Sem6 2026 Spring/M1 - ECE 383 CSYS/Lab/Lab 2/lab2_code_for_cadets_2026/Audio_Codec_Wrapper.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

