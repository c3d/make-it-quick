# ******************************************************************************
# config.macosx-clang.mk                                   make-it-quick project
# ******************************************************************************
#
# File description:
#
#    This is the shared makefile configuration when building with Clang on OSX
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

#------------------------------------------------------------------------------
#  Configuration definitions
#------------------------------------------------------------------------------

DEFINES_BUILDENV_macosx-clang=CONFIG_MACOSX
OS_NAME_BUILDENV_macosx-clang=macosx

include $(MIQ)config.gnu.mk

DLL_EXT=	.dylib
TEST_ENV=	DYLD_LIBRARY_PATH=$(OUTPUT)


# For macOS, the convention is to put the version number before extension,
# e.g. where Linux would have libfoo.so.1.3.2, macOS has libfoo.1.3.2.dylib
MIQ_DLLBASE=    $(@:%.install_dll=%)
MIQ_DLLNAME=	$(MIQ_DLLBASE:%$(DLL_EXT)=%$(PRODUCTS_VERSION:%=.$(MIQ_V_VERSION))$(DLL_EXT))
MIQ_SONAME=	$(MIQ_SOBASE:%$(DLL_EXT)=%)$(MIQ_V_MAJOR:%=.%)$(DLL_EXT)
MIQ_SONAME_OPT=	$(PRODUCTS_VERSION:%=-Wl,-install_name -Wl,$(MIQ_SONAME))

# On MacOSX, we will use basic frameworks e.g. for string and filesystem functions
LDFLAGS_BUILDENV_macosx-clang=	-framework CoreFoundation \
				-framework CoreServices

# Special case x11 package, missing on macOS, and unusual location - A bit yucky
export PKG_CONFIG_PATH:=$(PKG_CONFIG_PATH):$(abspath $(MIQ))
