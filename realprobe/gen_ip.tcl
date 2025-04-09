global PRJ_NAME SOL_NAME RP_PATH BUILD_PATH

# Construct the path to top_signal.txt
set top_start_signal_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/apstart_signals.txt"
set top_done_signal_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/apdone_signals.txt"

set tripcount_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/conservative_tripcount.txt"

set tripcount_file [open $tripcount_path r]
set tripcount_raw [split [read $tripcount_file] "\n"]
close $tripcount_file

set tripcounts {}
foreach tripcount $tripcount_raw {
    if {[string length [string trim $tripcount]] > 0} {
        lappend tripcounts $tripcount
    }
}

set max_depth 0
foreach depth $tripcounts {
    if {[expr $depth] > $max_depth} {
        set max_depth [expr $depth]
    }
}

proc clog2 {val} {
    set r 0
    set v [expr {$val - 1}]
    while {$v > 0} {
        incr r
        set v [expr {$v >> 1}]
    }
    return $r
}

set read_index_width [clog2 $max_depth]

# Read the list of signals from top_signal.txt
set signal_file [open $top_start_signal_path r]
set signals_raw [split [read $signal_file] "\n"]
close $signal_file

# Filter out blank lines from the signals list
set start_signals {}
foreach start_signal $signals_raw {
    if {[string length [string trim $start_signal]] > 0} {
        lappend start_signals $start_signal
    }
}

set signal_file [open $top_done_signal_path r]
set signals_raw [split [read $signal_file] "\n"]
close $signal_file

set done_signals {}
foreach done_signal $signals_raw {
    if {[string length [string trim $done_signal]] > 0} {
        lappend done_signals $done_signal
    }
}

set sigcount 0
foreach start_signal $start_signals {
    incr sigcount
}

# Generate Verilog module header
set verilog_code {module realprobe_ip (
    input   wire    [12:0]          axi_addr_32b,
    output  reg     [31:0]          axi_rdata_32b,
    input   wire    [31:0]          axi_wdata_32b,
    input   wire    [3:0]           axi_we_32b,
    input   wire                    axi_en_32b,}
foreach signal $start_signals {
    append verilog_code "\n    input   wire                    $signal,"
}
foreach signal $done_signals {
    append verilog_code "\n    input   wire                    $signal,"
}
append verilog_code {
    input   wire                    clk,    // Active high
    input   wire                    rst     // Sync & Active-low
);


}

append verilog_code "parameter N = $sigcount;"

set count 0
foreach tripcount $tripcounts {
    append verilog_code "\nlocalparam DEPTH_${count} = ${tripcount};"
    incr count
}

set count 0
foreach signal $start_signals {
    append verilog_code "\nwire start_${count} = ${signal};"
    incr count
}

set count 0
foreach signal $done_signals {
    append verilog_code "\nwire done_${count} = ${signal};"
    incr count
}

set count 0
foreach signal $start_signals {
    append verilog_code "\nwire [31:0] start_time_${count}_out;"
    incr count
}

set count 0
foreach signal $done_signals {
    append verilog_code "\nwire [31:0] end_time_${count}_out;"
    incr count
}

#todo readindex / full number..
append verilog_code "wire \[N-1:0\] full;\n"
append verilog_code "reg [$read_index_width-1:0] read_index;\n"

append verilog_code {
wire [31:0] pc_out;
reg [10:0] latched_axi_addr_32b;


assign axi_w = |axi_we_32b;
assign axi_r = ~axi_w;

always @(posedge clk) begin
    if (axi_en_32b & axi_r)
        latched_axi_addr_32b <= axi_addr_32b[12:2];
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        read_index <= 0;
    end else if (axi_en_32b & axi_w) begin
        if (axi_addr_32b[12:2] == 11'd100) begin
}

append verilog_code "            read_index <= axi_wdata_32b[$read_index_width-1:0];\n"
append verilog_code {
        end
    end
end

always @* begin
    case (latched_axi_addr_32b)
        11'd0:  axi_rdata_32b = pc_out;
}

append verilog_code "        11'd1:  axi_rdata_32b = {" [expr 32 - $sigcount] "'d0, full};"


set count 2
set count_double 0
foreach signal $start_signals {
    append verilog_code "        11'd${count}:  axi_rdata_32b = start_time_${count_double}_out;"
    incr count
    append verilog_code "        11'd${count}:  axi_rdata_32b = end_time_${count_double}_out;"
    incr count
    incr count_double
}

append verilog_code {
        default: axi_rdata_32b = 32'd0;
    endcase
end

program_counter pc_cntr(
    .clk(clk),
    .reset(rst),
    .start(start_0),
    .done(done_0),
    .pc(pc_out)
);

}



set count 0
foreach signal $start_signals {
    # Generate the snippet with variable substitution
    set snippet "
    cycle_recorder #(DEPTH_$count) recorder_$count (
        .clk(clk),
        .rst(rst),
        .start(start_$count),
        .done(done_$count),
        .counter(pc_out),
        .full(full[$count]),
        .read_index(read_index),
        .start_time(start_time_${count}_out),
        .end_time(end_time_${count}_out)
    );
    "
    # Append the snippet to verilog_code
    append verilog_code $snippet
    incr count
}

