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
	rules.mk		\
	config.mk		\
	$(wildcard config.*.mk)	\
	config.local-setup.mk

PREFIX_LIB=$(PREFIX)lib/make-it-quick/config/
LIB_INSTALL=$(wildcard config/check*.c)

# Include the makefile rules with special BUILD path
BUILD=./
include $(BUILD)rules.mk

TESTS=example/

config.local-setup.mk:
	$(PRINT_GENERATE) echo > $@ CONFIG_SOURCES=$(PREFIX_LIB)make-it-quick/
