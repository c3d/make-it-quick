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
HDR_INSTALL=			\
	rules.mk		\
	config.mk		\
	$(wildcard config.*.mk)	\
	config.local-setup.mk

PACKAGE_INSTALL_LIB=$(DESTDIR)$(PREFIX_LIB)$(PACKAGE_DIR)config/
LIB_INSTALL=$(wildcard config/check*.c)
SHR_INSTALL=README.md
TESTS=example/

MIQ=./
include $(MIQ)rules.mk

config.local-setup.mk:
	$(PRINT_GENERATE) echo > $@ CONFIG_SOURCES=$(PREFIX_LIB)make-it-quick/config/
