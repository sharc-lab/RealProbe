.PHONY: base realprobe clean prebuild function

# Change the path to be absolute path
REALPROBE_PATH := $(CURDIR)/../../realprobe
HLS_BUILD_PATH := $(CURDIR)/../../hls-build

HLS_FILE := hls.tcl
RP_HLS_FILE := .rp_hls.tcl
TMP_HLS_FILE := .tmp.tcl

clean:
	@rm -rf vivado FPGA project xcd.log vitis_hls.log 
	@rm -f $(RP_HLS_FILE) $(TMP_HLS_FILE)
	@rm -f $(REALPROBE_PATH)/vivado.tcl
	@rm -f $(REALPROBE_PATH)/basic_vivado.tcl

prebuild: clean

base: prebuild
	@$(eval PROJECT_NAME := $(shell awk -F"[ {}]+" '/^set project_name/ {print $$3}' $(HLS_FILE)))
	@$(eval SOLUTION_NAME := $(shell awk -F"[ {}]+" '/^set solution_name/ {print $$3}' $(HLS_FILE)))
	@awk '/^export_design/ { \
		print; \
		print "set arg1 \"'$(REALPROBE_PATH)'\""; \
		print "set arg2 $$project_name"; \
		print "set arg3 $$solution_name"; \
		print "set arg4 $$target_device"; \
		print "source '$(REALPROBE_PATH)'/basic_vivado_automate.tcl"; \
		next } { print }' $(HLS_FILE) > $(TMP_HLS_FILE)
	@echo "unset arg1 arg2 arg3 arg4" >> $(TMP_HLS_FILE)
	vitis_hls $(TMP_HLS_FILE)
	@mkdir -p vivado
	cd vivado && vivado -mode tcl -source ../$(PROJECT_NAME)/$(SOLUTION_NAME)/basic_vivado.tcl && cd ..
	@$(MAKE) setup_fpga

realprobe: prebuild
	@awk '/^open_project/ { \
		print "set arg1 \"'$(REALPROBE_PATH)'\""; \
		print "set arg2 \"'$(HLS_BUILD_PATH)'\""; \
		print "set arg3 $$project_name"; \
		print "set arg4 $$solution_name"; \
		print "set arg5 $$target_device"; \
		print "source '$(REALPROBE_PATH)'/realprobe_run.tcl"; \
		print; next} {print}' $(HLS_FILE) > $(RP_HLS_FILE)
	@echo "unset arg1 arg2 arg3 arg4 arg5" >> $(RP_HLS_FILE)
	vitis_hls $(RP_HLS_FILE)
	@$(eval PROJECT_NAME := $(shell awk -F"[ {}]+" '/^set project_name/ {print $$3}' $(HLS_FILE)))
	@$(eval SOLUTION_NAME := $(shell awk -F"[ {}]+" '/^set solution_name/ {print $$3}' $(HLS_FILE)))
	@mkdir -p vivado
	cd vivado && vivado -mode tcl -source ../$(PROJECT_NAME)/$(SOLUTION_NAME)/rprobe/vivado.tcl && cd ..
	@$(MAKE) setup_fpga

function: 
	@echo -n "" > top_updated.txt
	@echo $(filter-out $@,$(MAKECMDGOALS)) >> top_updated.txt
%:
	@:
	@$(eval PROJECT_NAME := $(shell awk -F"[ {}]+" '/^set project_name/ {print $$3}' $(HLS_FILE)))
	@$(eval SOLUTION_NAME := $(shell awk -F"[ {}]+" '/^set solution_name/ {print $$3}' $(HLS_FILE)))
	@echo "set arg1 \"$(REALPROBE_PATH)\"" > $(TMP_HLS_FILE)
	@echo "set arg2 $(PROJECT_NAME)" >> $(TMP_HLS_FILE)
	@echo "set arg3 $(SOLUTION_NAME)" >> $(TMP_HLS_FILE)
	@echo "source $(REALPROBE_PATH)/update_realprobeip.tcl" >> $(TMP_HLS_FILE)
	@echo "source $(REALPROBE_PATH)/update_vivado_automate.tcl" >> $(TMP_HLS_FILE)
	@echo "source $(REALPROBE_PATH)/update_ipynb_gen.tcl" >> $(TMP_HLS_FILE)
	@echo "unset arg1 arg2 arg3" >> $(TMP_HLS_FILE)
	vitis_hls $(TMP_HLS_FILE)
	cd vivado && vivado -mode tcl -source ../$(PROJECT_NAME)/$(SOLUTION_NAME)/update_vivado.tcl && cd ..
	@$(MAKE) setup_fpga

setup_fpga:
	$(eval PROJECT_NAME := $(shell awk -F"[ {}]+" '/^set project_name/ {print $$3}' $(HLS_FILE)))
	$(eval SOLUTION_NAME := $(shell awk -F"[ {}]+" '/^set solution_name/ {print $$3}' $(HLS_FILE)))

	@mkdir -p FPGA
	@cp "vivado/$(PROJECT_NAME).runs/impl_1/design_1_wrapper.bit" "FPGA/design_1.bit"
	@cp "vivado/$(PROJECT_NAME).gen/sources_1/bd/design_1/hw_handoff/design_1.hwh" "FPGA/"
	@cp "./$(PROJECT_NAME)/$(SOLUTION_NAME)/rprobe/fpga.ipynb" "FPGA/"
