global PRJ_NAME SOL_NAME RP_PATH BUILD_PATH

# Read the contents of top.txt
set top_txt_content [open "top.txt" r]
set topModule [gets $top_txt_content]
close $top_txt_content

set hls_ip "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/xilinx_com_hls_${topModule}_1_0.zip"
set rprobe_pc "[pwd]/${PRJ_NAME}/${SOL_NAME}/realprobe_ip.v"

set scripts_vivado_version 2023.1.1
set current_vivado_version [version -short]

set hls_ip_extSignals_xml "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/component.xml"
set hls_ip_extSignals_top "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}.v"

set rprobe_intf_txt "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/rprobe_xml_interfaces.txt"
set rprobe_port_txt "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/rprobe_xml_ports.txt"


# ################################################################
# # Create a backup of component.xml file
# ################################################################

set component_backup_file "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/component_orgn.xml"

if {[file exists $hls_ip_extSignals_xml]} {
    file copy -force $hls_ip_extSignals_xml $component_backup_file
    puts "Backup of component.xml file created: $component_backup_file"
} else {
    puts "Error: component.xml file not found."
}

# ################################################################
# # Change xml file to extern the signals of IP
# ################################################################

# add the interface of IP for RealProbe
set inputFile $rprobe_intf_txt
set outputFile $hls_ip_extSignals_xml
set insertionPoint "<spirit:portMaps>"

set inputFileOpen [open $inputFile "r"]
set inputFileContent [read $inputFileOpen]
close $inputFileOpen

set outputFileOpen [open $outputFile "r"]
set outputFileContent [read $outputFileOpen]
close $outputFileOpen

set index [string first $insertionPoint $outputFileContent]

if {$index == -1} {
    error "Insertion point not found in the output file."
}

set lines [split $inputFileContent "\n"]
set insertionEnd [string first "\n" $outputFileContent $index]

if {[string first [join $lines "\n"] [string range $outputFileContent $insertionEnd end]] == -1} {
    set updatedContent [string range $outputFileContent 0 $insertionEnd]
    append updatedContent "\n[join $lines "\n"]\n"
    append updatedContent [string range $outputFileContent $insertionEnd end]

    set outputFileHandle [open $outputFile "w"]
    puts -nonewline $outputFileHandle $updatedContent
    close $outputFileHandle
} else {
    puts "Lines already exist in the file."
}

# add the ports of IP RealProbe
set inputFile $rprobe_port_txt
set outputFile $hls_ip_extSignals_xml
set insertionPoint "</spirit:ports>"

set inputFileOpen [open $inputFile "r"]
set inputFileContent [read $inputFileOpen]
close $inputFileOpen

set outputFileOpen [open $outputFile "r"]
set outputFileContent [read $outputFileOpen]
close $outputFileOpen

set index [string first $insertionPoint $outputFileContent]

if {$index == -1} {
    error "Insertion point not found in the output file."
}

set lines [split $inputFileContent "\n"]
set insertionEnd $index-1

if {[string first [join $lines "\n"] [string range $outputFileContent 0 $insertionEnd]] == -1} {
    set updatedContent [string range $outputFileContent 0 $insertionEnd]
    append updatedContent "\n[join $lines "\n"]\n"
    append updatedContent [string range $outputFileContent $insertionEnd end]

    set outputFileHandle [open $outputFile "w"]
    puts -nonewline $outputFileHandle $updatedContent
    close $outputFileHandle
} else {
    puts "Lines already exist in the file."
}
