## Autogenerated from /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/test/lit.site.cfg.py.in
## Do not edit!

import sys

config.host_triple = "x86_64-unknown-linux-gnu"
config.target_triple = "x86_64-unknown-linux-gnu"
config.llvm_src_root = "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm"
config.llvm_obj_root = "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build"
config.llvm_tools_dir = "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/./bin"
config.llvm_lib_dir = "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/./lib"
config.llvm_shlib_dir = "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/./lib"
config.llvm_shlib_ext = ".so"
config.llvm_exe_ext = ""
config.lit_tools_dir = ""
config.python_executable = "/usr/bin/python2.7"
config.gold_executable = "/usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/ld.gold"
config.ld64_executable = ""
config.llvm_tool_lto_build = 1
config.ocamlfind_executable = "OCAMLFIND-NOTFOUND"
config.have_ocamlopt = 0
config.have_ocaml_ounit = 0
config.ocaml_flags = ""
config.include_go_tests = 1
config.go_executable = "GO_EXECUTABLE-NOTFOUND"
config.enable_shared = 1
config.enable_assertions = 0
config.enable_abi_breaking_checks = ""
config.targets_to_build = " X86"
config.native_target = "X86"
config.llvm_bindings = "".split(' ')
config.host_os = "Linux"
config.host_cc = "/usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-cc "
config.host_cxx = "/usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ "
config.host_ldflags = "-Wl,-O2 -Wl,--sort-common -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -Wl,--disable-new-dtags -Wl,--gc-sections -Wl,--allow-shlib-undefined -Wl,-rpath,/export/hdd/scratch/jkim3998/.conda/dst_jiho/hlsllvm/lib -Wl,-rpath-link,/export/hdd/scratch/jkim3998/.conda/dst_jiho/hlsllvm/lib -L/export/hdd/scratch/jkim3998/.conda/dst_jiho/hlsllvm/lib -Wl,-allow-shlib-undefined"
config.llvm_use_intel_jitevents = 0
config.llvm_use_sanitizer = ""
config.have_zlib = 1
config.have_libxar = 0
config.have_dia_sdk = 0
config.enable_ffi = 0
config.build_shared_libs = 0
config.link_llvm_dylib = 1
config.llvm_libxml2_enabled = "1"
config.llvm_host_triple = 'x86_64-unknown-linux-gnu'
config.host_arch = "x86_64"
config.have_opt_viewer_modules = 0

# Support substitution of the tools_dir with user parameters. This is
# used when we can't determine the tool dir at configuration time.
try:
    config.llvm_tools_dir = config.llvm_tools_dir % lit_config.params
    config.llvm_shlib_dir = config.llvm_shlib_dir % lit_config.params
except KeyError:
    e = sys.exc_info()[1]
    key, = e.args
    lit_config.fatal("unable to find %r parameter, use '--param=%s=VALUE'" % (key,key))

import lit.llvm
lit.llvm.initialize(lit_config, config)


# Let the main config do the real work.
lit_config.load_config(config, "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/test/lit.cfg.py")