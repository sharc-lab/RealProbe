global PRJ_NAME SOL_NAME

proc read_file {filename} {
    set f [open $filename r]
    set data [read $f]
    close $f
    return $data
}

proc backup_verilog_folder {full_path} {
    set original_path [file join $full_path "impl" "ip" "hdl" "verilog"]
    set backup_path [file join $full_path "impl" "ip" "hdl" "verilog_orgn"]

    if {[file exists $original_path]} {
        if {![file exists $backup_path]} {
            file mkdir $backup_path
        }
        foreach item [glob -directory $original_path *] {
            set item_name [file tail $item]
            set dest_path [file join $backup_path $item_name]
            if {[file isdirectory $item]} {
                file copy -force -- $item $dest_path
            } else {
                file copy -force -- $item $backup_path
            }
        }
    } else {
    }
}

proc get_top_name {full_path} {
    set tcl_file_path [file join $full_path ".autopilot" "db" "kernel_module_hierarchy.tcl"]
    set top_name ""

    if {[file exists $tcl_file_path]} {
        set file_data [read [open $tcl_file_path]]
        if {[regexp {"Name"\s*:\s*"([^"]+)"} $file_data -> top_name]} {
            set top_file [open "top.txt" w]
            puts $top_file $top_name
            close $top_file
        }
    }
    return $top_name
}

proc dump_to_txt {full_path verilog_module is_top_module direct_callers_str top_name} {
    if {$direct_callers_str eq "none"} {
        puts "No above functions for $verilog_module. Skipping txt file creation."
        return
    }

    set directory [file join $full_path "impl" "ip" "hdl" "verilog"]
    if {$is_top_module} {
        set filepath [file join $directory "${verilog_module}_top.txt"]
    } else {
        set filepath [file join $directory "${top_name}_${verilog_module}_top.txt"]
    }

    set file [open $filepath w]
    puts $file $direct_callers_str
    close $file
    # puts "Extraction completed for $filepath"
}

# Define a procedure to parse the JSON-like data using regex and build the module hierarchy
proc parse_json {filename} {
    set file [open $filename]
    set content [read $file]
    close $file

    # Regex to find module hierarchy based on indentation and ModuleName
    set pattern {^\s*(\"ModuleName\"\s*:\s*\"([^\"]+)\")}
    set modules [dict create]
    set stack [list]
    set last_indent -1

    foreach line [split $content "\n"] {
        if {[regexp -- $pattern $line match _ modulename]} {
            set indent [string first "\"" $line]
            while {$indent <= $last_indent} {
                set stack [lrange $stack 0 end-1]
                incr last_indent -2
            }
            lappend stack $modulename
            set last_indent $indent

            # Record the hierarchy path for each module
            dict set modules $modulename $stack
        }
    }
    return $modules
}

# Main procedure
proc main {} {
    global PRJ_NAME
    global SOL_NAME
    
    set full_path "[pwd]/${PRJ_NAME}/${SOL_NAME}"
    set json_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/${SOL_NAME}_data.json"

    backup_verilog_folder $full_path
    set top_name [get_top_name $full_path]
    set data [parse_json $json_path]

    # Ensure the directory exists
    set rprobe_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe"
    file mkdir $rprobe_path

    set module_name_path [file join $rprobe_path "module_name.txt"]
    set hierarchy_num_path [file join $rprobe_path "hierarchy_num.txt"]
    set abov_func_path [file join $rprobe_path "abov_func.txt"]
    set direct_calls_path [file join $rprobe_path "direct_calls.txt"]
    set hierarchy_sort_path [file join $rprobe_path "hierarchy_sort_modules.txt"]

    # Initialize files for writing
    set module_name_file [open $module_name_path "w"]
    set hierarchy_num_file [open $hierarchy_num_path "w"]
    set abov_func_file [open $abov_func_path "w"]
    set direct_calls_file [open $direct_calls_path "w"]
    set hierarchy_sort_file [open $hierarchy_sort_path "w"]

    # Prepare a list of modules sorted by their hierarchy depth
    set module_depths [list]
    foreach module [dict keys $data] {
        lappend module_depths [list $module [llength [dict get $data $module]]]
        puts $module_name_file $module
    }
    set sorted_modules [lsort -decreasing -integer -index 1 $module_depths]

    foreach item $module_depths {
        set module_tmp [lindex $item 0]
        set hierarchy [dict get $data $module_tmp]
        puts $hierarchy_num_file [expr {[llength $hierarchy] - 1}]
    }

    foreach item $sorted_modules {
        set module [lindex $item 0]
        set hierarchy [dict get $data $module]

        if {$module eq $top_name} {
            set module_is_top 1
        } else {
            set module_is_top 0
        }
        
        set direct_caller [lindex $hierarchy end-1]
        if {$direct_caller eq "" || $direct_caller eq $module} {
            puts $abov_func_file "$module: none"
        } else {
            puts $abov_func_file "$module: $direct_caller"
            dump_to_txt $full_path $module $module_is_top $direct_caller $top_name
        }
        puts $direct_calls_file "$module -> $direct_caller"
        puts $hierarchy_sort_file $module
    }

    close $module_name_file
    close $hierarchy_num_file
    close $abov_func_file
    close $direct_calls_file
    close $hierarchy_sort_file
}

proc isloop {} {
    global PRJ_NAME
    global SOL_NAME

    set json_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/${SOL_NAME}_data.json"
    set json_data [read_file $json_path]

    set modules_list_filename "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/module_name.txt"
    set module_names [read_file $modules_list_filename]

    set line_number 0
    set brace_count 0
    set in_metrics 0
    set module_start_lines [list]
    set module_names_list [list]

    set filtered_module_list [list]
    foreach name $module_names {
        if {[string trim $name] ne ""} {
            lappend filtered_module_list $name
        }
    }

    set module_has_loops [lrepeat [llength $filtered_module_list] 0]

    foreach line [split $json_data \n] {
        incr line_number

        if {[regexp {^\s*"Metrics"\s*:\s*\{} $line]} {
            set in_metrics 1
            set brace_count 1
        } elseif {$in_metrics} {
            # Adjust brace count based on line content
            if {[regexp {\{} $line]} {
                incr brace_count
            }
            if {[regexp {\}} $line]} {
                incr brace_count -1
            }

            set idx 0
            foreach module_name $filtered_module_list {
                if {[string match *"$module_name"* $line]} {
                    # puts "Module name '$module_name' appears at line: $line_number"
                    set current_module $module_name
                    set module_found $idx
                    lappend module_start_lines $line_number
                    lappend module_names_list $module_name
                }
                incr idx
            }

            if {[string match *Loops* $line]} {
                # puts "Loops found at line: $line_number inside $current_module"
                lset module_has_loops $module_found 1
            }

            if {$brace_count == 0} {
                # puts "Metrics ends at line: $line_number"
                break
            }
        }
    }

    set file [open "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/loop.txt" "w"]
    foreach loop_status $module_has_loops {
        puts $file $loop_status
    }
    close $file
}

main
isloop