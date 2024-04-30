# RealProbe🔍
<div>
  <p align="center"> **On-FPGA profiling tool for HLS designs** </p>
</div>

## About

RealProbe is a fully-automated profiling tool to extract on-FPGA performance. 
With just one line---#pragma HLS RealProbe---our tool automatically generates all the code necessary to profile the exact cycle counts of an entire function hierarchy on-board. 
It is developed and maintained by [Jiho Kim][1] from [Sharc Lab][2] at [Georgia Tech][3].

[1]: https://jihoray.github.io/
[2]: https://sharclab.ece.gatech.edu/
[3]: https://www.gatech.edu/



## Useful Links

[Documentation][9]

Tutorials ([FCCM 2024][10])

[9]: https://realprobe-doc.readthedocs.io/en/latest
[10]: https://sharclab.ece.gatech.edu/open-source-projects/



## Requirements

RealProbe expects AMD/Xilinx Vitis HLS (a part of the [Vitis Unified Software Platform][4]) and [Vivado][5] to be present on the machine it is running on. This includes setting up the environment, as described in the [Vitis HLS documentation][6], and setting up the environment, as described in the [Vivado documentation][7].

For FPGA board, we expect the board to support [PYNQ framework](https://pynq.readthedocs.io/en/latest/). 

Other than that, RealProbe is fully integrated into Vitis HLS and Vivado toolchain, requiring no additional environment settings or tool installations. 

All testing has been performed using Vitis HLS 2023.1 and Vivado 2023.1, though we expect any version with an [HLS LLVM frontend][8] release.

[4]: https://www.xilinx.com/products/design-tools/vitis/vitis-platform.html
[5]: https://www.xilinx.com/products/design-tools/vivado.html
[6]: https://docs.xilinx.com/r/en-US/ug1399-vitis-hls/Setting-Up-the-Environment?tocId=5N~0A2HNuVzvrGYgw0ja_A
[7]: https://docs.amd.com/r/en-US/ug910-vivado-getting-started/Installing-the-Vivado-Design-Suite
[8]: https://github.com/Xilinx/hls-llvm-project



## Usage

```bash
git clone https://github.com/sharc-lab/RealProbe.git
cd RealProbe
```

Go to your project folder (with C/C++ codes and Vitis_HLS run tcl script) and copy the Makefile from RealProbe.

> **Warning**
>
> Please note that the name of the tcl script should be hls.tcl, and don't change the variable name inside. For more information, refer examples folder for tcl script examples.

```bash
cp RealProbe/realprobe/Makefile .
```

In your Makefile, specify the path to your git repository

```bash
REALPROBE_PATH := <YOUR/GIT/CLONED/PATH>/realprobe
HLS_BUILD_PATH := <YOUR/GIT/CLONED/PATH>/hls-build
```

Then, run RealProbe!

```bash
make realprobe
```

<!---
All available command-line options can be viewed by running `realprobe --help`.
-->
