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
SHR_INSTALL= README.md
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
$(PREFIX_VAR:%=PREFIX_VAR?="$(PREFIX_VAR)")			\
CONFIG_SOURCES="$(PREFIX_CONFIG)"

$(MIQ_OBJDIR)config.system-setup.mk:
	$(PRINT_GENERATE) ( $(SYSTEM_SETUP:%=echo %;) true ) > $@
