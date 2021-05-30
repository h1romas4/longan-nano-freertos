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

## JTAG flash log

```
openocd: error while loading shared libraries: libusb-0.1.so.4: cannot open shared object file: No such file or directory
$ sudo apt-get install libusb-dev
```

```
openocd -f ./openocd/openocd_ft2232.cfg -c "flash_elf {build/gd32vf103.elf}"
Open On-Chip Debugger 0.10.0+dev-00859-g95a8cd9b5-dirty (2020-06-07-17:17)
Licensed under GNU GPL v2
For bug reports, read
        http://openocd.org/doc/doxygen/bugs.html
Info : clock speed 1000 kHz
Info : JTAG tap: riscv.cpu tap/device found: 0x1000563d (mfg: 0x31e (Andes Technology Corporation), part: 0x0005, ver: 0x1)
Warn : JTAG tap: riscv.cpu       UNEXPECTED: 0x1000563d (mfg: 0x31e (Andes Technology Corporation), part: 0x0005, ver: 0x1)
Error: JTAG tap: riscv.cpu  expected 1 of 1: 0x1e200a6d (mfg: 0x536 (Nuclei System Technology Co Ltd), part: 0xe200, ver: 0x1)
Info : JTAG tap: auto0.tap tap/device found: 0x790007a3 (mfg: 0x3d1 (GigaDevice Semiconductor (Beijing)), part: 0x9000, ver: 0x7)
Error: Trying to use configured scan chain anyway...
Warn : Bypassing JTAG setup events due to errors
Info : datacount=4 progbufsize=2
Info : Examined RISC-V core; found 1 harts
Info :  hart 0: XLEN=32, misa=0x40901105
Info : Listening on port 3333 for gdb connections
flash_elf
Info : device id = 0x19060410
Info : flash_size_in_kb = 0x00000080
Info : flash size = 128kbytes
Info : JTAG tap: riscv.cpu tap/device found: 0x1000563d (mfg: 0x31e (Andes Technology Corporation), part: 0x0005, ver: 0x1)
Warn : JTAG tap: riscv.cpu       UNEXPECTED: 0x1000563d (mfg: 0x31e (Andes Technology Corporation), part: 0x0005, ver: 0x1)
Error: JTAG tap: riscv.cpu  expected 1 of 1: 0x1e200a6d (mfg: 0x536 (Nuclei System Technology Co Ltd), part: 0xe200, ver: 0x1)
Info : JTAG tap: auto0.tap tap/device found: 0x790007a3 (mfg: 0x3d1 (GigaDevice Semiconductor (Beijing)), part: 0x9000, ver: 0x7)
Error: Trying to use configured scan chain anyway...
Warn : Bypassing JTAG setup events due to errors
** Programming Started **
** Programming Finished **
** Verify Started **
** Verified OK **
Info : Hart 0 unexpectedly reset!

make: [Makefile:194: flash] エラー 1 (無視されました)
```

## Note

* [Longan Nano Documents](https://dl.sipeed.com/LONGAN/Nano/DOC)

![Longan Nano](https://raw.githubusercontent.com/h1romas4/longan-nano-freertos/master/docs/img00438.jpg)

![Longan Nano](https://raw.githubusercontent.com/h1romas4/longan-nano-freertos/master/docs/ft2232hl-02.jpg)

![Longan Nano](https://raw.githubusercontent.com/h1romas4/longan-nano-freertos/master/docs/ft2232hl-01.jpg)
