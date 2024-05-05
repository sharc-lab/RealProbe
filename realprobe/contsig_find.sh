CURR_PATH=$1
PROJECT_NAME=$2
SOLUTION_NAME=$3
FULL_PATH="$CURR_PATH/$PROJECT_NAME/$SOLUTION_NAME"

echo "HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!NO!!!!!!!!!!!!!!!!!!!!!!!!!"

total_count=0
index=0

echo -n > $FULL_PATH/rprobe/apstart_signals.txt  # Create or clear the output file
echo -n > $FULL_PATH/rprobe/module_apstart.txt  # Create or clear the output file

top_file_path="$CURR_PATH/top.txt"

# Echo the file path to verify it
echo "File path: $top_file_path"

top_module=$(<"$top_file_path" tr -d '[:space:]')

# Print the value of top_module to verify if it's empty
echo "top_module: \"$top_module\""


while IFS= read -r module_name; do

    echo "module: $module_name"
    echo "Top: $top_module, top_file_path: $top_file_path"


    index=$((index + 1))

    if [ "$module_name" = $top_module ]; then
        module_file="$FULL_PATH/impl/ip/hdl/verilog/${module_name}.v"
        dump_output="$FULL_PATH/impl/ip/hdl/verilog/${module_name}_output.txt"
        dump_wire="$FULL_PATH/impl/ip/hdl/verilog/${module_name}_wire.txt"
        dump_port="$FULL_PATH/impl/ip/hdl/verilog/${module_name}_port.txt"
        dump_fcall="$FULL_PATH/impl/ip/hdl/verilog/${module_name}_fcall.txt"
        dump_signal="$FULL_PATH/impl/ip/hdl/verilog/top_signal.txt"
        dump_under="$FULL_PATH/impl/ip/hdl/verilog/${module_name}_under.txt"
        delete_top="$FULL_PATH/impl/ip/hdl/verilog/${module_name}_top.txt"
    else
        module_file="$FULL_PATH/impl/ip/hdl/verilog/${top_module}_${module_name}.v"
        dump_output="$FULL_PATH/impl/ip/hdl/verilog/${top_module}_${module_name}_output.txt"
        dump_wire="$FULL_PATH/impl/ip/hdl/verilog/${top_module}_${module_name}_wire.txt"
        dump_port="$FULL_PATH/impl/ip/hdl/verilog/${top_module}_${module_name}_port.txt"
        dump_fcall="$FULL_PATH/impl/ip/hdl/verilog/${top_module}_${module_name}_fcall.txt"
        dump_signal="$FULL_PATH/impl/ip/hdl/verilog/${top_module}_${module_name}_signal.txt"
        dump_under="$FULL_PATH/impl/ip/hdl/verilog/${top_module}_${module_name}_under.txt"
        delete_top="$FULL_PATH/impl/ip/hdl/verilog/${top_module}_${module_name}_top.txt"
    fi

    if [ -f "$module_file" ]; then
        count=$(grep -o -nE "(wire|output(\s+)?wire|output) *?.*?ap_start;" "$module_file" | grep -v "ap_start_int" | grep -v "(wire).*\bap_start\b" | wc -l)
        total_count=$((total_count + count))
        # grep_output=$(grep -o -nE "(wire|output(\s+)?wire|output) *?.*?ap_start;" "$module_file" | sed -n 's/.*\b\(\w*ap_start\w*\)\b.*/\1/p' | grep -v "ap_start_int" | grep -v "(wire).*\bap_start\b")
        grep_output=$(grep -o -nE "(wire|output(\s+)?wire|output) *?.*?ap_start;" "$module_file" | grep -v "ap_start_int" | grep -v "(wire).*\bap_start\b" | sed -n 's/.*\b\(\w*ap_start\w*\)\b.*/\1/p')

        echo "$index. $(basename "$module_file")($count)\n$grep_output" >> $FULL_PATH/rprobe/module_apstart.txt

        if [ $count -gt 0 ]; then
            # echo -e "$grep_output" | sed 's/$/;/' | sed 's/^/output /' >> $dump_output
            # echo -e "$grep_output" | sed 's/$/;/' | sed 's/^/wire /' >> $dump_wire
            # echo -e "$grep_output" | sed 's/$/,/' | sed 's/^/        /' >> $dump_port
            # echo -e "$grep_output" >> $dump_signal
            # echo -e "$grep_output" >> $dump_under
            # echo -e "$grep_output" | sed 's/.*/.&(&),/' >> $dump_fcall
            echo "$grep_output" | sed 's/$/;/; s/^/output /' >> $dump_output
            echo "$grep_output" | sed 's/$/;/; s/^/wire /' >> $dump_wire
            echo "$grep_output" | sed 's/$/,/; s/^/        /' >> $dump_port
            echo "$grep_output" >> $dump_signal
            echo "$grep_output" >> $dump_under
            echo "$grep_output" | sed 's/.*/.&(&),/' >> $dump_fcall
        else
            # If count is 0, delete the file_name_top.txt file if it exists
            if [ -f "$delete_top" ]; then
                rm "$delete_top"
            fi
        fi

        if [ -n "$grep_output" ]; then
            echo "$grep_output" >> $FULL_PATH/rprobe/apstart_signals.txt
            # echo -e "$grep_output" >> $FULL_PATH/rprobe/apstart_signals.txt
        fi
    else
        echo "Verilog file for module $module_name not found. File path: $module_file"
    fi
done < $FULL_PATH/rprobe/module_name.txt

echo "\nTotal: $total_count" >> $FULL_PATH/rprobe/module_apstart.txt
