transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+Audio_Codec_Wrapper  -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.Audio_Codec_Wrapper xil_defaultlib.glbl

do {Audio_Codec_Wrapper.udo}

run 1000ns

endsim

quit -force
