#******************************************************************************
# config.msys.mk                                         Make-It-Quick project
#******************************************************************************
#
#  File Description:
#
#    Configuration file when building with MSYS
#
#
#
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

DEFINES_BUILDENV_msys=CONFIG_MSYS UNICODE _WIN32 WIN32
OS_NAME_BUILDENV_msys=windows

include $(MIQ)config.mingw.mk
LINE_BUFFERED=--line-buffered
