#******************************************************************************
# config.vs2013-64.mk                                    Make-It-Quick project
#******************************************************************************
#
#  File Description:
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
#******************************************************************************
# (C) 1992-2018 Christophe de Dinechin <christophe@dinechin.org>
#     This software is licensed under the GNU General Public License v3
#     See LICENSE file for details.
#******************************************************************************

DEFINES_BUILDENV_vs2013-64=$(DEFINES_BUILDENV_vs2013)
LDFLAGS_BUILDENV_vs2013-64=$(LDFLAGS_BUILDENV_vs2013)
OS_NAME_BUILDENV_vs2013-64=windows

include $(MIQ)config.vs2013.mk
