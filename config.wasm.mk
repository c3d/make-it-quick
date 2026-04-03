# ******************************************************************************
# config.wasm.mk                                           make-it-quick project
# ******************************************************************************
#
#  Emscripten / WebAssembly — host compiler is emcc (not gcc).
#
#  Link flags follow the legacy DB48X wasm build (Makefile.old): pthread,
#  embind (--bind), embedded config/help, ASYNCIFY, MODULARIZE=0.
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
CC:=emcc
CXX:=emcc -x c++
LD:=emcc
CPP:=emcc -E
AR:=emar
RANLIB:=emranlib

# pthread + embind; exceptions required for C++ embind
CFLAGS_BUILDENV_wasm=	-pthread
CXXFLAGS_BUILDENV_wasm= -pthread -fexceptions

# Legacy wasm link parameters (see Makefile.old VARIANT=wasm)
LDFLAGS_BUILDENV_wasm=							\
	-pthread							\
	-sMODULARIZE=0							\
	-sRESERVED_FUNCTION_POINTERS=20					\
	-sPTHREAD_POOL_SIZE=4						\
	--bind								\
	--embed-file $(TOP)config					\
	--embed-file $(TOP)help						\
	-sASYNCIFY
