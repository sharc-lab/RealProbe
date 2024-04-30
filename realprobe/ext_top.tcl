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
        puts [concat "top_line: " $line]
        puts [concat "topModule: " $topModule]

        # 1) Find the corresponding Verilog file
        if {$line eq ${topModule}} {
            set originalVerilogFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}.v"
            set portFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}_port.txt"
            set outputFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}_output.txt"
            set topFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}_top.txt"
            set wireFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}_wire.txt"
            set fcallFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}_fcall.txt"
            set line_module "${line}"
        } else {
            set originalVerilogFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}.v"
            set portFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}_port.txt"
            set outputFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}_output.txt"
            set topFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}_top.txt"
            set wireFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}_wire.txt"
            set fcallFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}_fcall.txt"
            set line_module "${topModule}_${line}"
        }

        # New Functionality: Check if _top.txt file exists
        if {[file exists $topFileName]} {
            set topLines [split [read [open $topFileName "r"]] "\n"]
            
            foreach top_line $topLines {
                if {[string length [string trim $top_line]] > 0} {

                    if {$top_line eq ${topModule}} {
                        set verilogFileName [file join $outputDirectory "${top_line}.v"]
                        set topPortFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${top_line}_port.txt"
                        set topOutputFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${top_line}_output.txt"
                        set line_module "${top_line}"
                    } else {
                        set verilogFileName [file join $outputDirectory "${topModule}_${top_line}.v"]
                        set topPortFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${top_line}_port.txt"
                        set topOutputFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${top_line}_output.txt"
                        set line_module "${topModule}_${top_line}"
                    }

                    # # New Functionality: Find last sentence in $line_module.v starting either with wire or reg
                    set outputFile $verilogFileName
                    set inputFile $wireFileName
                    set insertionPoint "wire"

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

                    set lines_tmp [split $inputFileContent "\n"]
                    set insertionEnd [string first "\n" $outputFileContent $index]

                    set updatedContent [string range $outputFileContent 0 $insertionEnd]
                    append updatedContent "\n[join $lines_tmp \n]"
                    append updatedContent [string range $outputFileContent $insertionEnd end]

                    set outFileOpen [open $outputFile "w"]
                    puts -nonewline $outFileOpen $updatedContent
                    close $outFileOpen
                }
            }
        open $topFileName
        } else {
            puts "No _top.txt file found for module $line_module."
        }
    }
}