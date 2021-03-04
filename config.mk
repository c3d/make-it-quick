# ******************************************************************************
# config.mk                                                make-it-quick project
# ******************************************************************************
#
# File description:
#
#    This is the shared makefile configuration file Make-It-Quick
#    This where the location of specific directories should be specified
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
BUILD?= $(TOP).build/

# Default location for build logs
LOGS?=$(TOP).logs/
LAST_LOG?=$(LOGS)make.log

# Stuff to clean
TO_CLEAN=	*~ *.bak

# Kinds of installable stuff
INSTALLABLE=	exe		\
		lib 		\
		dll		\
		header		\
		share		\
		license		\
		man		\
		doc		\
		var		\
		etc		\
		config		\
		sysconfig	\
		pkgconfig

# Stuff to install, with one of the suffixes above
WARE.exe?=	$(MIQ_OUTEXE)
WARE.lib?=	$(MIQ_OUTLIB)
WARE.dll?=	$(MIQ_OUTDLL)
WARE.man?=	$(MANPAGES)
WARE.header?=	$(HEADERS)
WARE.doc?= 	$(wildcard README*)
WARE.license?= 	$(wildcard COPYING* LICENSE*)
WARE.pkgconfig?=$(PACKAGE_NAME:%=%.pc)

# Where we pick up the stuff to install (default is source)
WARE_DIR.pkgconfig?=$(MIQ_OBJDIR)

# Where to put system configuration files
SYSCONFIG?=$(PREFIX.etc)

# Buildenv for recursive builds
RECURSE_BUILDENV=$(BUILDENV)

# How to avoid parallel builds by default
NOT_PARALLEL?=  .NOTPARALLEL

# Git revision for the current code
GIT_REVISION:=  $(shell git rev-parse --short HEAD 2> /dev/null || echo "unknown")

# System configuration if installed
-include $(MIQ)config.system-setup.mk

# Local configuration if any
-include $(MIQ)config.local-setup.mk

# Extract defaults for package name and version if not set
PACKAGE_NAME?=$(firstword $(PRODUCTS) $(notdir $(shell pwd)))
PACKAGE_VERSION?=$(shell (git describe --always --match 'v[0-9].*' 2> /dev/null | sed -e 's/^v//') || echo unknown)

# Use package version for products version if not set
PRODUCTS_VERSION?=$(PACKAGE_VERSION)

# Package installation directory intermediate variables
PACKAGE_DIR?=$(PACKAGE_NAME:%=%/)
PACKAGE_LIBS=$(MIQ_PRODLIB)
PACKAGE_DLLS=$(MIQ_PRODDLL)

# Install headers, docs and var items in package subdirectory by default
PACKAGE_DIR.header?=$(PACKAGE_DIR)
PACKAGE_DIR.share?=$(PACKAGE_DIR)
PACKAGE_DIR.doc?=$(PACKAGE_DIR)
PACKAGE_DIR.license?=$(PACKAGE_DIR)
PACKAGE_DIR.config?=$(PACKAGE_DIR)
PACKAGE_DIR.var?=$(PACKAGE_DIR)

# Location of configuration files, etc (tweaked at install time)
CONFIG_SOURCES?=$(MIQ)config/

# Sources to reformat
CLANG_FORMAT_SOURCES=$(SOURCES) $(WARE.header)


#------------------------------------------------------------------------------
#   Installation paths
#------------------------------------------------------------------------------

# Variables typically provided by configure scripts
PREFIX?=/usr/local/
PREFIX.bin?=$(PREFIX)bin/
PREFIX.sbin?=$(PREFIX)sbin/
PREFIX.libexec?=$(PREFIX)libexec/
PREFIX.exe?=$(PREFIX.bin)
PREFIX.lib?=$(PREFIX)lib/
PREFIX.dll?=$(PREFIX.lib)
PREFIX.header?=$(PREFIX)include/
PREFIX.share?=$(PREFIX)share/
PREFIX.man?=$(PREFIX.share)man/
PREFIX.doc?=$(PREFIX.share)doc/
PREFIX.license?=$(PREFIX.doc)
PREFIX.config?=$(PREFIX.share)config/
PREFIX.var?=$(PREFIX)var/
PREFIX.etc?=/etc/
PREFIX.sysconfig=$(SYSCONFIG)
PREFIX.pkgconfig=$(PREFIX.share)pkgconfig/


# Package configuration directories by default
# The defaut is to install binaries and shared libraries in the prefix
# but to install headers and data items under a directory named after project
define package-install

