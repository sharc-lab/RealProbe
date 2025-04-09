# global PRJ_NAME SOL_NAME

set PRJ_NAME project
set SOL_NAME solution1

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

proc parse_json {filename} {
    set file [open $filename]
    set content [read $file]
    close $file

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

proc extract_metrics {} {
    global PRJ_NAME
    global SOL_NAME

    set json_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/${SOL_NAME}_data.json"
    set json_data [read_file $json_path]

    set modules_list_filename "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/module_name.txt"
    set module_names [read_file $modules_list_filename]

    set est_latency_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/est_latency.txt"
    set est_tripcount_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/est_tripcount.txt"

    set latency_file [open $est_latency_path "w"]
    set tripcount_file [open $est_tripcount_path "w"]

    set line_number 0
    set brace_count 0
    set in_metrics 0
    set module_start_lines [list]
    set module_names_list [list]

    set filtered_module_list [list]
    foreach name [split $module_names \n] {
        if {[string trim $name] ne ""} {
            lappend filtered_module_list $name
        }
    }

    set module_tripcounts [dict create]

    foreach line [split $json_data \n] {
        incr line_number

        if {[regexp {^\s*"Metrics"\s*:\s*\{} $line]} {
            set in_metrics 1
            set brace_count 1

            set idx 0
            foreach module_name $filtered_module_list {
                if {[string match *"$module_name"* $line]} {
                    set current_module $module_name
                    set module_found $idx
                }
                incr idx
            }
        } elseif {$in_metrics} {
            if {[regexp {\{} $line]} {
                incr brace_count
            }
            if {[regexp {\}} $line]} {
                incr brace_count -1
            }

            set idx 0
            foreach module_name $filtered_module_list {
                if {[string match *"$module_name"* $line]} {
                    set current_module $module_name
                    set module_found $idx
                }
                incr idx
            }

            # Updated section for handling LatencyWorst
            if {[regexp {"LatencyWorst"\s*:\s*"(.*?)"} $line -> latency_raw]} {
                if {[string length $latency_raw] == 0} {
                    puts $latency_file "?"
                } elseif {[string is integer -strict $latency_raw]} {
                    puts $latency_file $latency_raw
                } else {
                    puts $latency_file "?"
                }
            }

            # Updated section for handling TripCount
            if {[regexp {"TripCount"\s*:\s*"(.*?)"} $line -> tripcount_raw]} {
                if {[string length $tripcount_raw] == 0} {
                    dict set module_tripcounts $current_module "?"
                } elseif {[string is integer -strict $tripcount_raw]} {
                    dict set module_tripcounts $current_module $tripcount_raw
                } else {
                    dict set module_tripcounts $current_module "?"
                }
            }

            if {$brace_count == 0} {
                set in_metrics 0
            }
        }
    }

    foreach module_name $filtered_module_list {
        if {[dict exists $module_tripcounts $module_name]} {
            set tripcount [dict get $module_tripcounts $module_name]
        } else {
            set tripcount 1
        }
        puts $tripcount_file "$tripcount"
    }

    close $latency_file
    close $tripcount_file
}
# proc extract_metrics {} {
#     global PRJ_NAME
#     global SOL_NAME

#     set json_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/${SOL_NAME}_data.json"
#     set json_data [read_file $json_path]

#     set modules_list_filename "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/module_name.txt"
#     set module_names [read_file $modules_list_filename]

#     set est_latency_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/est_latency.txt"
#     set est_tripcount_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/est_tripcount.txt"

#     set latency_file [open $est_latency_path "w"]
#     set tripcount_file [open $est_tripcount_path "w"]

#     set line_number 0
#     set brace_count 0
#     set in_metrics 0
#     set module_start_lines [list]
#     set module_names_list [list]

#     set filtered_module_list [list]
#     foreach name [split $module_names \n] {
#         if {[string trim $name] ne ""} {
#             lappend filtered_module_list $name
#         }
#     }

#     set module_tripcounts [dict create]

#     foreach line [split $json_data \n] {
#         incr line_number

#         if {[regexp {"([^"]+)"\s*:\s*\{.*} $line -> possible_module]} {
#             if {[lsearch -exact $filtered_module_list $possible_module] >= 0} {
#                 set current_module $possible_module
#                 set loop_counter($current_module) 0
#                 puts "Now parsing module: $current_module (line $line_number)"
#             }
#         }
#         if {[regexp {^\s*"Metrics"\s*:\s*\{} $line]} {
#             set in_metrics 1
#             set brace_count 1

#             set in_loops_section 0
#             set loop_brace_depth 0
#             set inside_loop_block 0

#             # Defer setting loop_counter until current_module is found
#             set idx 0
#             foreach module_name $filtered_module_list {
#                 if {[string match *"$module_name"* $line]} {
#                     set current_module $module_name
#                     set module_found $idx
#                     set loop_counter($current_module) 0 ;
#                 }
#                 incr idx
#             }
#         } elseif {$in_metrics} {
#             if {[regexp {\{} $line]} {
#                 incr brace_count
#             }
#             if {[regexp {\}} $line]} {
#                 incr brace_count -1
#             }

#             # set idx 0
#             # foreach module_name $filtered_module_list {
#             #     if {[string match *"$module_name"* $line]} {
#             #         set current_module $module_name
#             #         set module_found $idx
#             #     }
#             #     incr idx
#             # }

#             # if {[regexp {"([^"]+)"\s*:\s*\{.*} $line -> possible_module]} {
#             #     if {[lsearch -exact $filtered_module_list $possible_module] >= 0} {
#             #         set current_module $possible_module
#             #     }
#             # }

#             # Updated section for handling LatencyWorst
#             if {[regexp {"LatencyWorst"\s*:\s*"(.*?)"} $line -> latency_raw]} {
#                 if {[string length $latency_raw] == 0} {
#                     puts $latency_file "?"
#                 } elseif {[string is integer -strict $latency_raw]} {
#                     puts $latency_file $latency_raw
#                 } else {
#                     puts $latency_file "?"
#                 }
#             }

#             # Updated section for handling TripCount
#             # if {[regexp {"TripCount"\s*:\s*"(.*?)"} $line -> tripcount_raw]} {
#             #     if {![dict exists $module_tripcounts $current_module]} {
#             #         if {[string length $tripcount_raw] == 0} {
#             #             dict set module_tripcounts $current_module "?"
#             #         } elseif {[string is integer -strict $tripcount_raw]} {
#             #             dict set module_tripcounts $current_module $tripcount_raw
#             #         } else {
#             #             dict set module_tripcounts $current_module "?"
#             #         }
#             #     }
#             # }

#             # Detect start of top-level "Loops" section
#             if {[regexp {^\s*"Loops"\s*:\s*\[} $line]} {
#                 set in_loops_section 1
#                 set loop_brace_depth 0
#                 continue
#             }

#             if {$in_loops_section && [regexp {^\s*\{} $line]} {
#                 incr loop_brace_depth
#                 set inside_loop_block 1
#                 set tripcount_raw ""
#                 continue
#             }

#             # Inside a top-level loop block: extract TripCount
#             if {$inside_loop_block && [regexp {"TripCount"\s*:\s*"(.*?)"} $line -> tripcount_raw]} {
#                 incr loop_counter($current_module)
#                 set loop_id $loop_counter($current_module)
#                 set loop_key "${current_module}_loop$loop_id"

#                 if {[string length $tripcount_raw] == 0 || ![string is integer -strict $tripcount_raw]} {
#                     dict set module_tripcounts $loop_key "?"
#                 } else {
#                     dict set module_tripcounts $loop_key $tripcount_raw
#                 }

#                 puts "✅ $loop_key -> TripCount: [dict get $module_tripcounts $loop_key]"
#             }
#             # Catch TripCount directly inside the Metrics block (not in a loop)
#             if {!$inside_loop_block && $in_metrics && [regexp {"TripCount"\s*:\s*"(.*?)"} $line -> tripcount_raw]} {
#                 # Only add if it wasn't added already
#                 if {![dict exists $module_tripcounts "${current_module}_loop1"]} {
#                     dict set loop_counter($current_module) 1
#                     set loop_key "${current_module}_loop1"

#                     if {[string length $tripcount_raw] == 0 || ![string is integer -strict $tripcount_raw]} {
#                         dict set module_tripcounts $loop_key "?"
#                     } else {
#                         dict set module_tripcounts $loop_key $tripcount_raw
#                     }

#                     puts "⚡ $loop_key (direct TripCount) -> [dict get $module_tripcounts $loop_key]"
#                 }
#             }

#             # End of a loop block: look for closing brace
#             if {$inside_loop_block && [regexp {^\s*\}} $line]} {
#                 incr loop_brace_depth -1
#                 if {$loop_brace_depth == 0} {
#                     set inside_loop_block 0
#                 }
#             }

#             # Exit "Loops" section when array ends
#             if {$in_loops_section && [regexp {^\s*\]} $line]} {
#                 set in_loops_section 0
#             }


#             # === End TripCount block ===
#             if {$brace_count == 0} {
#                 set in_metrics 0
#             }
#         }
#     }

#     # foreach module_name $filtered_module_list {
#     #     if {[dict exists $module_tripcounts $module_name]} {
#     #         set tripcount [dict get $module_tripcounts $module_name]
#     #         puts "$module_name -> TripCount: $tripcount"
#     #     } else {
#     #         set tripcount 1
#     #     }
#     #     puts $tripcount_file "$tripcount"
#     # }

#     foreach module_name $filtered_module_list {
#         set loop_id 1
#         set has_output 0
#         set loop_tripcounts [list]

#         while {[dict exists $module_tripcounts "${module_name}_loop$loop_id"]} {
#             lappend loop_tripcounts [list $loop_id [dict get $module_tripcounts "${module_name}_loop$loop_id"]]
#             set has_output 1
#             incr loop_id
#         }

#         if {!$has_output} {
#             puts "$module_name -> TripCount: ?"
#             puts $tripcount_file "?"
#         } elseif {[llength $loop_tripcounts] == 1} {
#             # Only one loop → use base module name
#             set val [lindex [lindex $loop_tripcounts 0] 1]
#             puts "$module_name -> TripCount: $val"
#             puts $tripcount_file "$val"
#         } else {
#             # Multiple loops → include loop index in name
#             foreach loop_entry $loop_tripcounts {
#                 set id [lindex $loop_entry 0]
#                 set val [lindex $loop_entry 1]
#                 puts "${module_name}_loop${id} -> TripCount: $val"
#                 puts $tripcount_file "$val"
#             }
#         }
#     }

#     close $latency_file
#     close $tripcount_file
# }


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

proc count_lines_with_words {} {
    global PRJ_NAME
    global SOL_NAME

    set input_file "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/module_name.txt"
    set output_file "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/count_num_modules.txt"

    set count 0
    set file [open $input_file r]
    while {[gets $file line] >= 0} {
        if {[regexp {\w+} $line]} {
            incr count
        }
    }
    close $file

    set out_file [open $output_file w]
    puts $out_file $count
    close $out_file
}

proc process_tripcount {} {
    global PRJ_NAME
    global SOL_NAME

    # File paths
    set est_tripcount_file "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/est_tripcount.txt"
    set loop_info_file "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/loop.txt"
    set max_depth_file "[pwd]/../../realprobe/max_depth.txt"
    set conservative_tripcount_file "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/conservative_tripcount.txt"

        # Read max depth value
    set max_depth_file_handle [open $max_depth_file r]
    set max_depth [string trim [read $max_depth_file_handle]]
    close $max_depth_file_handle

    # Validate max depth
    if {[string is integer -strict $max_depth] == 0} {
        error "Invalid max depth value: $max_depth"
    }

    # Open input and output files
    set est_file [open $est_tripcount_file r]
    set loop_file [open $loop_info_file r]
    set output_file [open $conservative_tripcount_file w]

    # Process each line
    while {[gets $est_file est_line] >= 0 && [gets $loop_file loop_line] >= 0} {
        set est_tripcount [string trim $est_line]
        set is_loop [string trim $loop_line]

        if {$is_loop == "1"} {
            # If it's a loop module, set value to 4
            set result 4
        } else {
            if {$est_tripcount == "?"} {
                # Use max depth for "?"
                set result $max_depth
            } else {
                # Otherwise, double the trip count
                set result [expr {$est_tripcount * 2}]
            }
        }

        # Write result to output file
        puts $output_file $result
    }

    # Close files
    close $est_file
    close $loop_file
    close $output_file
}

proc parse_json_and_map_counts {input_file output_file} {
    # Open the input file for reading
    set file [open $input_file]
    set content [read $file]
    close $file

    # Open the output file for writing
    set out_file [open $output_file "w"]

    # Initialize variables
    set count 0
    set start_parsing 0
    set hierarchy_dict [dict create]

    # Iterate through each line of the JSON file
    foreach line [split $content "\n"] {
        # Trim leading/trailing spaces for easier pattern matching
        set line [string trim $line]

        # Check for the start of the hierarchy block
        if {!$start_parsing && [regexp {\"Hierarchy\":} $line]} {
            set start_parsing 1
            if {[regexp {\"ModuleName\":\s*\"([^\"]+)\"} $line _ module_name]} {
                puts $out_file "$count"
                dict set hierarchy_dict $module_name $count
            }
        }

        # If parsing has started
        if {$start_parsing} {
            puts "$line ---------------> $count"
            # Check for the "ModuleName": key
            if {[regexp {\"ModuleName\":\s*\"([^\"]+)\"} $line _ module_name]} {
                # Map the module name with the current count
                puts "only one file $module_name $count"
                puts $out_file "$count"
                dict set hierarchy_dict $module_name $count

            }

            # Check for the "Instances": key with [ to increase count
            if {[regexp {\"Instances\":\s*\[} $line]} {
                incr count
            }

            # Check for the closing bracket ] to decrease count
            if {[regexp {\]} $line]} {
                incr count -1
            }

            # Check for the "Info": key to stop parsing
            if {[regexp {\"Info\":} $line]} {
                break
            }
        }
    }

    # Close the output file
    close $out_file
    return $hierarchy_dict

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

    # # Prepare a list of modules sorted by their hierarchy depth
    # set module_depths [list]
    # foreach module [dict keys $data] {
    #     lappend module_depths [list $module [llength [dict get $data $module]]]
    #     puts $module_name_file $module
    # }
    # set sorted_modules [lsort -decreasing -integer -index 1 $module_depths]

    # puts "sorted module test $sorted_modules"

    set hierarchy [parse_json_and_map_counts $json_path $hierarchy_num_file]
    puts "hierarchy test: $hierarchy"

    # Prepare a list of modules with their depths
    set module_depths [list]
    foreach module [dict keys $hierarchy] {
        lappend module_depths [list $module [dict get $hierarchy $module]]
        puts $module_name_file $module
    }

    # Sort the modules by their depth (descending)
    set sorted_modules [lsort -decreasing -integer -index 1 $module_depths]

    # # Output sorted modules for debugging
    # puts "Sorted Modules by Hierarchy Depth:"
    # foreach item $sorted_modules {
    #     set module_name [lindex $item 0]
    #     set depth [lindex $item 1]
    #     puts "$module_name\t$depth"
    # }

    # foreach item $module_depths {
    #     set module_tmp [lindex $item 0]
    #     set hierarchy [dict get $data $module_tmp]
    #     puts $hierarchy_num_file [expr {[llength $hierarchy] - 1}]
    # }


    foreach item $sorted_modules {
        puts "item: $item"
        # puts "sorted_modules: $sorted_modules"
        set module [lindex $item 0]

        puts "data is this : $data"
        puts "module is this : $module"

        # problematic part
        if {[dict exists $data $module]} {
            set hierarchy [dict get $data $module]
        } else {
            puts "Warning: Module $module not found in hierarchy dict"
            puts $hierarchy_sort_file $module
            continue
        }

        if {$module eq $top_name} {
            set module_is_top 1
        } else {
            set module_is_top 0
        }

        # Fix: Ensure direct_caller is properly set
        if {[llength $hierarchy] > 1} {
            set direct_caller [lindex $hierarchy end-1]
        } else {
            # If no direct caller is found, map to the top module
            set direct_caller $top_name
        }

        # puts "also test, $direct_caller"

        # Write direct caller information
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

    extract_metrics
    isloop
    count_lines_with_words
    process_tripcount 

}

main
