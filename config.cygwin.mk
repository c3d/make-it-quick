#******************************************************************************
# config.cygwin.mk                                       Make-It-Quick project
#******************************************************************************
#
#  File Description:
#
#    Configuration file for Cygwin build environment
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

DEFINES_BUILDENV_cygwin=CONFIG_CYGWIN UNICODE _WIN32 WIN32
OS_NAME_BUILDENV_cygwin=windows

include $(MIQ)config.gnu.mk

EXE_EXT=	.exe
LIB_EXT=	.a
DLL_EXT=	.dll
OBJ_EXT=	.obj

MAKE_DLL=	$(LD) -shared $(MIQ_LDFLAGS) $(MIQ_TOLINK) -o $@
