global PRJ_NAME SOL_NAME RP_PATH BUILD_PATH

# Procedure to read file content
proc read_file {filename} {
    set fileId [open $filename r]
    set content [read $fileId]
    close $fileId
    return $content
}

# Procedure to write content to a file
proc write_file {filename content} {
    set fileId [open $filename w]
    puts -nonewline $fileId $content
    close $fileId
}

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

        # 1) Find the corresponding Verilog file
        if {$line eq ${topModule}} {
            set topFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}_top.txt"
            set fcallFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${line}_fcall.txt"
            set line_module "${line}"
        } else {
            set topFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}_top.txt"
            set fcallFileName "[pwd]/${PRJ_NAME}/${SOL_NAME}/impl/ip/hdl/verilog/${topModule}_${line}_fcall.txt"
            set line_module "${topModule}_${line}"
        }
        # New Functionality: Check if _top.txt file exists
        if {[file exists $topFileName]} {
            set topLines [split [read [open $topFileName "r"]] "\n"]

            foreach top_line $topLines {
                if {[string length [string trim $top_line]] > 0} {
                    # New Functionality: Find insertion point in $verilogFileName.v

                    if {$top_line eq ${topModule}} {
                        set verilogFileName [file join $outputDirectory "${top_line}.v"]
                    } else {
                        set verilogFileName [file join $outputDirectory "${topModule}_${top_line}.v"]
                    }

                    # Read the content of GP_kernel_fcall.txt
                    set fcallContent [read_file $fcallFileName]

                    # Read the content of Verilog file
                    set verilogContent [read_file $verilogFileName]

                    # Find the line number containing the exact word "GP_kernel_top.txt"
                    set lines [split $verilogContent "\n"]

                    set modifiedContent [list]

                    foreach line $lines {
                        # Check if the line starts with the specified word
                        if {[string match -nocase "$line_module *" $line]} {
                            # Line starts with the specified word
                            lappend modifiedContent $line
                            # Append the content of GP_kernel_fcall.txt
                            lappend modifiedContent $fcallContent
                        } else {
                            # Line does not start with the specified word
                            lappend modifiedContent $line
                        }
                    }

                    # Join the lines back into a single string
                    set modifiedVerilogContent [join $modifiedContent "\n"]

                    # Write the modified content back to the Verilog file
                    write_file $verilogFileName $modifiedVerilogContent
                }
            }

            # Close the top file
            close [open $topFileName "r"]
        } else {
            puts "No _top.txt file found for module $line_module."
        }
    }
}
