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
MAKE_DLL=	$(LD) -shared $(MIQ_LDFLAGS) $(MIQ_TOLINK) -o $@ -rpath $(PREFIX_DLL)

# On MacOSX, we will use basic frameworks e.g. for string and filesystem functions
LDFLAGS_BUILDENV_macosx-clang=	-framework CoreFoundation \
				-framework CoreServices
