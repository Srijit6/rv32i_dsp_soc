set ::env(DESIGN_NAME) "soc_top"

set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/../hw/rtl/core/*.v \
                               $::env(DESIGN_DIR)/../hw/rtl/dsp/*.v \
                               $::env(DESIGN_DIR)/../hw/rtl/soc/*.v]

set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_PERIOD) "20.0" 

set ::env(FP_SIZING) "relative"
set ::env(FP_CORE_UTIL) 50

set ::env(ROUTING_CORES) 4
set ::env(RUN_KLAYOUT) 0
set ::env(RUN_CVC) 0

set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]

set ::env(SYNTH_STRATEGY) "AREA 0"
