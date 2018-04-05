#******************************************************************************
# config.mingw.mk                                        Make-It-Quick project
#******************************************************************************
#
#  File Description:
#
#    Configuration file when building with MinGW
#
#
#
#
#
#
#
#
#******************************************************************************
# (C) 1992-2018 Christophe de Dinechin <christophe@dinechin.org>
#     This software is licensed under the GNU General Public License v3
#     See LICENSE file for details.
#******************************************************************************

#------------------------------------------------------------------------------
#  Tools
#------------------------------------------------------------------------------

DEFINES_BUILDENV_mingw=CONFIG_MINGW UNICODE _WIN32 WIN32
OS_NAME_BUILDENV_mingw=windows

include $(MIQ)config.gnu.mk

# On Windows, DLLs have to go with the .exe
PREFIX_DLL:=$(PREFIX_DLL:$(PREFIX_LIB)=$(PREFIX_BIN))

# Windows overrides for extensions
EXE_EXT=        .exe
LIB_EXT=        .a
DLL_EXT=        .dll

# MinGW has no 'install' program
INSTALL=	cp

# Do not add an rpath option on Windows
MAKE_DLL=	$(LD) -shared $(MIQ_LDFLAGS) $(MIQ_TOLINK)-o $@

# All code is PIC in MinGW, so avoid a warning
CFLAGS_PIC=
