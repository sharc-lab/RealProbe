set RP_PATH $arg1 
set PRJ_NAME $arg2
set SOL_NAME $arg3 
global PRJ_NAME SOL_NAME RP_PATH

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

proc generateCompileTcl {hlsPath} {
    global PRJ_NAME
    global SOL_NAME
    global RP_PATH

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

    set boardsPynqz2Path [file join $hlsPath "vivado"]
    set compileTclPath "${PRJ_NAME}/${SOL_NAME}/update_vivado.tcl"

    set file [open $compileTclPath "w"]
    puts $file "set prjname $prjname"
    puts $file "set userIP $userIP"
    puts $file "set boardspath $boardsPynqz2Path"
    puts $file "set solpath $solPath"

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
    puts $file "open_project $prjname"
    puts $file "current_project $prjname"
    puts $file "update_compile_order -fileset sources_1"
    puts $file "update_module_reference design_1_realprobe_ip_0_0"
       
    set apsignals [readAndRememberLines $top_signal_path]
    foreach signal $apsignals {
        puts $file "connect_bd_net -quiet \[get_bd_pins ${userIP}_0/$signal\] \[get_bd_pins realprobe_ip_0/$signal\]"
    }

    puts $file "regenerate_bd_layout"
    puts $file "validate_bd_design"
    puts $file "make_wrapper -files \[get_files $boardsPynqz2Path/$prjname.srcs/sources_1/bd/design_1/design_1.bd\] -top"
    puts $file "add_files -norecurse $boardsPynqz2Path/$prjname.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v"
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
