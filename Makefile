#******************************************************************************
# Makefile<make-it-quick>                                Make-It-Quick project
#******************************************************************************
#
#  File Description:
#
#    Top-level makefile for 'make-it-quick'
#
#
#
#
#
#
#
#
#******************************************************************************
# (C) 2017-2018 Christophe de Dinechin <christophe@dinechin.org>
#     This software is licensed under the GNU General Public License v3
#     See LICENSE file for details.
#******************************************************************************

# Things to install
PREFIX_HDR=$(PREFIX)include/make-it-quick/
HDR_INSTALL=			\
	config.arm-linux-gnu.mk	\
	config.auto.mk		\
	config.cygwin.mk	\
	config.gnu.mk		\
	config.linux.mk		\
	config.macosx-clang.mk	\
	config.macosx.mk	\
	config.mingw.mk		\
	config.mk		\
	config.msys.mk		\
	config.unix.mk		\
	config.vs2013-64.mk	\
	config.vs2013.mk	\
	rules.mk

# Include the makefile rules with special BUILD path
BUILD=./
include $(BUILD)rules.mk

TESTS=example/
