###### GD32V Makefile ######

######################################
# target
######################################
TARGET = gd32vf103

######################################
# building variables
######################################
# debug build?
DEBUG = 1

# cpu
ARCH = -march=rv32imac -mabi=ilp32 -mcmodel=medlow
# optimization
OPT = -O0 -g3 #-flto

# Build path
BUILD_DIR = build
FIRMWARE_DIR := ./framework-gd32vf103-sdk

# System clock
SYSTEM_CLOCK := 8000000U

######################################
# C sources
######################################
C_SOURCES =  \
	$(wildcard $(FIRMWARE_DIR)/GD32VF103_standard_peripheral/Source/*.c) \
	$(wildcard $(FIRMWARE_DIR)/GD32VF103_standard_peripheral/*.c) \
	$(wildcard $(FIRMWARE_DIR)/RISCV/stubs/*.c) \
	$(wildcard $(FIRMWARE_DIR)/RISCV/drivers/*.c) \
	$(wildcard $(FIRMWARE_DIR)/RISCV/env_Eclipse/*.c) \
	$(wildcard ./src/freertos/*.c) \
	$(wildcard ./src/*.c)

######################################
# ASM sources
######################################
ASM_SOURCES =  \
    $(FIRMWARE_DIR)/RISCV/env_Eclipse/start.S \
    $(FIRMWARE_DIR)/RISCV/env_Eclipse/entry.S \
    ./src/freertos/portASM.S

######################################
# firmware library
######################################
PERIFLIB_SOURCES = \
# $(wildcard Lib/*.a)

#######################################
# binaries
#######################################
PREFIX = riscv-nuclei-elf-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc
CP = $(PREFIX)objcopy
AR = $(PREFIX)ar
SZ = $(PREFIX)size
OD = $(PREFIX)objdump
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

#######################################
# CFLAGS
#######################################
# C defines
C_DEFS =  \
	-DUSE_STDPERIPH_DRIVER \
	-DHXTAL_VALUE=$(SYSTEM_CLOCK) \

# C includes
C_INCLUDES =  \
	-I./src/ \
	-I./src/freertos/include \
	-I$(FIRMWARE_DIR)/GD32VF103_standard_peripheral/Include \
	-I$(FIRMWARE_DIR)/GD32VF103_standard_peripheral \
	-I$(FIRMWARE_DIR)/RISCV/drivers \

# compile gcc flags
CFLAGS := \
	$(CFLAGS) $(ARCH) $(C_DEFS) $(C_INCLUDES) $(OPT) \
	-std=gnu11 \
	-Wall \
	-fmessage-length=0 \
	-fsigned-char \
	-ffunction-sections \
	-fdata-sections \
	-fno-common

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# Generate dependency information
# CFLAGS += -std=gnu11 -MMD -MP #.deps/$(notdir $(<:.c=.d)) -MF$(@:%.o=%.d) -MT$(@:%.o=%.d)

#######################################
# ASFLAGS
#######################################
# AS defines
AS_DEFS = \
    -DportasmHANDLE_INTERRUPT=handle_trap

# AS includes
AS_INCLUDES =

# compile gcc flags
ASFLAGS := \
	$(CFLAGS) $(OPT) $(ARCH) $(AS_DEFS) $(AS_INCLUDES) \
	-x \
	assembler-with-cpp

#######################################
# LDFLAGS
#######################################
# link script
# LDSCRIPT = $(FIRMWARE_DIR)/RISCV/env_Eclipse/GD32VF103xB.lds
LDSCRIPT = $(FIRMWARE_DIR)/RISCV/env_Eclipse/GD32VF103x8.lds

# libraries
# LIBS = -lc_nano -lm
LIBDIR =
LDFLAGS = \
	$(CFLAGS) $(OPT) $(ARCH) -T$(LDSCRIPT) $(LIBDIR) $(LIBS) $(PERIFLIB_SOURCES) \
    -static \
	-nostartfiles \
    -Xlinker --gc-sections \
	-Xlinker --defsym=__stack_size=1024
    # -Wl,--start-group \
    # -Wl,--end-group
	# -Wl,--wrap=_exit \
	# -Wl,--wrap=close \
	# -Wl,--wrap=fatat \
	# -Wl,--wrap=isatty \
	# -Wl,--wrap=lseek \
	# -Wl,--wrap=read \
	# -Wl,--wrap=sbrk \
	# -Wl,--wrap=stub \
	# -Wl,--wrap=write_hex \
	# -Wl,--wrap=write

#######################################
# build the application
#######################################
# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.S=.o)))
vpath %.S $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) .deps
	@echo "CC $<"
	@$(CC) -c $(CFLAGS) -MMD -MP \
		-MF .deps/$(notdir $(<:.c=.d)) \
		-Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.S Makefile | $(BUILD_DIR) .deps
	@echo "AS $<"
	@$(AS) -c $(ASFLAGS) -MMD -MP \
		-MF .deps/$(notdir $(<:.S=.d)) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	@echo "LD $@"
	@$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	@echo "OD $@"
	@$(OD) $(BUILD_DIR)/$(TARGET).elf -xS > $(BUILD_DIR)/$(TARGET).S $@
	@echo "SIZE $@"
	@$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	@echo "OBJCOPY $@"
	@$(HEX) $< $@

$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	@echo "OBJCOPY $@"
	@$(BIN) $< $@

$(BUILD_DIR):
	mkdir $@

.deps:
	mkdir $@

#######################################
# clean up & flash
#######################################
clean:
	-rm -fR .deps $(BUILD_DIR)

# flash after REQUIRE "HARD OFF" Longan Nano
flash: all
	-openocd -f ./openocd/openocd_ft2232.cfg -c "flash_elf {$(BUILD_DIR)/$(TARGET).elf}"

dfu: all
	dfu-util -d 28e9:0189 -a 0 --dfuse-address 0x08000000:leave -D $(BUILD_DIR)/$(TARGET).bin

#Remove ':leave', the microcontroller will not boot to application when finished programming.
uart: all
	stm32flash -w $(BUILD_DIR)/$(TARGET).bin /dev/ttyUSB0

#######################################
# dependencies
#######################################
-include $(shell mkdir .deps 2>/dev/null) $(wildcard .deps/*)
