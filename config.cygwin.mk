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

# Cygwin uses Windows extensions, e.g. ld looks for .dll files
EXE_EXT=	.exe
LIB_EXT=	.a
DLL_EXT=	.dll
OBJ_EXT=	.obj

# Because of the above, we need to put the number before the extesion
# e.g. where Linux would have libfoo.so.1.3.2, cygwin has libfoo.1.3.2.dll
MIQ_NOINSTALL=	$(@:%.install_dll=%)
MIQ_DLLNAME=	$(MIQ_NOINSTALL:%$(DLL_EXT)=%$(PRODUCTS_VERSION:%=.$(MIQ_V_VERSION))$(DLL_EXT))
