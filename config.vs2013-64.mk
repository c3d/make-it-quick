# ******************************************************************************
# config.vs2013-64.mk                                      make-it-quick project
# ******************************************************************************
#
# File description:
#
#    Makefile configuration file for Visual Studio 2013 (64-bit)
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

DEFINES_BUILDENV_vs2013-64=$(DEFINES_BUILDENV_vs2013)
LDFLAGS_BUILDENV_vs2013-64=$(LDFLAGS_BUILDENV_vs2013)
OS_NAME_BUILDENV_vs2013-64=windows

include $(MIQ)config.vs2013.mk
