#******************************************************************************
# config.haiku.mk						 make-it-quick
#******************************************************************************
#
#  File Description:
#
#    Configuration file for the Haiku operating system
#
#
#
#
#
#
#
#
#******************************************************************************
# (C) 2018 Christophe de Dinechin <christophe@dinechin.org>
#  This software is licensed under the GNU General Public License v3
#  See LICENSE file for details.
#******************************************************************************

DEFINES_BUILDENV_haiku=CONFIG_HAIKU
OS_NAME_BUILDENV_haiku=haiku

include $(MIQ)config.gnu.mk

TEST_ENV=	LIBRARY_PATH=$$LIBRARY_PATH:$(OUTPUT)
SEDOPT_haiku=	-u
