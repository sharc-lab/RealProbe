import os
import subprocess
import time
from concurrent.futures import ThreadPoolExecutor, as_completed

MAX_WORKERS = 4 

# Exclude specific directories
EXCLUDE_DIRS = {'cosim_result', 'csynth_result'}

dirs = [
    d for d in os.listdir('.')
    if os.path.isdir(d) and d[0].isdigit() and d not in EXCLUDE_DIRS
]

def build(dir_path):
    try:
        print(f"[START] {dir_path}")
        subprocess.run(["make", "clean"], cwd=dir_path, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        subprocess.run(["make", "realprobe"], cwd=dir_path, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print(f"[DONE] {dir_path}")
        return f"Success in {dir_path}"
    except subprocess.CalledProcessError as e:
        print(f"[FAIL] {dir_path}")
        return f"Failed in {dir_path}: {e}"

start_time = time.time()
with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
    futures = {executor.submit(build, d): d for d in sorted(dirs)}

    for future in as_completed(futures):
        print(future.result())

print(f"\nAll tasks finished in {time.time() - start_time:.2f} seconds.")