# ******************************************************************************
# Makefile                                                 make-it-quick project
# ******************************************************************************
#
# File description:
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

# Package description
PACKAGE_NAME=make-it-quick
PACKAGE_DESCRIPTION=A simple auto-configuring build system for C and C++ programs
PACKAGE_URL=http://github.com/c3d/make-it-quick

# Things to install
HDR_INSTALL=			\
	rules.mk		\
	config.mk		\
	$(wildcard config.*.mk)	\
	$(MIQ_OBJDIR)config.system-setup.mk

PREFIX_CONFIG=$(PREFIX_SHR)$(PACKAGE_DIR)config/
PACKAGE_INSTALL_LIB=$(DESTDIR)$(PREFIX_CONFIG)
LIB_INSTALL=$(wildcard config/check*.c)
DOC_INSTALL= README.md AUTHORS NEWS
TESTS=example/

# Make sure we generate the config.system
MIQ_MAKEFILE_INSTALL=yes

MIQ=./
-include configured.mk
include $(MIQ)rules.mk

# Install the check*.c files as data
INSTALL_LIB=$(INSTALL_DATA)

# Generation of the system setup file
SYSTEM_SETUP=							\
$(SYSCONFIG:%=SYSCONFIG?="$(SYSCONFIG)")			\
$(PREFIX:%=PREFIX?="$(PREFIX)")					\
$(PREFIX_BIN:%=PREFIX_BIN?="$(PREFIX_BIN)")			\
$(PREFIX_SBIN:%=PREFIX_SBIN?="$(PREFIX_SBIN)")			\
$(PREFIX_HDR:%=PREFIX_HDR?="$(PREFIX_HDR)")			\
$(PREFIX_SHR:%=PREFIX_SHR?="$(PREFIX_SHR)")			\
$(PREFIX_LIB:%=PREFIX_LIB?="$(PREFIX_LIB)")			\
$(PREFIX_DLL:%=PREFIX_DLL?="$(PREFIX_DLL)")			\
$(PREFIX_LIBEXEC:%=PREFIX_LIBEXEC?="$(PREFIX_LIBEXEC)")		\
$(PREFIX_MAN:%=PREFIX_MAN?="$(PREFIX_MAN)")			\
$(PREFIX_DOC:%=PREFIX_DOC?="$(PREFIX_DOC)")			\
$(PREFIX_VAR:%=PREFIX_VAR?="$(PREFIX_VAR)")			\
CONFIG_SOURCES="$(PREFIX_CONFIG)"

$(MIQ_OBJDIR)config.system-setup.mk:
	$(PRINT_GENERATE) ( $(SYSTEM_SETUP:%=echo %;) true ) > $@
