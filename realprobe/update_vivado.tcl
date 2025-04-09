set prjname project
set userIP example
set boardspath /export/hdd/scratch/jkim3998/hls-llvm-examples/hierarchy_tcl/vivado
set solpath /export/hdd/scratch/jkim3998/hls-llvm-examples/hierarchy_tcl/project/solution1

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
    


open_project project
current_project project
update_compile_order -fileset sources_1
update_module_reference design_1_realprobe_ip_0_0
connect_bd_net -quiet [get_bd_pins example_0/grp_example_4_fu_106_ap_start] [get_bd_pins realprobe_ip_0/grp_example_4_fu_106_ap_start]
connect_bd_net -quiet [get_bd_pins example_0/grp_example_5_fu_102_ap_start] [get_bd_pins realprobe_ip_0/grp_example_5_fu_102_ap_start]
connect_bd_net -quiet [get_bd_pins example_0/grp_example_5_Pipeline_VITIS_LOOP_30_1_fu_36_ap_start] [get_bd_pins realprobe_ip_0/grp_example_5_Pipeline_VITIS_LOOP_30_1_fu_36_ap_start]
connect_bd_net -quiet [get_bd_pins example_0/grp_example_5_Pipeline_VITIS_LOOP_34_2_fu_44_ap_start] [get_bd_pins realprobe_ip_0/grp_example_5_Pipeline_VITIS_LOOP_34_2_fu_44_ap_start]
connect_bd_net -quiet [get_bd_pins example_0/grp_example_5_Pipeline_VITIS_LOOP_38_3_fu_51_ap_start] [get_bd_pins realprobe_ip_0/grp_example_5_Pipeline_VITIS_LOOP_38_3_fu_51_ap_start]
regenerate_bd_layout
validate_bd_design
make_wrapper -files [get_files /export/hdd/scratch/jkim3998/hls-llvm-examples/hierarchy_tcl/vivado/project.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse /export/hdd/scratch/jkim3998/hls-llvm-examples/hierarchy_tcl/vivado/project.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
reset_runs synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 64
wait_on_run impl_1
close_project
exit
