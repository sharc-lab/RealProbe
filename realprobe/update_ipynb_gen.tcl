set RP_PATH $arg1 
set PRJ_NAME $arg2
set SOL_NAME $arg3 
global PRJ_NAME SOL_NAME RP_PATH

# Get the directory of the current script
set scriptDir "[pwd]/${PRJ_NAME}/${SOL_NAME}"

# Read the contents of top.txt
set top_txt_content [open "top.txt" r]
set topModule [gets ${top_txt_content}]
close $top_txt_content

# Determine the path of x${topModule}_hw.h file based on the location of the script
set implDir "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl"

set filename [file join $implDir misc drivers ${topModule}_v1_0 src x[string tolower $topModule]_hw.h]
set lines [split [read [open $filename]] "\n"]

# Regular expression pattern to match lines containing signal definitions
set pattern {^\s*#define\s+\w+_CONTROL_ADDR_(\w+)_DATA\s+(0x[0-9a-fA-F]+)}

# Initialize lists to store signals and addresses
set signals {}
set addresses {}

# Iterate over lines in the file
foreach line $lines {
    if {[regexp $pattern $line -> signal_suffix address]} {
        # Convert the signal suffix to lowercase
        set signal_suffix [string tolower $signal_suffix]
        # Add the signal suffix to the signals list
        lappend signals $signal_suffix
        lappend addresses $address
    }
}

# Output the signals and their corresponding addresses
set index 0
foreach signal $signals {
    set address [lindex $addresses $index]
    puts "sig($index) = $signal"
    puts "add($index) = $address"
    incr index
}
# Define the path to the signals file


set top_file_path "top.txt"
set topupdated_file_path "top_updated.txt"


if { ![file exists $top_file_path] } {
    puts "Error: top.txt does not exist."
    exit 1
}

if { ![file exists $topupdated_file_path] } {
    puts "Error: update the function"
    exit 1
}

set top_file [open $top_file_path]
set topmodulename [read $top_file]
close $top_file

set topupdated_file [open $topupdated_file_path]
set topupdatedmodulename [read $topupdated_file]
close $topupdated_file

set topmodulename [string trim $topmodulename]
set topupdatedmodulename [string trim $topupdatedmodulename]

if { $topmodulename eq "" } {
    puts "Error: top.txt is empty."
    exit 1
}
if { $topupdatedmodulename eq "" } {
    puts "Error: top_updated.txt is empty."
    exit 1
}

set signals_file "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topmodulename}_${topupdatedmodulename}_under.txt"

# Open the signals file for reading
set file [open $signals_file r]

# Initialize an array to store the signals
set ap_signals {}

# Initialize a counter for the signals
# set signal_index 0

# Read each line from the file
while {[gets $file line] != -1} {
    # Skip blank lines
    if {[string trim $line] eq ""} {
        continue
    }
    # Store non-blank lines in the signals array
    lappend ap_signals $line
}

set index 0
foreach signal $ap_signals {
    set address [lindex $addresses $index]
    puts "ap_sig($index) = $signal"
    incr index
}

# Close the file
close $file

set notebook_data [list]
lappend notebook_data \{
lappend notebook_data "\"cells\": \["

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"markdown\","
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"# ${topModule}\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"This notebook exemplies the use of a hardware overlay to accelerate a floating-point matrix multiplication. \""
lappend notebook_data "\]"
lappend notebook_data \}

lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"from pynq import (allocate, Overlay) \","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"import numpy as np \","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"import time \""
lappend notebook_data "\]"
lappend notebook_data \}

lappend notebook_data ","



lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"markdown\","
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"## Load the overlay\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"Program the FPGA and reference the required hardware blocks. \""
lappend notebook_data "\]"
lappend notebook_data \}


lappend notebook_data ","


lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"ol = Overlay('./design_1.bit')\""
lappend notebook_data "\]"
lappend notebook_data \}


lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"ip = ol.${topModule}_0\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"ip.signature\""
lappend notebook_data "\]"
lappend notebook_data \}

lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"markdown\","
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"## Allocate memory\""
lappend notebook_data "\]"
lappend notebook_data \}


lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"# write your dimension\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"DIM = 32\","
lappend notebook_data "\"\\n\","
for {set i 0} {$i < [llength $signals]} {incr i} {
    set signal [lindex $signals $i]
    set address [lindex $addresses $i]
    # Append the notebook data for the signal
    lappend notebook_data "\"${signal}_buffer = allocate(shape=(DIM), dtype=np.int32, cacheable=False)\","
    lappend notebook_data "\"\\n\","
}
lappend notebook_data "\"\\n\","
lappend notebook_data "\" \""
lappend notebook_data "\]"
lappend notebook_data \}

lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"markdown\","
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"## ${topModule} in hardware (PL side)\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"The execution of the algorithm using the hardware kernel includes the roundtrip data transfer (processor to FPGA, and FPGA to processor). Usually, this data transfer constitutes the performance bottleneck.\""
lappend notebook_data "\]"
lappend notebook_data \}

lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"# Initialize your input\""
lappend notebook_data "\]"
lappend notebook_data \}

lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
for {set i 0} {$i < [llength $signals]} {incr i} {
    set signal [lindex $signals $i]
    set address [lindex $addresses $i]
    # Append the notebook data for the signal
    lappend notebook_data "\"${signal}ptr = ${signal}_buffer.physical_address\","
    lappend notebook_data "\"\\n\","
}
lappend notebook_data "\"\\n\","
lappend notebook_data "\" \""
lappend notebook_data "\]"
lappend notebook_data \}

lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
for {set i 0} {$i < [llength $signals]} {incr i} {
    set signal [lindex $signals $i]
    set address [lindex $addresses $i]
    # Append the notebook data for the signal
    lappend notebook_data "\"ip.write(${address}, ${signal}ptr)\","
    lappend notebook_data "\"\\n\","
}
lappend notebook_data "\"\\n\","
lappend notebook_data "\" \""
lappend notebook_data "\]"
lappend notebook_data \}


lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"ip.write(0x00, 1)\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"isready = ip.read(0x00)\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"while( isready == 1 ):\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"    isready = ip.read(0x00)\""
lappend notebook_data "\]"
lappend notebook_data \}

lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"markdown\","
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"# Verify Correctness\""
lappend notebook_data "\]"
lappend notebook_data \}

lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"# check the result of HW vs. SW\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"# np.array_equal(, )\""
lappend notebook_data "\]"
lappend notebook_data \}

lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"markdown\","
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"# Realprobe Output\""
lappend notebook_data "\]"
lappend notebook_data \}


lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"bram = ol.axi_bram_ctrl_0\""
lappend notebook_data "\]"
lappend notebook_data \}

lappend notebook_data ","

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"num_signal = [llength $ap_signals]\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"ap_signals = \[\]\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"\\n\","
for {set i 0} {$i < [llength $ap_signals]} {incr i} {
    set ap_signal [lindex $ap_signals $i]
    lappend notebook_data "\"ap_signals.append('$ap_signal')\","
    lappend notebook_data "\"\\n\","
    # lappend notebook_data "ap_signals.append(\"$ap_signal\")"
}
lappend notebook_data "\"\\n\","
lappend notebook_data "\"start_address = 0x00 \","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"step_size = 4 \","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"end_address = start_address + num_signal\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"for i in range(start_address, end_address):\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"    print(ap_signals\[i\], ' clock cycles = ', bram.read(i*step_size))\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\" \""
lappend notebook_data "\]"
lappend notebook_data \}

lappend notebook_data \]

lappend notebook_data ","

lappend notebook_data "\"metadata\": \{"
lappend notebook_data "\"kernelspec\": \{"
lappend notebook_data "\"display_name\": \"Python 3\","
lappend notebook_data "\"language\": \"python\","
lappend notebook_data "\"name\": \"python3\""
lappend notebook_data "\},"
lappend notebook_data "\"language_info\": \{"
lappend notebook_data "\"codemirror_mode\": \{"
lappend notebook_data "\"name\": \"ipython\","
lappend notebook_data "\"version\": 3"
lappend notebook_data "\},"
lappend notebook_data "\"file_extension\": \".py\","
lappend notebook_data "\"mimetype\": \"text/x-python\","
lappend notebook_data "\"name\": \"python\","
lappend notebook_data "\"nbconvert_exporter\": \"python\","
lappend notebook_data "\"pygments_lexer\": \"ipython3\","
lappend notebook_data "\"version\": \"3.8.5\""
lappend notebook_data "\}"
lappend notebook_data "\},"
lappend notebook_data "\"nbformat\": 4,"
lappend notebook_data "\"nbformat_minor\": 4"
lappend notebook_data \}

# Open notebook file for writing
set notebook_filename "$RP_PATH/fpga.ipynb"
set notebook_file [open $notebook_filename w]

# Write notebook data to file
foreach line $notebook_data {
    puts $notebook_file $line
}

close $notebook_file
