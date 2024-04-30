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
            
            foreach top_line $topLines {
                if {[string length [string trim $top_line]] > 0} {
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
            }
        } else {
            puts "No _top.txt file found for module $line_module."
        }
    }
}