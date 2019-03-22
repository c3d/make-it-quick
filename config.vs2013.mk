# ******************************************************************************
# config.vs2013.mk                                         make-it-quick project
# ******************************************************************************
#
# File description:
#
#    Makefile configuration file for Visual Studio 2013
#
#    Compiler options:
#    https://msdn.microsoft.com/en-us/library/fwkeyyhe%28v=vs.120%29.aspx
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
#  Tools
#------------------------------------------------------------------------------

# -nologo: suppresses display of sign-on banner
# -TC: C mode
# -TP: C++ mode
CC=	cl -nologo -TC
CXX=	cl -nologo -TP -EHsc
CPP=	cl -nologo -E
LD=	link -nologo
MSLIB=	lib -nologo
PYTHON= python
AR=     no-ar-on-windows
RANLIB= no-ranlib-on-windows
INSTALL=install
CAT=	type


#------------------------------------------------------------------------------
#  Compilation flags
#------------------------------------------------------------------------------
#
# Options in Visual Studio are an anti-poem: no rhyme, no reason.
#
# For example, debug options are: -Z7, -ZI and -Zi.
# But don't think -Z is for debugging. -Za and -Ze disable extensions,
# whereas -Zc controls language conformance,
# and -Zg generates function prototypes. All this is perfectly normal.
#
# For a good introduction to the logic of of Microsoft options,
# watch the neuralyzer scenes in Men In Black. Swamp gas, Venus.
#
# For a true (and truly shocking) reference about the options,
# see https://msdn.microsoft.com/en-us/library/958x11bc.aspx
#
# For now, -Wall is hopeless on Visual Studio 2013

# -TP=C++ mode
# -EHa=Exception model catching both structured and unstructured exceptions
CXXFLAGS_BUILDENV_vs2013= -TP -EHa -EHsc

# -Z7=Put debug information in .obj files (don't laugh)
# -Zi=Set debug information format to Program Database
# -O2=Optimise for speed (-O1 is for size, -Ob for inline functions, and so on)
CFLAGS_TARGET_debug=	-Zi -DEBUG
CFLAGS_TARGET_opt=	-O2 -Zi -DEBUG
CFLAGS_TARGET_release=	-O2

# Curiously, the C++ compiler takes the same options as the C compiler. Bug?
CXXFLAGS_TARGET_debug=	-Zi -EHa -EHsc -DEBUG
CXXFLAGS_opt=		-O2 -Zi -EHa -EHsc -DEBUG
CXXFLAGS_release=	-O2 -EHa -EHsc

DEFINES_BUILDENV_vs2013= WIN32
OS_NAME_BUILDENV_vs2013= windows

# Options specific to profiling
# OBJ_PDB is the .pdb file (profile database) associated to a Windows
# binary (.exe, .lib), containing profile and debug information
MIQ_PDB:=		$(MIQ_OUTEXE:%.exe=%.pdb)
CFLAGS_TARGET_profile=	-Fd$(MIQ_PDB)	-O2 -Zi            -DEBUG
CXXFLAGS_TARGET_profile=-Fd$(MIQ_PDB)	-O2 -Zi -EHa -EHsc -DEBUG
LDFLAGS_TARGET_profile=	-pdb:$(MIQ_PDB) -debug


#------------------------------------------------------------------------------
#  File extensions
#------------------------------------------------------------------------------

OBJ_EXT=.obj
LIB_EXT=.lib
EXE_EXT=.exe
DLL_EXT=.dll

EXE_PFX=
LIB_PFX=lib
DLL_PFX=lib

LINK_DIR_OPT=-L:
LINK_LIB_OPT=-l:
LINK_DLL_OPT=-l:


#------------------------------------------------------------------------------
#  Build rules
#------------------------------------------------------------------------------
# Visual C++ really goes out of its way now to have incompatible options
# For example, -o was recently 'deprecated' in favor of -Fo (!!!!)
#
# For debugging and profiling, we specify the -Fd and -pdb option.
# In order to merge all .pdb information for an executable, we need to pass the -debug
# option to the linker.

MAKE_CC=	$(CC)  $(MIQ_CFLAGS)	-c -Fo$@ $<
MAKE_CXX=	$(CXX) $(MIQ_CXXFLAGS)	-c -Fo$@ $<
MAKE_DIR=	mkdir -p $*
MAKE_OBJDIR=	$(MAKE_DIR) && touch $@
MAKE_LIB=	$(MSLIB) $(MIQ_LINKOPTS)			-out:$@
MAKE_DLL=	$(LD)	 $(MIQ_LINKOPTS) $(MIQ_LDFLAGS)	   -dll -out:$@
MAKE_EXE=	$(LD)	 $(MIQ_LINKOPTS) $(MIQ_LDFLAGS)		-out:$@


#------------------------------------------------------------------------------
#  Dependencies
#------------------------------------------------------------------------------
#  Can't build the dependencies with the Visual Studio compilers at the moment

GNU_CC=         gcc
GNU_CXX=        g++
GNU_AS=         gcc -x assembler-with-cpp
CC_DEPEND=	$(GNU_CC)  -D_WIN32=1 $(GFLAGS)   -MM -MF $@ -MT $(@:.d=) $<
CXX_DEPEND=	$(GNU_CXX) -D_WIN32=1 $(GXXFLAGS) -MM -MF $@ -MT $(@:.d=) $<
AS_DEPEND=	$(GNU_AS)  -D_WIN32=1 $(GASFLAGS) -MM -MF $@ -MT $(@:.d=) $<
