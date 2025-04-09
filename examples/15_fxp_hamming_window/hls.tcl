# (C) Copyright 2016-2022 Xilinx, Inc.
# All Rights Reserved.
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set solution_name solution1
set project_name project
set target_device {xc7z020clg400-1}

# Open a project and remove any existing data
open_project -reset $project_name

# Add kernel and testbench
add_files hamming_window.c
add_files -tb hamming_window_test.c

# Tell the top
set_top hamming_window

# Open a solution and remove any existing data
open_solution -reset $solution_name

# Set the target device
set_part $target_device

# Create a virtual clock for the current solution
create_clock -period 10 -name default

# Compile and runs pre-synthesis C simulation using the provided C test bench
# csim_design -clean

csynth_design
export_design -format ip_catalog

# Execute post-synthesis co-simulation of the synthesized RTL with the original C/C++-based test bench
# cosim_design -trace_level all

close_project
