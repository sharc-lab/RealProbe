import json
import os
import re
import shutil
import sys

def backup_verilog_folder(full_path):
    original_path = os.path.join(full_path, "impl", "ip", "hdl", "verilog")
    backup_path = os.path.join(full_path, "impl", "ip", "hdl", "verilog_orgn")
    if os.path.exists(original_path):
        if not os.path.exists(backup_path):
            os.makedirs(backup_path)
        # Copy all contents of the original folder to the backup folder
        for item in os.listdir(original_path):
            item_path = os.path.join(original_path, item)
            if os.path.isdir(item_path):
                shutil.copytree(item_path, os.path.join(backup_path, item))
            else:
                shutil.copy2(item_path, backup_path)
        print("Backup completed.")
    else:
        print("Original folder doesn't exist.")

def get_top_name(full_path):
    tcl_file_path = os.path.join(full_path, ".autopilot", "db", "kernel_module_hierarchy.tcl")
    # tcl_file_path = './.autopilot/db/kernel_module_hierarchy.tcl'
    top_name = None
    if os.path.exists(tcl_file_path):
        with open(tcl_file_path, 'r') as file:
            content = file.read()
            match = re.search(r'"Name"\s*:\s*"([^"]+)"', content)
            if match:
                top_name = match.group(1)
                # Write top_name to top.txt
                with open('top.txt', 'w') as top_file:
                    top_file.write(top_name)
    return top_name


def dump_to_txt(full_path, data, verilog_module, is_top_module, direct_callers_str, top_name):
    if direct_callers_str == "none":
        print(f"No above functions for {verilog_module}. Skipping txt file creation.")
        return
    directory = os.path.join(full_path, "impl", "ip", "hdl", "verilog")
    if is_top_module:
        filepath = os.path.join(directory, f"{verilog_module}_top.txt")
    else:
        filepath = os.path.join(directory, f"{top_name}_{verilog_module}_top.txt")

    with open(filepath, "w") as file:
        # Dump direct_callers_str to the file
        file.write(direct_callers_str)

        print(f"Extraction completed for {filepath}")

# def main():

#     full_path = "./project/solution1"

#     json_path = os.path.join(full_path, f"{sol_name}_data.json")
#     with open(json_path, "r") as file:
#         data = json.load(file)
#     top_name = "example"

#     top_module = data.get("ModuleInfo", {}).get("Hierarchy", {})
#     stack = [(top_module, 0, "none")]

#     module_hierarchy = {}  # Dictionary to store the highest hierarchy for each module name
#     modules_sorted_by_hierarchy = []  # List to store modules sorted by hierarchy
#     direct_callers = {}  # Dictionary to store direct callers for each module

#     rprobe_path = os.path.join(full_path, "rprobe")

#     if not os.path.exists(rprobe_path):
#         os.makedirs(rprobe_path)

#     module_name_path = os.path.join(rprobe_path, "module_name.txt")
#     hierarchy_num_path = os.path.join(rprobe_path, "hierarchy_num.txt")
#     abov_func_path = os.path.join(rprobe_path, "abov_func.txt")
#     loop_path = os.path.join(rprobe_path, "loop.txt")
#     direct_calls_path = os.path.join(rprobe_path, "direct_calls.txt")

#     with open(module_name_path, "w") as module_name_file, \
#             open(hierarchy_num_path, "w") as hierarchy_num_file, \
#             open(abov_func_path, "w") as abov_func_file, \
#             open(loop_path, "w") as loop_file, \
#             open(direct_calls_path, "w") as direct_calls_file:

#         while stack:
#             module, hierarchy, direct_caller = stack.pop()

#             module_name = module.get("ModuleName", "")
#             if not module_name:
#                 continue

#             is_loop = "loop" in module_name.lower()

#             # Skip if the module with the same name and hierarchy already exists
#             if module_name in module_hierarchy and hierarchy <= module_hierarchy[module_name]:
#                 continue

#             module_hierarchy[module_name] = hierarchy  # Update the highest hierarchy for the module
#             modules_sorted_by_hierarchy.append(module_name)  # Add module name to the sorted list

#             module_name_file.write(f"{module_name}\n")
#             hierarchy_num_file.write(f"{hierarchy}\n")
#             loop_file.write(f"{1 if is_loop else 0}\n")

#             # Record direct calls to direct_calls_file
#             direct_callers.setdefault(module_name, set()).add(direct_caller)

#             if "Instances" in module:
#                 for instance in module["Instances"]:
#                     stack.append((instance, hierarchy + 1, module_name))
#                     # Record direct calls for instances
#                     direct_callers.setdefault(instance["ModuleName"], set()).add(module_name)

#     # Sort modules by hierarchy in descending order
#     modules_sorted_by_hierarchy.sort(key=lambda x: module_hierarchy[x], reverse=True)

