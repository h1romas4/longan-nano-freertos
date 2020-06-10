# (WIP!) Lognan Nano FreeRTOS testing

## Require

* [toolchain-gd32v-linux_x86_64-9.2.0](https://dl.sipeed.com/LONGAN/platformio/dl-packages) (or other host toolchain-gd32v)
* make
* dfu-util or [riscv-openocd](https://github.com/riscv/riscv-openocd)([gd32vf103 patched](https://github.com/riscv/riscv-openocd/pull/399/files)) & JTAG debugger(ex.[FT2232HL](https://github.com/arm8686/FT2232HL-Board))

```shell
$ riscv-nuclei-elf-gcc --version
riscv-nuclei-elf-gcc (GCC) 9.2.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
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
```

## Note

* [Longan Nano Documents](https://dl.sipeed.com/LONGAN/Nano/DOC)

![Longan Nano](https://raw.githubusercontent.com/h1romas4/longan-nano-freertos/master/docs/img00438.jpg)
