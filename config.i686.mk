# ******************************************************************************
# config.i686.mk                                           make-it-quick project
# ******************************************************************************
#
# File description:
#
#   Linux host multilib i686 (32-bit x86) via gcc/g++ -m32.
#   Use: make BUILDENV=i686
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

include $(MIQ)config.linux.mk

DEFINES_BUILDENV_i686=$(DEFINES_BUILDENV_linux)
OS_NAME_BUILDENV_i686=$(OS_NAME_BUILDENV_linux)

CFLAGS_BUILDENV_i686=	-m32
CXXFLAGS_BUILDENV_i686=	-m32
LDFLAGS_BUILDENV_i686=	-m32
