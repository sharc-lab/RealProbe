global PRJ_NAME SOL_NAME RP_PATH BUILD_PATH

# Specify the input and output file paths
set input_file "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/apstart_signals.txt"
set output_file "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/rprobe_xml_ports.txt"

# Read input from the specified input file
set input [open $input_file r]
set input_data [read $input]
close $input

# Split the input data into a list of lines
set lines [split $input_data "\n"]

# Open the specified output file for writing
set output [open $output_file w]

# Iterate through each line
foreach line $lines {
    # Trim leading and trailing whitespaces
    set line [string trim $line]

    # Check if the line is not empty
    if {[string length $line] > 0} {
        # Format the line and write to the output file
        # puts $output "$line"       
        # Generate the XML part for each line
        puts $output "      <spirit:port>"
        puts $output "        <spirit:name>$line</spirit:name>"
        puts $output "        <spirit:wire>"
        puts $output "          <spirit:direction>out</spirit:direction>"
        puts $output "          <spirit:wireTypeDefs>"
        puts $output "            <spirit:wireTypeDef>"
        puts $output "              <spirit:typeName>std_logic</spirit:typeName>"
        puts $output "              <spirit:viewNameRef>xilinx_verilogsynthesis</spirit:viewNameRef>"
        puts $output "              <spirit:viewNameRef>xilinx_verilogbehavioralsimulation</spirit:viewNameRef>"
        puts $output "            </spirit:wireTypeDef>"
        puts $output "          </spirit:wireTypeDefs>"
        puts $output "        </spirit:wire>"
        puts $output "      </spirit:port>"
    }
}

close $output

# Specify the input and output file paths
set input_file "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/apdone_signals.txt"
set output_file "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/rprobe_xml_ports.txt"

# Read input from the specified input file
set input [open $input_file r]
set input_data [read $input]
close $input

# Split the input data into a list of lines
set lines [split $input_data "\n"]

# Open the specified output file for writing
set output [open $output_file a]

# Iterate through each line
foreach line $lines {
    # Trim leading and trailing whitespaces
    set line [string trim $line]

    # Check if the line is not empty
    if {[string length $line] > 0} {
        # Format the line and write to the output file
        # puts $output "$line"       
        # Generate the XML part for each line
        puts $output "      <spirit:port>"
        puts $output "        <spirit:name>$line</spirit:name>"
        puts $output "        <spirit:wire>"
        puts $output "          <spirit:direction>out</spirit:direction>"
        puts $output "          <spirit:wireTypeDefs>"
        puts $output "            <spirit:wireTypeDef>"
        puts $output "              <spirit:typeName>std_logic</spirit:typeName>"
        puts $output "              <spirit:viewNameRef>xilinx_verilogsynthesis</spirit:viewNameRef>"
        puts $output "              <spirit:viewNameRef>xilinx_verilogbehavioralsimulation</spirit:viewNameRef>"
        puts $output "            </spirit:wireTypeDef>"
        puts $output "          </spirit:wireTypeDefs>"
        puts $output "        </spirit:wire>"
        puts $output "      </spirit:port>"
    }
}


# Close the output file
close $output