set RP_PATH $arg1 
set PRJ_NAME $arg2
set SOL_NAME $arg3 
set TARGET_DEV $arg4
global PRJ_NAME SOL_NAME RP_PATH TARGET_DEV

package require fileutil  ;# For file reading utilities

proc readAndRememberLines {filePath} {
    set rememberedLines {}
    if {![file exists $filePath]} {
        puts "Error: The file '$filePath' does not exist."
        return $rememberedLines
    }
    set file [open $filePath]
    while {[gets $file line] >= 0} {
        set strippedLine [string trim $line]
        if {[string length $strippedLine] > 0} {
            lappend rememberedLines $strippedLine
        }
    }
    close $file
    return $rememberedLines
}

proc findRecentSolutionFolder {projectPath} {
    set solutionFolders [glob -nocomplain -directory $projectPath solution*]
    if {[llength $solutionFolders] == 0} {
        return ""
    }
    set latestTime 0
    set latestFolder ""
    foreach folder $solutionFolders {
        set mtime [file mtime $folder]
        if {$mtime > $latestTime} {
            set latestTime $mtime
            set latestFolder $folder
        }
    }
    return $latestFolder
}

proc getUserIPAndPartname {hlsPath} {
    set hlsTclPath [file join $hlsPath "hls.tcl"]
    set userIP ""
    set partname ""
    set file [open $hlsTclPath]
    while {[gets $file line] >= 0} {
        if {[string match *set_top* $line]} {
            set userIP [lindex $line end]
        } elseif {[string match *set_part* $line]} {
            set partname [lindex $line end]
        }
    }
    close $file
    return [list $userIP $partname]
}

proc getPortsFromXML {solPath userIP} {
    set xmlFiles [glob -nocomplain [file join $solPath impl ip "${userIP}_info.xml"]]
    if {[llength $xmlFiles] == 0} {
        puts "Error !!!!!!!!!! no xml files!"
        return [list {} {}]
    }
    set xmlFile [lindex $xmlFiles 0]
    set fileData [fileutil::cat $xmlFile]
    set maxiMatches {}
    set matches [regexp -all -inline {<port\s+name="(M_AXI_\w+)"} $fileData]
    foreach {fullMatch portName} $matches {
        lappend maxiMatches $portName
    }
    set saxiMatches {}
    set matches [regexp -all -inline {<arg\s+name="(\w+)"\s+.*?port="S_AXI_CONTROL"} $fileData]
    foreach {fullMatch portName} $matches {
        lappend saxiMatches $portName
    }
    return [list $maxiMatches $saxiMatches]
}


proc generateCompileTcl {hlsPath} {
    global PRJ_NAME
    global SOL_NAME
    global RP_PATH
    global TARGET_DEV

    set prjname $PRJ_NAME
    lassign [getUserIPAndPartname $hlsPath] userIP partname
    if {$userIP eq "" || $partname eq ""} {
        puts "no"
        return 0
    }
    set prjpath [file join $hlsPath $prjname]
    set solPath [file join $prjpath $SOL_NAME]
    if {$solPath eq ""} {
        return 0
    }
    lassign [getPortsFromXML $solPath $userIP] maxiPorts saxiPorts
    set numMaxi [llength $maxiPorts]
    lappend saxiPorts "ap_return"
    set numSaxi [llength $saxiPorts]

    set boardsPynqz2Path [file join $hlsPath "vivado"]
    set compileTclPath "${PRJ_NAME}/${SOL_NAME}/basic_vivado.tcl"

    set file [open $compileTclPath "w"]
    puts $file "set prjname $prjname"
    puts $file "set userIP $userIP"
    puts $file "set partname $TARGET_DEV"
    puts $file "set boardspath $boardsPynqz2Path"
    puts $file "set solpath $solPath"
    puts $file "set num_maxi $numMaxi"
    puts $file "set num_saxi $numSaxi"
    for {set i 0} {$i < $numMaxi} {incr i} {
        set port [lindex $maxiPorts $i]
        set idx [expr {$i + 1}]
        puts $file "set maxi_port$idx [string tolower $port]"
    }
    for {set i 0} {$i < $numSaxi} {incr i} {
        set port [lindex $saxiPorts $i]
        set idx [expr {$i + 1}]
        puts $file "set saxi_port$idx [string tolower $port]"
    }

    puts $file {
################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2023.1
set current_vivado_version [version -short]
if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
puts ""
catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}
return 1
}
    }
    puts $file "\n"
    puts $file "create_project $prjname . -part {$TARGET_DEV}"
    puts $file "current_project $prjname"
    puts $file "create_bd_design \"design_1\""
    puts $file "set_property source_mgmt_mode All \[current_project\]"

    # puts $file "set_property AUTO_INCREMENTAL_CHECKPOINT.DIRECTORY $boardsPynqz2Path/$prjname.srcs/utils_1/imports/impl_1 \[get_runs impl_1\]"

    puts $file "update_compile_order -fileset sources_1"
    puts $file "startgroup"
    puts $file "create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0"
    puts $file "endgroup"
    puts $file "set_property ip_repo_paths $solPath \[current_project\]"
    puts $file "update_ip_catalog"
    puts $file "startgroup"
    puts $file "create_bd_cell -type ip -vlnv xilinx.com:hls:$userIP:1.0 ${userIP}_0"
    puts $file "endgroup"

    puts $file "set_property -dict \[list \\"
    for {set i 0} {$i < $numMaxi} {incr i} {
        puts $file "  CONFIG.PCW_USE_S_AXI_HP$i {1} \\"
    }
    puts $file "\] \[get_bd_cells processing_system7_0\]"

    puts $file "startgroup"
    puts $file "apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/${userIP}_0/s_axi_control} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}} \[get_bd_intf_pins ${userIP}_0/s_axi_control\]"
    for {set i 0} {$i < $numMaxi} {incr i} {
        set port [lindex $maxiPorts $i]
        puts $file "apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/${userIP}_0/[string tolower $port]} Slave {/processing_system7_0/S_AXI_HP$i} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}} \[get_bd_intf_pins processing_system7_0/S_AXI_HP$i\]"
    }

    puts $file "endgroup"

    puts $file "regenerate_bd_layout"
    puts $file "save_bd_design"
    puts $file "validate_bd_design"
    puts $file "make_wrapper -files \[get_files $boardsPynqz2Path/$prjname.srcs/sources_1/bd/design_1/design_1.bd\] -top"
    puts $file "add_files -norecurse $boardsPynqz2Path/$prjname.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v"
    puts $file "update_compile_order -fileset sources_1"
    puts $file "set_property top design_1_wrapper \[current_fileset\]"
    puts $file "update_compile_order -fileset sources_1"
    puts $file "set_property AUTO_INCREMENTAL_CHECKPOINT.DIRECTORY $boardsPynqz2Path/$prjname.srcs/utils_1/imports/impl_1 \[get_runs impl_1\]"

    puts $file "reset_runs synth_1"
    puts $file "launch_runs impl_1 -to_step write_bitstream -jobs 4"
    puts $file "wait_on_run impl_1"
    puts $file "close_project"
    puts $file "exit"

    close $file
    return 1
}

# Main routine to call generateCompileTcl
set currentPath [pwd]
generateCompileTcl $currentPath
