#******************************************************************************
# config.mk                                              Make-It-Quick project
#******************************************************************************
#
#  File Description:
#
#    This is the shared makefile configuration file Make-It-Quick
#    This where the location of specific directories should be specified
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

# Use /bin/sh as a basic shell, since it is faster than bash
# even when it's actually bash underneath, at least
# according to http://www.oreilly.com/openbook/make3/book/ch10.pdf
SHELL=      /bin/bash

#------------------------------------------------------------------------------
#   Default build target and options (can be overriden with env variables)
#------------------------------------------------------------------------------

# Default target
TARGET?=opt

# Default build environment if not set
BUILDENV?=auto

# Default top level directory
TOP?=$(abspath .)/

# Default output for build products
OUTPUT?=$(TOP)

# Default location for object files
OBJFILES?= $(TOP).objects/

# Default location for build logs
LOGS?=$(TOP).logs/
LAST_LOG?=$(LOGS)make.log

# Stuff to clean
TO_CLEAN=	*~ *.bak

# Stuff to install
TO_INSTALL=

# Buildenv for recursive builds
RECURSE_BUILDENV=$(BUILDENV)

# How to avoid parallel builds by default
NOT_PARALLEL?=  .NOTPARALLEL

# Git revision for the current code
GIT_REVISION:=  $(shell git rev-parse --short HEAD 2> /dev/null || echo "unknown")

# Product version defaults to package version
PRODUCTS_VERSION?=$(PACKAGE_VERSION)

# Package installation directory
PACKAGE_DIR?=$(PACKAGE_NAME:%=%/)
PACKAGE_LIBS=$(MIQ_PRODLIB)
PACKAGE_DLLS=$(MIQ_PRODDLL)

# Local setup - Location of configuration files, etc (tweaked at install time)
-include $(MIQ)config.local-setup.mk
CONFIG_SOURCES?=$(MIQ)config/

# Sources to reformat
CLANG_FORMAT_SOURCES=$(SOURCES) $(HDR_INSTALL)


#------------------------------------------------------------------------------
#   Installation paths
#------------------------------------------------------------------------------

SYSCONFIG?=$(DESTDIR)/etc/
PREFIX?=$(DESTDIR)/usr/local/
PREFIX_BIN?=$(PREFIX)bin/
PREFIX_LIB?=$(PREFIX)lib/$(PACKAGE_DIR)
PREFIX_DLL?=$(PREFIX_LIB)
PREFIX_HDR?=$(PREFIX)include/$(PACKAGE_DIR)
PREFIX_SHARE?=$(PREFIX)share/$(PACKAGE_DIR)
PREFIX_PKGCONFIG=$(PREFIX)share/pkgconfig/


#------------------------------------------------------------------------------
#   Compilation flags
#------------------------------------------------------------------------------

# Standard specification (use GCC standard names)
# For a compiler that is not GCC compatible, please state options corresponding
# to the relevant GNU option names as follows:
#   CCFLAGS_STD=$(CC_FLAGS_STD_$(CC_STD))
#   CCFLAGS_STD_gnu11=[whatever option is needed here]
CC_STD	?=gnu11
CXX_STD	?=gnu++11

# Compilation flags
DEFINES_TARGET_debug=	DEBUG
DEFINES_TARGET_opt=	DEBUG OPTIMIZED
DEFINES_TARGET_release= NDEBUG OPTIMIZED RELEASE

# Default for C++ flags is to use CFLAGS
CXXFLAGS_TARGET_debug=     $(CFLAGS_TARGET_debug)
CXXFLAGS_TARGET_opt=       $(CFLAGS_TARGET_opt)
CXXFLAGS_TARGET_release=   $(CFLAGS_TARGET_release)


#------------------------------------------------------------------------------
#   Toools we use
#------------------------------------------------------------------------------

ECHO=           /bin/echo
TIME=           time


#------------------------------------------------------------------------------
#   OS name for a given build environment
#------------------------------------------------------------------------------

OS_NAME=	$(OS_NAME_BUILDENV_$(BUILDENV))


#------------------------------------------------------------------------------
#   Warning extraction (combines outputs from multiple compiler "races")
#------------------------------------------------------------------------------

# GCC and clang write something like:   "warning: GCC keeps it simple"
# Visual Studio writes something like:  "warning C2013: Don't use Visual Studio"

