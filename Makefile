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
PACKAGE_VERSION=0.3.1
PACKAGE_DESCRIPTION=A simple auto-configuring build system for C and C++ programs
PACKAGE_URL=http://github.com/c3d/make-it-quick

# Things to install
HEADERS=			\
	rules.mk		\
	config.mk		\
	$(wildcard config.*.mk)	\
	$(MIQ_OBJDIR)config.system-setup.mk

WARE.config=$(wildcard config/check*.c)
WARE.doc= README.md AUTHORS NEWS
TESTS=example/

# Install the check*.c files as data, under prefix/include
# We override the 'config' installable for config sources,
# whereas for most packages, it is for configuration files.
PACKAGE_DIR.config=$(PACKAGE_DIR)config/
PREFIX.config=$(PREFIX.header)

# Make sure we generate the config.system
MIQ_MAKEFILE_INSTALL=yes

MIQ=./
-include configured.mk
include $(MIQ)rules.mk


# Generation of the system setup file
SYSTEM_SETUP=								\
$(SYSCONFIG:%=SYSCONFIG?="$(SYSCONFIG)")				\
$(PREFIX:%=PREFIX?="$(PREFIX)")						\
$(foreach i,$(INSTALLABLE),$(PREFIX.$i:%=PREFIX.$i?=$(PREFIX.$i)))	\
CONFIG_SOURCES="$(PREFIX.config)"

$(MIQ_OBJDIR)config.system-setup.mk:
	$(PRINT_GENERATE) ( $(SYSTEM_SETUP:%=echo %;) true ) > $@