append verilog_code "endmodule"
append verilog_code {


module program_counter (
    input wire clk,
    input wire reset,
    input wire start,
    input wire done,
    output reg [31:0] pc
);

    reg counting; // Flag to indicate if the counter is active

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            pc <= 32'b0;
            counting <= 1'b0;
        end else begin
            // Start counting on rising edge of start (0 -> 1)
            if (start && !counting) begin
                counting <= 1'b1;
            end

            // Stop counting on rising edge of done (0 -> 1)
            if (done && counting) begin
                counting <= 1'b0;
            end

            // Increment counter if counting is active
            if (counting) begin
                pc <= pc + 1;
            end
        end
    end
endmodule

module cycle_recorder #(parameter DEPTH = 1) (
    input wire clk,
    input wire rst,
    input wire start,      
    input wire done,      
    input wire [31:0] counter, 
    input wire [$clog2(DEPTH)-1:0] read_index,
    output reg full,
    output reg [31:0] start_time,
    output reg [31:0] end_time 
);

    reg [31:0] start_times [0:DEPTH-1];
    reg [31:0] end_times   [0:DEPTH-1];
    reg [$clog2(DEPTH):0] pair_count; // can count up to DEPTH

    reg start_d, done_d;
    wire start_edge = start && ~start_d;
    wire done_edge  = done  && ~done_d;     

    integer i;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            pair_count <= 0;
            full <= 0;
            start_d <= 0;
            done_d <= 0;
            for (i = 0; i < DEPTH; i = i + 1) begin
                start_times[i] <= 32'd0;
                end_times[i] <= 32'd0;
            end
        end else begin
            start_d <= start;
            done_d <= done;

            // Capture start timestamp
            if (start_edge && pair_count < DEPTH) begin
                start_times[pair_count] <= counter;
            end

            // Capture done timestamp and increment count only after done
            if (done_edge && pair_count < DEPTH) begin
                end_times[pair_count] <= counter;
                pair_count <= pair_count + 1;

                if (pair_count + 1 == DEPTH)
                    full <= 1'b1;
            end
        end
    end

    // Output selected start and end time
    always @(*) begin
        start_time = start_times[read_index];
        end_time   = end_times[read_index];
    end

endmodule

}

# Write generated Verilog code to a file
set verilog_file [open "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/realprobe_ip.v" w]
puts $verilog_file $verilog_code
close $verilog_file


# global PRJ_NAME SOL_NAME RP_PATH BUILD_PATH

# # Construct the path to top_signal.txt
# set top_signal_path "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/apstart_signals.txt"

# # Read the list of signals from top_signal.txt
# set signal_file [open $top_signal_path r]
# set signals_raw [split [read $signal_file] "\n"]
# close $signal_file

# # Filter out blank lines from the signals list
# set signals {}
# foreach signal $signals_raw {
#     if {[string length [string trim $signal]] > 0} {
#         lappend signals $signal
#     }
# }

# # Calculate the number of bits needed for addressing
# set num_bits [expr {int(ceil(log([llength $signals])/log(2)))}]

# # Check if the number of signals is 1, then assign num_bits to 1
# if {[llength $signals] == 1} {
#     set num_bits 1
# }

