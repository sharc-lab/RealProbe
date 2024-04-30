global PRJ_NAME SOL_NAME RP_PATH BUILD_PATH TARGET_DEV

source "$RP_PATH/hierarchy.tcl"

exec sh $RP_PATH/contsig_find.sh [pwd] $PRJ_NAME $SOL_NAME
source "$RP_PATH/rtl_modify.tcl"

source "$RP_PATH/ext_top.tcl"
source "$RP_PATH/ext_fcall.tcl"

source "$RP_PATH/rprobe_xml_ports.tcl"
source "$RP_PATH/rprobe_xml_interfaces.tcl"

source "$RP_PATH/ipchange.tcl"

source "$RP_PATH/gen_ip.tcl"
source "$RP_PATH/ipynb_gen.tcl"

source "$RP_PATH/vivado_automate.tcl"