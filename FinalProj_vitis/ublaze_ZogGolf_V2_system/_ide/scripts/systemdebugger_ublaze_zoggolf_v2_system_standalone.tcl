# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Users\C27Soren.Herzog\ece383\Herzog_ece383_wksp\FinalProj_vitis\ublaze_ZogGolf_V2_system\_ide\scripts\systemdebugger_ublaze_zoggolf_v2_system_standalone.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Users\C27Soren.Herzog\ece383\Herzog_ece383_wksp\FinalProj_vitis\ublaze_ZogGolf_V2_system\_ide\scripts\systemdebugger_ublaze_zoggolf_v2_system_standalone.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -filter {jtag_cable_name =~ "Digilent Nexys Video 210276B817F4B" && level==0 && jtag_device_ctx=="jsn-Nexys Video-210276B817F4B-13636093-0"}
fpga -file C:/Users/C27Soren.Herzog/ece383/Herzog_ece383_wksp/FinalProj_vitis/ublaze_ZogGolf_V2/_ide/bitstream/ZoGolf_V2_wrapper.bit
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
loadhw -hw C:/Users/C27Soren.Herzog/ece383/Herzog_ece383_wksp/FinalProj_vitis/ZoGolf_V2_wrapper/export/ZoGolf_V2_wrapper/hw/ZoGolf_V2_wrapper.xsa -regs
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
rst -system
after 3000
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
dow C:/Users/C27Soren.Herzog/ece383/Herzog_ece383_wksp/FinalProj_vitis/ublaze_ZogGolf_V2/Debug/ublaze_ZogGolf_V2.elf
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
con
