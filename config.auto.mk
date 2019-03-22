# ******************************************************************************
# config.auto.mk                                           make-it-quick project
# ******************************************************************************
#
# File description:
#
#    Default configuration file invoked when the configuration is unknown
#    In that case, we pick one based on the uname.
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

# Identification of the default build environment
BUILDENV=$(BUILDENV_$(shell uname -s | sed s/CYGWIN.*/Cygwin/ | sed s/MINGW.*/MinGW/ | sed s/MSYS.*/MSYS/g))
BUILDENV_Darwin=$(shell clang --version > /dev/null 2>&1 && echo macosx-clang || echo macosx)
BUILDENV_Linux=linux
BUILDENV_Cygwin=cygwin
BUILDENV_MinGW=mingw
BUILDENV_MSYS=msys
BUILDENV_Haiku=haiku
BUILDENV_FreeBSD=bsd

# Just in case (leftovers from a former life ;-)
BUILDENV_HP-UX=hpux
BUILDENV_SunOS=sun

include $(MIQ)config.$(BUILDENV).mk

# Make sure 'all' remains the first target seen
all: $(TARGET)

hello: warn-buildenv

warn-buildenv:
	@$(ECHO) "$(ERR_COLOR)"
	@$(ECHO) "****************************************************************"
	@$(ECHO) "* The BUILDENV environment variable is not set"
	@$(ECHO) "* You will accelerate builds by setting it as appropriate for"
	@$(ECHO) "* your system. The best guess is BUILDENV=$(BUILDENV)"
	@$(ECHO) "* Attempting to build $(TARGET) with $(BUILDENV)" DIR=$(DIR)
	@$(ECHO) "****************************************************************"
	@$(ECHO) "$(DEF_COLOR)"