WARNING_MSG=    '[Ww]arning\( \?\[\?[A-Za-z]\+[0-9]\+\]\?\)\?:'
ERROR_MSG=  '[Ee]rror\( \?\[\?[A-Za-z]\+[0-9]\+\]\?\)\?:'


#------------------------------------------------------------------------------
# Colorization
#------------------------------------------------------------------------------
# These use ANSI code, but they work on Mac, Windows, Linux, BSD and VMS, which is good enough
# Change them if you want to work from an hpterm on HP-UX ;-)
INFO_STEP_COL=  \\033[37;44m
INFO_NAME_COL=  \\033[33;44m
INFO_LINE_COL=  \\033[36;49m
INFO_ERR_COL=   \\033[31m
INFO_WRN_COL=   \\033[33m
INFO_POS_COL=   \\033[32m
INFO_RST_COL=   \\033[39;49;27m
INFO_CLR_EOL=   \\033[K
INFO=           printf "%-20s %s %s %s %s %s %s %s\n"
INFO_NONL=      printf "%-20s %-30s %s %s %s %s %s %s"

# Color for build steps
STEP_COLOR:=    $(shell printf "$(INFO_STEP_COL)")
LINE_COLOR:=    $(shell printf "$(INFO_NAME_COL)")
NAME_COLOR:=    $(shell printf "$(INFO_LINE_COL)")
ERR_COLOR:=     $(shell printf "$(INFO_ERR_COL)")
WRN_COLOR:=     $(shell printf "$(INFO_WRN_COL)")
POS_COLOR:=     $(shell printf "$(INFO_POS_COL)")
DEF_COLOR:=     $(shell printf "$(INFO_RST_COL)")
CLR_EOLINE:=    $(shell printf "$(INFO_CLR_EOL)")

SEDOPT_windows=	-u

# Colorize warnings, errors and progress information
LINE_BUFFERED=--line-buffered
COLOR_FILTER=   | grep $(LINE_BUFFERED) -v -e "^true &&" -e "^[A-Za-z0-9_-]\+\.\(c\|h\|cpp\|hpp\)$$"            \
	    $(COLORIZE)

COLORIZE= | sed $(SEDOPT_$(OS_NAME))                                                                      \
            -e 's/^\(.*[,:(]\{1,\}[0-9]*[ :)]*\)\([Ww]arning\)/$(POS_COLOR)\1$(WRN_COLOR)\2$(DEF_COLOR)/g'  \
            -e 's/^\(.*[,:(]\{1,\}[0-9]*[ :)]*\)\([Ee]rror\)/$(POS_COLOR)\1$(ERR_COLOR)\2$(DEF_COLOR)/g'    \
            -e 's/^\(\[BEGIN\]\)\(.*\)$$/$(STEP_COLOR)\1\2$(CLR_EOLINE)$(DEF_COLOR)/g'                      \
            -e 's/^\(\[END\]\)\(.*\)$$/$(STEP_COLOR)\1\2$(CLR_EOLINE)$(DEF_COLOR)/g'                        \
            -e 's/^\(\[[A-Z/ 0-9-]\{1,\}\]\)\(.*\)$$/$(LINE_COLOR)\1$(NAME_COLOR)\2$(DEF_COLOR)/g'


#------------------------------------------------------------------------------
#   Logging
#------------------------------------------------------------------------------

ifndef V
LOG_COMMANDS=       PRINT_COMMAND="true && " 2>&1                     | \
                    tee $(MIQ_BUILDLOG)					\
                    $(COLOR_FILTER) ;                                   \
                    RC=$${PIPESTATUS[0]} $${pipestatus[1]} ;            \
                    $(ECHO) `grep -v '^true &&' $(MIQ_BUILDLOG)       | \
                             grep -i $(ERROR_MSG) $(MIQ_BUILDLOG)     | \
                             wc -l` Errors,                             \
                            `grep -v '^true &&' $(MIQ_BUILDLOG)       | \
                             grep -i $(WARNING_MSG)                   | \
                             wc -l` Warnings in $(MIQ_BUILDLOG);        \
                    cp $(MIQ_BUILDLOG) $(LAST_LOG);                     \
                    exit $$RC
endif


#------------------------------------------------------------------------------
#   Build configuration and rules
#------------------------------------------------------------------------------

# Include actual configuration for specific BUILDENV - At end for overrides
include $(MIQ)config.$(BUILDENV).mk
