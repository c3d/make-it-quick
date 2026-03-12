#******************************************************************************
# config.arm-none-eabi.mk                                         DB48X project
#******************************************************************************
#
#  File Description:
#
#    ARM Cortext M4 bare-metal cross compilation
#
#
#
#
#
#
#
#
#******************************************************************************
#  (C) 2026 Christophe de Dinechin <christophe@dinechin.org>
#  This software is licensed under the terms outlined in LICENSE.txt
#******************************************************************************
#  This file is part of DB48X.
#
#  DB48X is free software: you can redistribute it and/or modify
#  it under the terms outlined in the LICENSE.txt file
#
#  DB48X is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#******************************************************************************

CROSS_COMPILE=arm-none-eabi

# Include base GNU config (sets CC, CXX, LD, etc.)
include $(MIQ)config.gnu.mk

# No PIC for bare-metal (must override after config.gnu.mk sets -fPIC)
CFLAGS_PIC=

# ------------------------------------------------------------------------------
# Output: produce .elf (not host executable)
# ------------------------------------------------------------------------------

EXT.exe=.elf

# ------------------------------------------------------------------------------
# ARM Cortex-M4F (STM32F446) flags
# ------------------------------------------------------------------------------

CPUFLAGS=-mthumb -march=armv7e-m -mfloat-abi=hard -mfpu=fpv4-sp-d16

# Base flags for bare metal (must be in both C and C++ for consistent ABI)
CFLAGS+=	$(CPUFLAGS) -Wall -Wno-packed-bitfield-compat		\
		-fdata-sections -ffunction-sections			\
		-specs=nano.specs -u _printf_float -specs=nosys.specs
CXXFLAGS+=	$(CPUFLAGS) -Wall -Wno-packed-bitfield-compat		\
		-fno-exceptions -fno-rtti				\
		-fdata-sections -ffunction-sections			\
		-specs=nano.specs -u _printf_float -specs=nosys.specs

LDFLAGS+=	$(CPUFLAGS)					\
		-specs=nano.specs -u _printf_float -specs=nosys.specs	\
		-Wl,--gc-sections -Wl,--wrap=_malloc_r

# ------------------------------------------------------------------------------
# Target-specific optimization (override defaults)
# ------------------------------------------------------------------------------

CFLAGS_TARGET_opt=	-g -Os
CFLAGS_TARGET_debug=	-g -Os -DDEBUG
CFLAGS_TARGET_release=	-Os
LDFLAGS_TARGET_debug=	-g
LDFLAGS_TARGET_opt=	-g
LDFLAGS_TARGET_release=	-s
