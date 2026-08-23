#******************************************************************************
# config.wasm.mk                                                  DB48X project
#******************************************************************************
#
#  File Description:
#
#   Emscripten / WebAssembly setup for C and C++
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
#
#  Since EMDSK6, Emscripten / WebAssembly — C++ objects must be linked with
#  em++ instead of emcc so libc++ and exception support are pulled in.
#
# ******************************************************************************

DEFINES_BUILDENV_wasm=CONFIG_WASM
OS_NAME_BUILDENV_wasm=wasm

include $(MIQ)config.gnu.mk

# Produce a .js entry plus a sidecar .wasm (same stem as PRODUCTS)
EXT.exe=.js

# Emscripten supplies its own sysroot; avoid host -fPIC assumptions
CFLAGS_PIC=

# Override GNU tool names (must follow config.gnu.mk)
CC=emcc
CXX=em++
LD=em++
CPP=emcc -E
AR=emar
RANLIB=emranlib

# pthread + embind; exceptions required for C++ embind and DMCP C++ sources
CFLAGS_BUILDENV_wasm=	-pthread
CXXFLAGS_BUILDENV_wasm= -pthread -fexceptions

# Legacy wasm link parameters (see Makefile.old VARIANT=wasm)
LDFLAGS_BUILDENV_wasm=							\
	-pthread							\
	-fexceptions							\
	-sMODULARIZE=0							\
	-sRESERVED_FUNCTION_POINTERS=20					\
	-sPTHREAD_POOL_SIZE=4						\
	--bind								\
	--embed-file $(TOP)config					\
	--embed-file $(TOP)help						\
	-sASYNCIFY
