import os
import shutil
import zipfile

base_dir = os.getcwd()
deploy_dir = os.path.join(base_dir, "deploy_fpga_all")

if os.path.exists(deploy_dir):
    shutil.rmtree(deploy_dir)
if os.path.exists(deploy_dir + ".zip"):
    os.remove(deploy_dir + ".zip")

os.makedirs(deploy_dir, exist_ok=True)

for entry in sorted(os.listdir(base_dir)):
    full_path = os.path.join(base_dir, entry)
    if os.path.isdir(full_path) and entry[:2].isdigit() and "_" in entry:
        fpga_src = os.path.join(full_path, "FPGA")
        if os.path.exists(fpga_src):
            dest_path = os.path.join(deploy_dir, entry)
            shutil.copytree(fpga_src, dest_path)
            print(f"Copied {fpga_src} → {dest_path}")
        else:
            print(f"Skipping {entry}: No FPGA folder found.")

zip_filename = deploy_dir + ".zip"
with zipfile.ZipFile(zip_filename, 'w', zipfile.ZIP_DEFLATED) as zipf:
    for root, dirs, files in os.walk(deploy_dir):
        for file in files:
            filepath = os.path.join(root, file)
            arcname = os.path.relpath(filepath, start=deploy_dir)
            zipf.write(filepath, arcname)

print(f"\nZipped {deploy_dir} → {zip_filename}")