PACKAGE_INSTALL.$1?=$$(DESTDIR)$$(PREFIX.$1)$$(PACKAGE_DIR.$1)

endef
$(eval $(foreach i,$(INSTALLABLE),$(call package-install,$i)))



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
MKDIR=		mkdir

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
# These use ANSI code, but they work on Mac, Windows, Linux, BSD and VMS,
# which is good enough for most use cases.
# Change them if you want to work from an hpterm on HP-UX ;-)
INFO_STEP_COL=  \\033[37;44m
INFO_ESTEP_COL= \\033[37;41m
INFO_WSTEP_COL= \\033[30;43m
INFO_NAME_COL=  \\033[33;44m
INFO_LINE_COL=  \\033[36;49m
INFO_ERR_COL=   \\033[31m
INFO_WRN_COL=   \\033[33m
INFO_POS_COL=   \\033[32m
INFO_RST_COL=   \\033[39;49;27m
INFO_CLR_EOL=   \\033[K
INFO=           printf "%-16s %-56s%6s\n"
INFO_NONL=      printf "%-16s %-56s"
INFO_TEST=      printf "%-16s %-56s%6s\n"

# Color for build steps
STEP_COLOR:=    $(shell printf "$(INFO_STEP_COL)")
WSTEP_COLOR:=   $(shell printf "$(INFO_WSTEP_COL)")
ESTEP_COLOR:=   $(shell printf "$(INFO_ESTEP_COL)")
LINE_COLOR:=    $(shell printf "$(INFO_LINE_COL)")
NAME_COLOR:=    $(shell printf "$(INFO_NAME_COL)")
ERR_COLOR:=     $(shell printf "$(INFO_ERR_COL)")
WRN_COLOR:=     $(shell printf "$(INFO_WRN_COL)")
POS_COLOR:=     $(shell printf "$(INFO_POS_COL)")
DEF_COLOR:=     $(shell printf "$(INFO_RST_COL)")
CLR_EOLINE:=    $(shell printf "$(INFO_CLR_EOL)")

SEDOPT_windows=	-u

# Colorize warnings, errors and progress information
LINE_BUFFERED=--line-buffered
COLOR_FILTER=   | grep $(LINE_BUFFERED) -v -e "^true &&" $(COLORIZE)
COLORIZE?= | sed $(SEDOPT_$(OS_NAME))                                                                        		\
            -e 's/^\(.*[,:(]\{1,\}[0-9]*[ :)]*\)\([Ww]arning\)/$(POS_COLOR)\1$(WRN_COLOR)\2$(DEF_COLOR)/g'  		\
            -e 's/^\(.*[,:(]\{1,\}[0-9]*[ :)]*\)\([Ee]rror\)/$(POS_COLOR)\1$(ERR_COLOR)\2$(DEF_COLOR)/g'    		\
            -e 's/^\(\[BEGIN\]\)\(.*\)$$/$(STEP_COLOR)\1\2$(CLR_EOLINE)$(DEF_COLOR)/g'        				\
            -e 's/^\(\[END\]\)\(.*\)$$/$(STEP_COLOR)\1\2$(CLR_EOLINE)$(DEF_COLOR)/g'        				\
            -e 's/\(\[OK\]\)/$(POS_COLOR)\1$(DEF_COLOR)/g'        							\
            -e 's/\(\[NO\]\)/$(ERR_COLOR)\1$(DEF_COLOR)/g'        							\
            -e 's/\(\[KO\]\)/$(ERR_COLOR)\1$(DEF_COLOR)/g'        							\
            -e 's/^\(\[WARNING\]\)\(.*\)$$/$(WSTEP_COLOR)\1\2$(CLR_EOLINE)$(DEF_COLOR)/g' 				\
            -e 's/^\(\[MISSING\]\)\(.*\)$$/$(WSTEP_COLOR)\1\2$(CLR_EOLINE)$(DEF_COLOR)/g' 				\
            -e 's/^\(\[ERROR\]\)\(.*\)$$/$(ERR_COLOR)\1\2$(CLR_EOLINE)$(DEF_COLOR)/g'        				\
            -e 's/^\(\[FAIL\]\)\(.*\)$$/$(ERR_COLOR)\1\2$(CLR_EOLINE)$(DEF_COLOR)/g'        				\
            -e 's/^\(\[[A-Z/ 0-9-]\{1,\}\]\)\(.*\)$$/$(NAME_COLOR)\1$(LINE_COLOR)\2$(DEF_COLOR)/g' ;			\
            [ $${PIPESTATUS[0]} -eq 0 ]


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
