global PRJ_NAME SOL_NAME RP_PATH BUILD_PATH 

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
set signals_file "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/apstart_signals.txt"
set depth_file "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/conservative_tripcount.txt"

# Open the signals file for reading
set file [open $signals_file r]

# Initialize an array to store the signals
set ap_signals {}

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


# Open the signals file for reading
set file [open $depth_file r]

# Initialize an array to store the signals
set depths {}

# Read each line from the file
while {[gets $file line] != -1} {
    # Skip blank lines
    if {[string trim $line] eq ""} {
        continue
    }
    # Store non-blank lines in the signals array
    lappend depths $line
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

# lappend notebook_data "\"num_signal = [llength $ap_signals]\","
# lappend notebook_data "\"\\n\","
# lappend notebook_data "\"ap_signals = \[\]\","
# lappend notebook_data "\"\\n\","
# lappend notebook_data "\"\\n\","
# for {set i 0} {$i < [llength $ap_signals]} {incr i} {
#     set ap_signal [lindex $ap_signals $i]
#     lappend notebook_data "\"ap_signals.append('$ap_signal')\","
#     lappend notebook_data "\"\\n\","
# }
lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"READ_INDEX_ADDR = 0x190  # 7'd100 << 2\","
# Create depths array string
# Build a Python-style list line
set depths_line "recorder_depths = \["
foreach d $depths {
    append depths_line "$d, "
}
set depths_line [string trimright $depths_line ", "]
append depths_line "\]"

# Store line in notebook_data with double escaping for Python code
lappend notebook_data "\"$depths_line\","
lappend notebook_data "\"\\n\""
set names_line "recorder_names = ["
lappend notebook_data "\"$names_line\""
lappend notebook_data "\"\\n\""

# Add each recorder name on its own line, with correct comma placement
set num_signals [llength $ap_signals]
for {set i 0} {$i < $num_signals} {incr i} {
    set ap_signal [lindex $ap_signals $i]

    # Add comma except for the last item
    if {$i == [expr {$num_signals - 1}]} {
        set line "    \\\"$ap_signal\\\""
    } else {
        set line "    \\\"$ap_signal\\\","
    }

    lappend notebook_data "\"$line\""
    lappend notebook_data "\"\\n\""
}

# Add the closing bracket
lappend notebook_data "\"]\","
lappend notebook_data "\"\\n\""
set num_recorders [llength $depths]  ;
set bases_line "recorder_bases = \[0x08 + i * 8 for i in range($num_recorders)\]  # base addresses for start_time_x"
lappend notebook_data "\"$bases_line\""
lappend notebook_data "\"\\n\""
set num_recorders [llength $depths]
set alloc_line1 "max_depth = max(recorder_depths)"
set alloc_line2 "start_bufs = \[allocate(shape=(max_depth,), dtype=np.uint32) for _ in range($num_recorders)\]"
set alloc_line3 "end_bufs   = \[allocate(shape=(max_depth,), dtype=np.uint32) for _ in range($num_recorders)\]"
set alloc_line4 "dumped_flags = \[False\] * $num_recorders  # To avoid multiple dumps on the same full"
lappend notebook_data "\"$alloc_line1\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"$alloc_line2\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"$alloc_line3\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"$alloc_line4\""
lappend notebook_data "\"\\n\""

lappend notebook_data "\"# === Dump function ===\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"def dump_recorder(i):\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"    base_addr = recorder_bases\[i\]\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"    for idx in range(recorder_depths\[i\]):\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        ip.write(READ_INDEX_ADDR, idx)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        start = ip.read(base_addr)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        end   = ip.read(base_addr + 4)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        start_bufs\[i\]\[idx\] = start\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        end_bufs\[i\]\[idx\] = end\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        print(f\\\"  Entry {{idx}}: start={{start}}, end={{end}}, latency={{end - start}}\\\")\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"    dumped_flags\[i\] = True\""
lappend notebook_data "\"\\n\""
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

# === Determine number of recorders ===
set num_recorders [llength $depths]
set mask [expr (1 << $num_recorders) - 1]
set mask_hex [format "0x%X" $mask]

# === RealProbe Execution Monitoring Code Cell ===
lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"# === Start RealProbe execution ===\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"print(\\\"Starting RealProbe execution...\\\")\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"ip.write(0x00, 1)\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"isready = ip.read(0x00)\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"# === Monitor during execution ===\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"while( isready == 1 ):\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"    isready = ip.read(0x00)\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"    full_flags = ip.read(0x04) & $mask_hex\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"    for i in range($num_recorders):\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"        if (full_flags & (1 << i)) and not dumped_flags\[i\]:\","
lappend notebook_data "\"\\n\","
lappend notebook_data "\"            dump_recorder(i)\""
lappend notebook_data "\]"
lappend notebook_data "\}"

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

set num_recorders [llength $depths]

lappend notebook_data \{
lappend notebook_data "\"cell_type\": \"code\","
lappend notebook_data "\"execution_count\": null,"
lappend notebook_data "\"metadata\": \{\},"
lappend notebook_data "\"outputs\": \[\],"
lappend notebook_data "\"source\": \["
lappend notebook_data "\"# AXI address offsets\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"READ_INDEX_ADDR = 0x190  # (7'd100 << 2)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"# Mapping for recorders and their base address offsets\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"recorder_info = \[\""
lappend notebook_data "\"\\n\""
for {set i 0} {$i < $num_recorders} {incr i} {
    set name [lindex $ap_signals $i]
    set addr [format "0x%02X" [expr 0x08 + $i * 8]]
    lappend notebook_data "\"    (\\\"$name\\\", $addr),\""
    lappend notebook_data "\"\\n\""
}
lappend notebook_data "\"\]\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"\\n\""
set depths_line "recorder_depths = \["
foreach d $depths {
    append depths_line "$d, "
}
set depths_line [string trimright $depths_line ", "]
append depths_line "\]"

# Store line in notebook_data with double escaping for Python code
lappend notebook_data "\"$depths_line\","
lappend notebook_data "\"\\n\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"# Read cycle times by recorder\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"def read_recorder_entries(name, base_addr, depth):\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"    print(f\\\"\\\\n=== {name} ===\\\")\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"    for index in range(depth):\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        bram.write(READ_INDEX_ADDR, index)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        start_addr = base_addr\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        end_addr = base_addr + 4\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        start_time = bram.read(start_addr)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        end_time = bram.read(end_addr)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        latency = end_time - start_time\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        print(f\\\"\\\[entry {{index}}\\\]: start={{start_time}}, end={{end_time}}, latency={{latency}}\\\")\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"# ✅ Loop by recorder name, then by index\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"for (name, base_addr), depth in zip(recorder_info, recorder_depths):\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"    read_recorder_entries(name, base_addr, depth)\""
lappend notebook_data "\"\\n\""
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
# === Waveform Plotting Cell ===
lappend notebook_data "\"import matplotlib.pyplot as plt\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"# === Recorder configuration ===\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"recorder_info = \[\""
lappend notebook_data "\"\\n\""
for {set i 0} {$i < $num_recorders} {incr i} {
    set name [lindex $ap_signals $i]
    set addr [format "0x%02X" [expr 0x08 + $i * 8]]
    lappend notebook_data "\"    (\\\"$name\\\", $addr),\""
    lappend notebook_data "\"\\n\""
}
lappend notebook_data "\"\]\""
lappend notebook_data "\"\\n\""


set depths_line "recorder_depths = \["
foreach d $depths {
    append depths_line "$d, "
}
set depths_line [string trimright $depths_line ", "]
append depths_line "\]"

# Store line in notebook_data with double escaping for Python code
lappend notebook_data "\"$depths_line\","
lappend notebook_data "\"\\n\""
lappend notebook_data "\"READ_INDEX_ADDR = 0x190\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"\\n\""

# Data collection logic
lappend notebook_data "\"# === Collect data from BRAM ===\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"waveform_data = \[\]\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"for (name, base_addr), depth in zip(recorder_info, recorder_depths):\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"    entries = \[\]\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"    for index in range(depth):\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        bram.write(READ_INDEX_ADDR, index)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        start = bram.read(base_addr)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        end = bram.read(base_addr + 4)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        latency = end - start\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        if latency > 0:\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"            entries.append((start, latency))\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"    waveform_data.append((name, entries))\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"\\n\""

# Plotting logic
lappend notebook_data "\"# === Plot waveform ===\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"fig, ax = plt.subplots(figsize=(12, 4))\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"yticks = \[\]\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"yticklabels = \[\]\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"y_offset = 10  # vertical spacing between recorders\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"bar_height = 6\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"y = 0\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"for name, segments in waveform_data:\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"    if segments:\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        ax.broken_barh(segments, (y, bar_height), facecolors='tab:blue')\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        yticks.append(y + bar_height / 2)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        yticklabels.append(name)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"        y += y_offset\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"ax.set_xlabel('Clock Cycles')\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"ax.set_yticks(yticks)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"ax.set_yticklabels(yticklabels)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"ax.grid(True)\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"ax.set_title(\\\"RealProbe Execution Timeline\\\")\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"plt.tight_layout()\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\"plt.show()\""
lappend notebook_data "\"\\n\""
lappend notebook_data "\]"
lappend notebook_data \}

lappend notebook_data \]

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
set notebook_filename "$scriptDir/rprobe/fpga.ipynb"
set notebook_file [open $notebook_filename w]

# Write notebook data to file
foreach line $notebook_data {
    puts $notebook_file $line
}

close $notebook_file
