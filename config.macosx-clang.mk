#******************************************************************************
# config.macosx-clang.mk                                 Make-It-Quick project
#******************************************************************************
#
#  File Description:
#
#    This is the shared makefile configuration when building with Clang on OSX
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
#  Configuration definitions
#------------------------------------------------------------------------------

DEFINES_BUILDENV_macosx-clang=CONFIG_MACOSX
OS_NAME_BUILDENV_macosx-clang=macosx

include $(MIQ)config.gnu.mk

DLL_EXT=	.dylib

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
export PKG_CONFIG_PATH:=$(PKG_CONFIG_PATH):$(MIQ)
