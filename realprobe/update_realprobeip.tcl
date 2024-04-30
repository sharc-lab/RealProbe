set RP_PATH $arg1 
set PRJ_NAME $arg2
set SOL_NAME $arg3 
global PRJ_NAME SOL_NAME RP_PATH

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

set top_signal_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topmodulename}_${topupdatedmodulename}_under.txt"

# Optional: Check if the file exists at the newly set path
if { ![file exists $top_signal_path] } {
    puts "Error: The file '${top_signal_path}' does not exist."
}

# Read the list of signals from top_signal.txt
set signal_file [open $top_signal_path r]
set signals_raw [split [read $signal_file] "\n"]
close $signal_file

# Filter out blank lines from the signals list
set signals {}
foreach signal $signals_raw {
    if {[string length [string trim $signal]] > 0} {
        lappend signals $signal
    }
}

# Calculate the number of bits needed for addressing
set num_bits [expr {int(ceil(log([llength $signals])/log(2)))}]

# Check if the number of signals is 1, then assign num_bits to 1
if {[llength $signals] == 1} {
    set num_bits 1
}

# Generate Verilog module header
set verilog_code {module realprobe_ip (
    input   wire    [12:0]          axi_addr_32b,
    output  reg     [31:0]          axi_rdata_32b,
    input   wire    [31:0]          axi_wdata_32b,
    input   wire    [3:0]           axi_we_32b,
    input   wire                    axi_en_32b,}
foreach signal $signals {
    append verilog_code "\n    input   wire                    $signal,"
}
append verilog_code {
    input   wire                    clk,    // Active high
    input   wire                    rst     // Sync & Active-low
);


}

append verilog_code "reg  [[expr ${num_bits}-1]:0]  latched_axi_addr_32b;"

# Generate pc_out signals
set count 0
foreach signal $signals {
    append verilog_code "\nwire [31:0] pc_out$count;"
    incr count
}
append verilog_code {
assign axi_w = |axi_we_32b;
assign axi_r = ~axi_w;

always @(posedge clk)
}
        append verilog_code "\nif(axi_en_32b & axi_r) latched_axi_addr_32b <= axi_addr_32b[[expr ${num_bits} + 1]:2];"
append verilog_code {
always @*
    case(latched_axi_addr_32b)
}

# Generate case statements
for {set i 0} {$i < [llength $signals]} {incr i} {
    append verilog_code "\n            ${num_bits}'d$i : axi_rdata_32b = {pc_out[expr $i]};"
}
append verilog_code {
    endcase
}

append verilog_code {

program_counter pc_cntr(
    .clk(clk),
    .reset(rst),
}

set count 0
foreach signal $signals {
    append verilog_code "\n    .start${count}(${signal}),"
    incr count
}

set count_rec [expr $count - 1]

for {set i 0} {$i < ([llength $signals] - 1)} {incr i} {
    append verilog_code "\n    .pc${i}(pc_out${i}),"
}
append verilog_code "\n    .pc${count_rec}(pc_out${count_rec})"


append verilog_code {
);
endmodule
}



# Define the program_counter module
append verilog_code "\nmodule program_counter ("
append verilog_code "\n    input wire clk,"
append verilog_code "\n    input wire reset,"
# Generate input and output signals for program_counter module

set count 0
for {set i 0} {$i < ([llength $signals] - 1)} {incr i} {
    append verilog_code "\n    input wire start$count,"
    append verilog_code "\n    output reg [31:0] pc$count,"
    incr count
}
append verilog_code "\n    input wire start$count,"
append verilog_code "\n    output reg [31:0] pc$count"

append verilog_code "\n);"

# Generate always blocks
set count 0
foreach signal $signals {
    append verilog_code "\nalways @(posedge clk or negedge reset) begin"
    append verilog_code "\n    if (!reset) begin"
    append verilog_code "\n        pc$count <= 32'b0;"
    append verilog_code "\n    end else if (start$count) begin"
    append verilog_code "\n        pc$count <= pc$count + 1;"
    append verilog_code "\n    end else if ((!start$count)) begin"
    append verilog_code "\n    end"
    append verilog_code "\nend"
    incr count
}
append verilog_code "\nendmodule"

# Write generated Verilog code to a file
set verilog_file [open "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/realprobe_ip.v" w]
puts $verilog_file $verilog_code
close $verilog_file