#     # Write sorted modules and their direct callers to abov_func_file
#     abov_func_path = os.path.join(rprobe_path, "abov_func.txt")
#     with open(abov_func_path, "w") as abov_func_file:
#         for module_name in modules_sorted_by_hierarchy:
#             direct_caller_set = direct_callers.get(module_name, set())
#             if direct_caller_set:
#                 direct_callers_str = "\n".join(direct_caller_set)
#                 abov_func_file.write(f"{module_name}: {direct_callers_str}\n")
#                 # Dump to individual txt files for each verilog module
#                 dump_to_txt(full_path, data, module_name, module_name == top_name, direct_callers_str, top_name)
#             else:
#                 abov_func_file.write(f"{module_name}: None\n")

#     hierarchy_sort_path = os.path.join(rprobe_path, "hierarchy_sort_modules.txt")
#     # Write sorted module names to hierarchy_sort_modules.txt
#     with open(hierarchy_sort_path, "w") as hierarchy_sort_modules_file:
#         for module_name in modules_sorted_by_hierarchy:
#             hierarchy_sort_modules_file.write(f"{module_name}\n")

#     print("Extraction completed.")

# if __name__ == "__main__":
#     main()


def main():

    curr_path = sys.argv[1]
    project_name = sys.argv[2]
    sol_name = sys.argv[3]

    full_path = os.path.join(curr_path, project_name, sol_name)


    backup_verilog_folder(full_path)

    # full_path = "./project/solution1"

    json_path = os.path.join(full_path, f"{sol_name}_data.json")
    with open(json_path, "r") as file:
        data = json.load(file)
    top_name = get_top_name(full_path)

    top_module = data.get("ModuleInfo", {}).get("Hierarchy", {})
    stack = [(top_module, 0, "none")]

    module_hierarchy = {}  # Dictionary to store the highest hierarchy for each module name
    modules_sorted_by_hierarchy = []  # List to store modules sorted by hierarchy
    direct_callers = {}  # Dictionary to store direct callers for each module

    rprobe_path = os.path.join(full_path, "rprobe")

    if not os.path.exists(rprobe_path):
        os.makedirs(rprobe_path)

    module_name_path = os.path.join(rprobe_path, "module_name.txt")
    hierarchy_num_path = os.path.join(rprobe_path, "hierarchy_num.txt")
    abov_func_path = os.path.join(rprobe_path, "abov_func.txt")
    loop_path = os.path.join(rprobe_path, "loop.txt")
    direct_calls_path = os.path.join(rprobe_path, "direct_calls.txt")

    with open(module_name_path, "w") as module_name_file, \
            open(hierarchy_num_path, "w") as hierarchy_num_file, \
            open(abov_func_path, "w") as abov_func_file, \
            open(loop_path, "w") as loop_file, \
            open(direct_calls_path, "w") as direct_calls_file:

        while stack:
            module, hierarchy, direct_caller = stack.pop()

            module_name = module.get("ModuleName", "")
            if not module_name:
                continue

            is_loop = "loop" in module_name.lower()

            # Access the correct nested structure for loop information
            loops_info = module.get("Metrics", {}).get("Loops", [{}])[0]

            # Skip if the module with the same name and hierarchy already exists
            if module_name in module_hierarchy and hierarchy <= module_hierarchy[module_name]:
                continue

            module_hierarchy[module_name] = hierarchy  # Update the highest hierarchy for the module
            modules_sorted_by_hierarchy.append(module_name)  # Add module name to the sorted list

            module_name_file.write(f"{module_name}\n")
            hierarchy_num_file.write(f"{hierarchy}\n")
            loop_file.write(f"{1 if is_loop else 0}\n")

            # Record direct calls to direct_calls_file
            direct_callers.setdefault(module_name, set()).add(direct_caller)

            if "Instances" in module:
                for instance in module["Instances"]:
                    stack.append((instance, hierarchy + 1, module_name))
                    # Record direct calls for instances
                    direct_callers.setdefault(instance["ModuleName"], set()).add(module_name)

    # Sort modules by hierarchy in descending order
    modules_sorted_by_hierarchy.sort(key=lambda x: module_hierarchy[x], reverse=True)

    # Write sorted modules and their direct callers to abov_func_file
    abov_func_path = os.path.join(rprobe_path, "abov_func.txt")
    with open(abov_func_path, "w") as abov_func_file:
        for module_name in modules_sorted_by_hierarchy:
            direct_caller_set = direct_callers.get(module_name, set())
            if direct_caller_set:
                direct_callers_str = "\n".join(direct_caller_set)
                abov_func_file.write(f"{module_name}: {direct_callers_str}\n")
                # Dump to individual txt files for each verilog module
                dump_to_txt(full_path, data, module_name, module_name == top_name, direct_callers_str, top_name)
            else:
                abov_func_file.write(f"{module_name}: None\n")

    hierarchy_sort_path = os.path.join(rprobe_path, "hierarchy_sort_modules.txt")
    # Write sorted module names to hierarchy_sort_modules.txt
    with open(hierarchy_sort_path, "w") as hierarchy_sort_modules_file:
        for module_name in modules_sorted_by_hierarchy:
            hierarchy_sort_modules_file.write(f"{module_name}\n")

    print("Extraction completed.")

if __name__ == "__main__":
    main()
