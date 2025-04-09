global PRJ_NAME SOL_NAME RP_PATH BUILD_PATH

set inputFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/hierarchy_sort_modules.txt"
set outputDirectory "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/"
# Read the contents of top.txt
set top_txt_content [open "top.txt" r]
set topModule [gets $top_txt_content]
close $top_txt_content


# Read the hierarchy_sort_module.txt file
set inputFileContent [read [open $inputFileName "r"]]
set lines [split $inputFileContent "\n"]

# Remove empty lines from a list of lines
proc remove_empty_lines {lines} {
    set non_empty_lines [list]
    foreach line $lines {
        if {[string trim $line] ne ""} {
            lappend non_empty_lines $line
        }
    }
    return $non_empty_lines
}

proc prepend_to_file {filename content} {
    if {[file exists $filename]} {
        # Read the existing file content
        set file [open $filename r]
        set existing_content [read $file]
        close $file

        # Write new content followed by the existing content
        set file [open $filename w]
        puts $file $content
        puts $file $existing_content
        close $file
    } else {
        puts "File $filename does not exist."
    }
}

foreach line $lines {
    if {[string length [string trim $line]] > 0} {
        if {$line eq ${topModule}} {
            set originalVerilogFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}.v"
            set portFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}_port.txt"
            set outputFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}_output.txt"
            set topFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}_top.txt"
            set wireFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}_wire.txt"
            set fcallFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}_fcall.txt"
            set underFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}_under.txt"
            set line_module "${line}"
        } else {
            set originalVerilogFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}.v"
            set portFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}_port.txt"
            set outputFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}_output.txt"
            set topFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}_top.txt"
            set wireFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}_wire.txt"
            set fcallFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}_fcall.txt"
            set underFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}_under.txt"
            set line_module "${topModule}_${line}"
        }

        # if {$line eq ${topModule}} {
        #     # ap_done signal adding
        #     set topPortFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_port.txt"
        #     set topOutputFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_output.txt"
        #     set apdoneFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/apdone_signals.txt"

        #     if {[file exists $topPortFileName]} {
        #         set topPortFile [open $topPortFileName "a"]
        #         puts $topPortFile "ap_done_out,"
        #         close $topPortFile
        #     } else {
        #         puts "Could not add ap_done signal to Port information because txt file not found for top module $topModule."
        #     }
           
        #     if {[file exists $topOutputFileName]} {
        #         set topOutputFile [open $topOutputFileName "a"]
        #         puts $topOutputFile "wire ap_done_out = ap_done;"
        #         puts $topOutputFile "output ap_done_out;"
        #         close $topOutputFile
        #     } else {
        #         puts "Could not add ap_done signal to output information because txt file not found for top module $topModule."
        #     }

        #     if {[file exists $apdoneFileName]} {
        #         set apdoneFile [open $apdoneFileName "a"]
        #         puts $apdoneFile "ap_done_out"
        #         close $apdoneFile
        #     } else {
        #         puts "Could not add ap_done signal to output information because txt file not found for top module $topModule."
        #     }
        # }

        if {$line eq ${topModule}} {
            # File paths
            set topPortFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_port.txt"
            set topOutputFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_output.txt"
            set apdoneFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/apdone_signals.txt"

            if {[file exists $apdoneFileName]} {
                set apdoneContent [read [open $apdoneFileName r]]
                if {![regexp {\bap_done\b} $apdoneContent]} {
                    # Update the port file (prepend ap_done_out,)
                    if {[file exists $topPortFileName]} {
                        prepend_to_file $topPortFileName "ap_done_out,"
                    } else {
                        puts "Could not add ap_done signal to Port information because txt file not found for top module $topModule."
                    }

                    # Update the output file (prepend wire and output declarations)
                    if {[file exists $topOutputFileName]} {
                        prepend_to_file $topOutputFileName "wire ap_done_out = ap_done;\noutput ap_done_out;"
                    } else {
                        puts "Could not add ap_done signal to output information because txt file not found for top module $topModule."
                    }

                    # Update the apdone signals file (prepend ap_done_out)
                    if {[file exists $apdoneFileName]} {
                        prepend_to_file $apdoneFileName "ap_done_out"
                    } else {
                        puts "Could not add ap_done signal to output information because txt file not found for top module $topModule."
                    }
                } else {
                   puts "ap_done found in $apdoneFileName. Skipping updates to other files."
                }
            } else {
                # puts "apdone_signals.txt not found. Skipping updates to other files."
                # Create the file and add "ap_done_out"
                puts "apdone_signals.txt not found. Creating the file and adding ap_done_out."
                set apdoneFile [open $apdoneFileName "w"]
                puts $apdoneFile "ap_done_out"
                close $apdoneFile

                # Modify topPortFile
                if {[file exists $topPortFileName]} {
                    set topPortFile [open $topPortFileName "a"]
                    puts $topPortFile "ap_done_out,"
                    close $topPortFile
                } else {
                    puts "Could not add ap_done signal to Port information because txt file not found for top module $topModule."
                }

                # Modify topOutputFile
                if {[file exists $topOutputFileName]} {
                    set topOutputFile [open $topOutputFileName "a"]
                    puts $topOutputFile "wire ap_done_out = ap_done;"
                    puts $topOutputFile "output ap_done_out;"
                    close $topOutputFile
                } else {
                    puts "Could not add ap_done signal to output information because txt file not found for top module $topModule."
                }

            }
        }

        # Check if port information txt file exists
        if {[file exists $portFileName]} {
            if {$line eq ${topModule}} {
                set verilogFileName [file join $outputDirectory "${line}.v"]
            } else {
                set verilogFileName [file join $outputDirectory "${topModule}_${line}.v"]
            }
            
            # Insertion Ports for Verilog file
            set inputFile $portFileName
            set outputFile $verilogFileName
            set insertionPoint "module "
            append insertionPoint $line_module
            append insertionPoint " ("

            set inFileOpen [open $inputFile "r"]
            set inputFileContent [read $inFileOpen]
            close $inFileOpen
            set outFileOpen [open $outputFile "r"]
            set outputFileContent [read $outFileOpen]
            close $outFileOpen

            set index [string first $insertionPoint $outputFileContent]

            if {$index == -1} {
                error "Insertion point not found in the output file."
            }

            set lines [split $inputFileContent "\n"]
            set insertionEnd [string first "\n" $outputFileContent $index]

            if {[string first [join $lines "\n"] [string range $outputFileContent $insertionEnd end]] == -1} {
                set updatedContent [string range $outputFileContent 0 $insertionEnd]
                append updatedContent "\n[join $lines "\n"]"
                append updatedContent [string range $outputFileContent $insertionEnd end]

                # seek [open $outputFile "r+"] $index start
                set outFileOpen [open $outputFile "w"]
                puts -nonewline $outFileOpen $updatedContent
                close $outFileOpen
            } else {
                puts "Lines already exist in the file."
            }

            # Insertion Outputs for Verilog file
            set inputFile $outputFileName
            set insertionPoint "output"

            set inFileOpen [open $inputFile "r"]
            set inputFileContent [read $inFileOpen]
            close $inFileOpen
            set outFileOpen [open $outputFile "r"]
            set outputFileContent [read $outFileOpen]
            close $outFileOpen

            set index [string last $insertionPoint $outputFileContent]

            if {$index == -1} {
                error "Insertion point not found in the output file."
            }

            set lines [split $inputFileContent "\n"]
            set insertionEnd [string first "\n" $outputFileContent $index]

            if {[string first [join $lines "\n"] [string range $outputFileContent $insertionEnd end]] == -1} {
                set updatedContent [string range $outputFileContent 0 $insertionEnd]
                append updatedContent "\n[join $lines "\n"]"
                append updatedContent [string range $outputFileContent $insertionEnd end]

                # seek [open $outputFile "r+"] $index start
                set outFileOpen [open $outputFile "w"]
                puts -nonewline $outFileOpen $updatedContent
                close $outFileOpen
            } else {
                puts "Lines already exist in the file."
            }

        } else {
            puts "Port information txt file not found for module $line."
        }

        # # accumulate ports
        if {[file exists $topFileName]} {
            set topLines [split [read [open $topFileName "r"]] "\n"]
            set topLines [remove_empty_lines $topLines]
            
            foreach top_line $topLines {
                # Trim the line to avoid issues with trailing spaces
                set top_line [string trim $top_line]

                # Skip processing for completely blank lines
                if {[string length $top_line] == 0} {
                    continue
                }

                if {$top_line eq ${topModule}} {
                    set verilogFileName [file join $outputDirectory "${top_line}.v"]
                    set topPortFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${top_line}_port.txt"
                    set topOutputFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${top_line}_output.txt"
                    set topWireFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${top_line}_wire.txt"
                    set topFcallFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${top_line}_fcall.txt"
                    set topUnderFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${top_line}_under.txt"
                    set line_module "${top_line}"
                } else {
                    set verilogFileName [file join $outputDirectory "${topModule}_${top_line}.v"]
                    set topPortFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${top_line}_port.txt"
                    set topOutputFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${top_line}_output.txt"
                    set topWireFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${top_line}_wire.txt"
                    set topFcallFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${top_line}_fcall.txt"
                    set topUnderFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${top_line}_under.txt"
                    set line_module "${topModule}_${top_line}"
                }

                # port
                if {[file exists $topPortFileName]} {
                    set topPortContent [read [open $topPortFileName "r"]]
                    append topPortContent [read [open $portFileName "r"]]

                    set topPortFile [open $topPortFileName "w"]
                    puts -nonewline $topPortFile $topPortContent
                    # puts $topPortFile "ap_done_out,"
                    close $topPortFile
                } else {
                    puts "Port information txt file not found for top module $top_line."
                }

                # output
                if {[file exists $topOutputFileName]} {
                    set topOutputContent [read [open $topOutputFileName "r"]]
                    append topOutputContent [read [open $outputFileName "r"]]

                    set topOutputFile [open $topOutputFileName "w"]
                    puts -nonewline $topOutputFile $topOutputContent
                    # puts $topOutputFile "wire ap_done_out = ap_done;"
                    # puts $topOutputFile "output ap_done_out;"
                    close $topOutputFile
                } else {
                    puts "Output information txt file not found for top module $top_line."
                }

                # wire
                if {[file exists $topWireFileName]} {
                    set topWireContent [read [open $topWireFileName "r"]]
                    append topWireContent [read [open $wireFileName "r"]]

                    set topWireFile [open $topWireFileName "w"]
                    puts -nonewline $topWireFile $topWireContent
                    # puts "wire ap_done_out = ap_done;"
                    close $topWireFile
                } else {
                    puts "Wire information txt file not found for top module $top_line."
                }

                # fcall
                if {[file exists $topFcallFileName]} {
                    set topFcallContent [read [open $topFcallFileName "r"]]
                    append topFcallContent [read [open $fcallFileName "r"]]

                    set topFcallFile [open $topFcallFileName "w"]
                    puts -nonewline $topFcallFile $topFcallContent
                    close $topFcallFile
                } else {
                    puts "Fcall information txt file not found for top module $top_line."
                }

                # under
                if {[file exists $topUnderFileName]} {
                    set topUnderContent [read [open $topUnderFileName "r"]]
                    append topUnderContent [read [open $underFileName "r"]]

                    set topUnderFile [open $topUnderFileName "w"]
                    puts -nonewline $topUnderFile $topUnderContent
                    close $topUnderFile
                } else {
                    puts "Under information txt file not found for top module $top_line."
                }
            }

        } else {
            puts "No _top.txt file found for module $line_module."
        }



    }
}