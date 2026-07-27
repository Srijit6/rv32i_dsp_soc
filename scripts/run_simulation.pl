#!/usr/bin/perl
use strict;
use warnings;

print "========================================\n";
print " RV32I + DSP SoC Simulation Environment \n";
print "========================================\n";

# Define workspace paths
my $rtl_dir = "../hw/rtl";
my $tb_dir  = "../dv/tb";
my $sim_bin = "sim_exec.vvp";

# Target assembly test (we can parameterize this later)
my $test_name = "mac_test";
print "[*] Target Test: $test_name\n\n";

# 1. Gather all Verilog files (Core, DSP, SoC, and TB)
my @rtl_files = (
    "$tb_dir/top_tb.v",
    "$rtl_dir/soc/soc_top.v",
    "$rtl_dir/soc/instruction_memory.v",
    "$rtl_dir/core/rv32i_top.v",
    "$rtl_dir/core/fetch.v",
    "$rtl_dir/core/decode.v",
    "$rtl_dir/core/execute.v",
    "$rtl_dir/core/register_file.v",
    "$rtl_dir/core/hazard_unit.v",
    "$rtl_dir/dsp/dsp_coprocessor.v",
    "$rtl_dir/dsp/mac_unit.v"
);

my $file_list = join(" ", @rtl_files);

# 2. Compile with Icarus Verilog
print "[1/3] Compiling RTL and Testbench...\n";
my $compile_cmd = "iverilog -Wall -o $sim_bin $file_list";
my $compile_status = system($compile_cmd);

if ($compile_status != 0) {
    die "\n[!] FATAL: Icarus Verilog compilation failed.\n";
}

# 3. Run Simulation
print "[2/3] Executing Simulation (VVP)...\n";
my $sim_cmd = "vvp $sim_bin";
my $sim_status = system($sim_cmd);

if ($sim_status != 0) {
    die "\n[!] FATAL: Simulation runtime error.\n";
}

# 4. Clean up executable
unlink $sim_bin;
print "\n[3/3] Flow Complete. Check terminal for Verilog \$display outputs.\n";