# # Generate Verilog module header
# set verilog_code {module realprobe_ip (
#     input   wire    [12:0]          axi_addr_32b,
#     output  reg     [31:0]          axi_rdata_32b,
#     input   wire    [31:0]          axi_wdata_32b,
#     input   wire    [3:0]           axi_we_32b,
#     input   wire                    axi_en_32b,}
# foreach signal $signals {
#     append verilog_code "\n    input   wire                    $signal,"
# }
# append verilog_code {
#     input   wire                    clk,    // Active high
#     input   wire                    rst     // Sync & Active-low
# );


# }

# append verilog_code "reg  [[expr ${num_bits}-1]:0]  latched_axi_addr_32b;"

# # Generate pc_out signals
# set count 0
# foreach signal $signals {
#     append verilog_code "\nwire [31:0] pc_out$count;"
#     incr count
# }
# append verilog_code {
# assign axi_w = |axi_we_32b;
# assign axi_r = ~axi_w;

# always @(posedge clk)
# }
#         append verilog_code "\nif(axi_en_32b & axi_r) latched_axi_addr_32b <= axi_addr_32b[[expr ${num_bits} + 1]:2];"
# append verilog_code {
# always @*
#     case(latched_axi_addr_32b)
# }

# # Generate case statements
# for {set i 0} {$i < [llength $signals]} {incr i} {
#     append verilog_code "\n            ${num_bits}'d$i : axi_rdata_32b = {pc_out[expr $i]};"
# }
# append verilog_code {
#     endcase
# }

# append verilog_code {

# program_counter pc_cntr(
#     .clk(clk),
#     .reset(rst),
# }

# set count 0
# foreach signal $signals {
#     append verilog_code "\n    .start${count}(${signal}),"
#     incr count
# }

# set count_rec [expr $count - 1]

# for {set i 0} {$i < ([llength $signals] - 1)} {incr i} {
#     append verilog_code "\n    .pc${i}(pc_out${i}),"
# }
# append verilog_code "\n    .pc${count_rec}(pc_out${count_rec})"


# append verilog_code {
# );
# endmodule
# }



# # Define the program_counter module
# append verilog_code "\nmodule program_counter ("
# append verilog_code "\n    input wire clk,"
# append verilog_code "\n    input wire reset,"
# # Generate input and output signals for program_counter module

# set count 0
# for {set i 0} {$i < ([llength $signals] - 1)} {incr i} {
#     append verilog_code "\n    input wire start$count,"
#     append verilog_code "\n    output reg [31:0] pc$count,"
#     incr count
# }
# append verilog_code "\n    input wire start$count,"
# append verilog_code "\n    output reg [31:0] pc$count"

# append verilog_code "\n);"

# # Generate always blocks
# set count 0
# foreach signal $signals {
#     append verilog_code "\nalways @(posedge clk or negedge reset) begin"
#     append verilog_code "\n    if (!reset) begin"
#     append verilog_code "\n        pc$count <= 32'b0;"
#     append verilog_code "\n    end else if (start$count) begin"
#     append verilog_code "\n        pc$count <= pc$count + 1;"
#     append verilog_code "\n    end else if ((!start$count)) begin"
#     append verilog_code "\n    end"
#     append verilog_code "\nend"
#     incr count
# }
# append verilog_code "\nendmodule"

# # Write generated Verilog code to a file
# set verilog_file [open "[pwd]/${PRJ_NAME}/${SOL_NAME}/rprobe/realprobe_ip.v" w]
# puts $verilog_file $verilog_code
# close $verilog_file

# append verilog_code "reg  [[expr ${num_bits}-1]:0]  latched_axi_addr_32b;"

# # Generate pc_out signals
# set count 0
# foreach signal $signals {
#     append verilog_code "\nwire [31:0] pc_out$count;"
#     incr count
# }
# append verilog_code {
# assign axi_w = |axi_we_32b;
# assign axi_r = ~axi_w;

# always @(posedge clk)
# }
#         append verilog_code "\nif(axi_en_32b & axi_r) latched_axi_addr_32b <= axi_addr_32b[[expr ${num_bits} + 1]:2];"
# append verilog_code {
# always @*
#     case(latched_axi_addr_32b)
# }

# # Generate case statements
# for {set i 0} {$i < [llength $signals]} {incr i} {
#     append verilog_code "\n            ${num_bits}'d$i : axi_rdata_32b = {pc_out[expr $i]};"
# }
# append verilog_code {
#     endcase
# }

# append verilog_code {

# program_counter pc_cntr(
#     .clk(clk),
#     .reset(rst),
# }

