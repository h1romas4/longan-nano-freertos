# (WIP!) Lognan Nano FreeRTOS testing

*FreeRTOS has not yet been implemented!*

## Require

* [toolchain-gd32v-linux_x86_64-9.2.0](https://bintray.com/platformio/dl-packages/toolchain-gd32v#files) (or other host toolchain-gd32v)
* make
* flash utils
  * [tool-openocd-gd32v](https://bintray.com/platformio/dl-packages/tool-openocd-gd32v#files)
  * dfu-util
  * [riscv-openocd](https://github.com/riscv/riscv-openocd)([gd32vf103 patched](https://github.com/riscv/riscv-openocd/pull/399/files)) & JTAG debugger(ex.[FT2232HL](https://github.com/arm8686/FT2232HL-Board))

```shell
$ riscv-nuclei-elf-gcc --version
riscv-nuclei-elf-gcc (GCC) 9.2.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
$ openocd --version
Open On-Chip Debugger 0.10.0+dev-00859-g95a8cd9b5-dirty (2020-06-07-17:17)
Licensed under GNU GPL v2
For bug reports, read
        http://openocd.org/doc/doxygen/bugs.html
```

* for VS Code enviroment

```shell
$ echo $RISCV_NUCLIE_TOOLCHAIN
~/devel/toolchain/gd32v/toolchain-gd32v-linux_x86_64-9.2.0
```

This repository includes framework-gd32vf103-sdk.

## Build & Flash

```shell
# build
make
# flash
make dfu
# or JTAG flash (configure FT2232HL)
make flash
# and require(?) Longan Nano power OFF/ON to start
# or JTAG debug to continue
```

## VS Code JTAG Debug

1. Set breakpoints on source code
2. Run Task: "launch openocd"
3. Run Debug: "Longan Nano Launch (GDB)"

## Note

* [Longan Nano Documents](https://dl.sipeed.com/LONGAN/Nano/DOC)

![Longan Nano](https://raw.githubusercontent.com/h1romas4/longan-nano-freertos/master/docs/img00438.jpg)

![Longan Nano](https://raw.githubusercontent.com/h1romas4/longan-nano-freertos/master/docs/ft2232hl-02.jpg)

![Longan Nano](https://raw.githubusercontent.com/h1romas4/longan-nano-freertos/master/docs/ft2232hl-01.jpg)
