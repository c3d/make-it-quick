#******************************************************************************
# Makefile<example>                                      Make-It-Quick project
#******************************************************************************
#
#  File Description:
#
#    A makefile example for the Make-It-Quick project
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

# Define the source code
SOURCES=hello.cpp
SOURCES_world=world.c log-name.c

# Define libraries we use in that project
LIBRARIES=lib1/lib1.dll lib2/lib2.lib

# Define the product of the build (.exe will be removed for Unix builds)
PRODUCTS=hello.exe world.exe

# Define configuration options
CONFIG=	<stdio.h>		\
	<unistd.h>		\
	<nonexistent.h>		\
	<sys/time.h>		\
	<sys/improbable.h> 	\
	<iostream>		\
	clearenv		\
	libm			\
	liboony			\
	sbrk

# Define what to test
TESTS=product count-characters

# Define what to benchmark
BENCHMARKS=product

# Include the makefile rules
MIQ=../
include $(MIQ)rules.mk

count-characters.test:
	@echo Output has `$(TEST_ENV) $(OBJPRODUCTS) | wc -c` characters, should be 35
