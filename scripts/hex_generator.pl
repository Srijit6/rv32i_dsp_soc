#!/usr/bin/perl
use strict;
use warnings;

my $hex_file = "../dv/assembly/mac_test.hex";

open(my $fh, '>', $hex_file) or die "Could not open $hex_file: $!";

print "Generating RISC-V Machine Code...\n";

# Instruction 1: ADDI x1, x0, 5
# binary: 000000000101_00000_000_00001_0010011
print $fh "00500093\n"; 

# Instruction 2: ADDI x2, x0, 10
# binary: 000000001010_00000_000_00010_0010011
print $fh "00A00113\n"; 

# Instruction 3: CUSTOM-0 x3, x1, x2 (Our DSP MAC instruction)
# opcode=0001011, rd=x3, funct3=000, rs1=x1, rs2=x2, funct7=0000000
# binary: 0000000_00010_00001_000_00011_0001011
print $fh "0020818B\n"; 

close($fh);
print "Successfully wrote hex file: $hex_file\n";
