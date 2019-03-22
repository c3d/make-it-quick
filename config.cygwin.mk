# ******************************************************************************
# config.cygwin.mk                                         make-it-quick project
# ******************************************************************************
#
# File description:
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
# ******************************************************************************
# This software is licensed under the GNU General Public License v3
# (C) 2017-2019, Christophe de Dinechin <christophe@dinechin.org>
# ******************************************************************************
# This file is part of make-it-quick
#
# make-it-quick is free software: you can r redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# make-it-quick is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with make-it-quick, in a file named COPYING.
# If not, see <https://www.gnu.org/licenses/>.
# ******************************************************************************

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
MIQ_DLLBASE=    $(@:%.install_dll=%)
MIQ_DLLNAME=	$(MIQ_DLLBASE:%$(DLL_EXT)=%$(PRODUCTS_VERSION:%=.$(MIQ_V_VERSION))$(DLL_EXT))
MIQ_SONAME=	$(MIQ_SOBASE:%$(DLL_EXT)=%)$(MIQ_V_MAJOR:%=.%)$(DLL_EXT)
MIQ_SONAME_OPT=	$(PRODUCTS_VERSION:%=-Wl,-soname -Wl,$(MIQ_SONAME))
