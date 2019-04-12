# ******************************************************************************
# rules.mk                                                 make-it-quick project
# ******************************************************************************
#
# File description:
#
#   Common rules for building the targets
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

# Include the Makefile configuration and local variables
MIQ?=make-it-quick/
include $(MIQ)config.mk

# Default build settings (definitions in specific config..mkXYZ)
MIQ_INCLUDES=  	$(INCLUDES)				\
		$(INCLUDES_BUILDENV_$(BUILDENV))	\
		$(INCLUDES_TARGET_$(TARGET))		\
		$(INCLUDES_VARIANT_$(VARIANT))		\
		$(INCLUDES_$*)

MIQ_DEFINES=	$(DEFINES)				\
		$(DEFINES_BUILDENV_$(BUILDENV))		\
		$(DEFINES_TARGET_$(TARGET))		\
		$(DEFINES_VARIANT_$(VARIANT))		\
		$(DEFINES_$*)

MIQ_CPPFLAGS=	$(CPPFLAGS)				\
		$(CPPFLAGS_BUILDENV_$(BUILDENV))	\
		$(CPPFLAGS_TARGET_$(TARGET))		\
		$(CPPFLAGS_VARIANT_$(VARIANT))		\
		$(CPPFLAGS_$*)				\
		$(MIQ_DEFINES:%=-D%)			\
		$(MIQ_INCLUDES:%=-I%)

MIQ_CFLAGS=	$(CFLAGS)				\
		$(CFLAGS_DEPENDENCIES)			\
		$(CFLAGS_STD)				\
		$(MIQ_CPPFLAGS)				\
		$(CFLAGS_PKGCONFIG)			\
		$(CFLAGS_BUILDENV_$(BUILDENV))		\
		$(CFLAGS_TARGET_$(TARGET))		\
		$(CFLAGS_VARIANT_$(VARIANT))		\
		$(CFLAGS_$*)

MIQ_CXXFLAGS= 	$(CXXFLAGS)				\
		$(MIQ_CPPFLAGS)				\
		$(CFLAGS_PKGCONFIG)			\
		$(CFLAGS_DEPENDENCIES)			\
		$(CXXFLAGS_STD)				\
		$(CXXFLAGS_BUILDENV_$(BUILDENV))	\
		$(CXXFLAGS_TARGET_$(TARGET))		\
		$(CXXFLAGS_VARIANT_$(VARIANT))		\
		$(CXXFLAGS_$*)

MIQ_LDFLAGS=	$(LDFLAGS)				\
		$(LDFLAGS_PKGCONFIG)			\
		$(LDFLAGS_BUILDENV_$(BUILDENV))		\
		$(LDFLAGS_TARGET_$(TARGET))		\
		$(LDFLAGS_VARIANT_$(VARIANT))		\
		$(LDFLAGS_RPATH)			\
		$(LDFLAGS_$*)

MIQ_PACKAGE= 	$(PACKAGE_NAME:%=$(MIQ_OBJDIR)%.pc)

MIQ_INSTALL=	$(TO_INSTALL:%=%.$(DO_INSTALL))		\
		$(MIQ_OUTEXE:%=%.$(DO_INSTALL)_exe)	\
		$(MIQ_OUTLIB:%=%.$(DO_INSTALL)_lib)	\
		$(MIQ_OUTDLL:%=%.$(DO_INSTALL)_dll)	\
		$(EXE_INSTALL:%=%.$(DO_INSTALL)_exe)	\
		$(LIB_INSTALL:%=%.$(DO_INSTALL)_lib)	\
		$(DLL_INSTALL:%=%.$(DO_INSTALL)_dll)	\
		$(HEADERS:%=%.$(DO_INSTALL)_hdr)	\
		$(HDR_INSTALL:%=%.$(DO_INSTALL)_hdr)	\
		$(SHR_INSTALL:%=%.$(DO_INSTALL)_shr)	\
		$(DOC_INSTALL:%=%.$(DO_INSTALL)_doc)	\
		$(MANPAGES:%=%.gz.$(DO_INSTALL)_man)	\
		$(MAN_INSTALL:%=%.gz.$(DO_INSTALL)_man)	\
		$(ETC_INSTALL:%=%.$(DO_INSTALL)_etc)	\
		$(MIQ_PACKAGE:%=%.$(DO_INSTALL)_pc)

MIQ_SOURCES=	$(SOURCES)				\
		$(SOURCES_BUILDENV_$(BUILDENV))		\
		$(SOURCES_TARGET_$(TARGET))		\
		$(SOURCES_VARIANT_$(VARIANT))		\
		$(MIQ_OUT_SOURCES)

# Automatically put the man pages in the correct section
MIQ_MANDIR=	$(PACKAGE_INSTALL_MAN)man$(MIQ_MANSECT)/
MIQ_MANSECT=	$(subst .,,$(suffix $(*:.gz=)))

ifndef MIQ_DIR
MIQ_FULLDIR:=   $(abspath .)/
MIQ_DIR:=       $(subst $(abspath $(TOP))/,,$(MIQ_FULLDIR))
MIQ_PRETTYDIR:= $(subst $(abspath $(TOP))/,[top],$(MIQ_FULLDIR)$(VARIANT:%=[%]))
MIQ_BUILDDATE:= $(shell /bin/date '+%Y%m%d-%H%M%S')
MIQ_OBJROOT:=	$(OBJFILES)$(BUILDENV)/$(CROSS_COMPILE:%=%-)$(TARGET)
MIQ_BUILDLOG:=  $(LOGS)build-$(BUILDENV)-$(CROSS_COMPILE:%=%-)$(TARGET)-$(MIQ_BUILDDATE).log
endif

# Configuration variables
MIQ_OBJDIR:=	$(MIQ_OBJROOT)/$(MIQ_DIR)
MIQ_OBJECTS=	$(MIQ_SOURCES:%=$(MIQ_OBJDIR)%$(OBJ_EXT))
MIQ_PRODEXE=	$(filter %.exe,$(PRODUCTS))
MIQ_PRODLIB=	$(filter %.lib,$(PRODUCTS))
MIQ_PRODDLL=	$(filter %.dll,$(PRODUCTS))
MIQ_PRODLIBS=	$(OUTPUT:%=$(LINK_DIR_OPT)%) $(filter %.lib %.dll,$(PRODUCTS))
MIQ_OUTEXE=	$(MIQ_PRODEXE:%.exe=$(OUTPUT)$(EXE_PFX)%$(EXE_EXT))
MIQ_OUTLIB=	$(MIQ_PRODLIB:%.lib=$(OUTPUT)$(LIB_PFX)%$(LIB_EXT))
MIQ_OUTDLL=	$(MIQ_PRODDLL:%.dll=$(OUTPUT)$(DLL_PFX)%$(DLL_EXT))
MIQ_OUTPRODS=	$(MIQ_OUTEXE) $(MIQ_OUTLIB) $(MIQ_OUTDLL)
MIQ_BUILDTEST=	$(MAKE) SOURCES=$(@:%.test=%) 			\
			PRODUCTS=$*_test.exe 			\
			RUN_TESTS=				\
			LINK_LIBS="$(MIQ_PRODLIBS)"		\
			.build

MIQ_RUNTEST=	$(TEST_ENV)					\
			$(TEST_CMD_$*)				\
			$(OUTPUT)$(EXE_PFX)$*_test$(EXE_EXT)	\
			$(TEST_ARGS_$*)

# Versioning for DLLs
MIQ_V_WORDS=	$(subst ., ,$(PRODUCTS_VERSION))
MIQ_V_MAJOR=	$(word 1,$(MIQ_V_WORDS) 0 0 0)
MIQ_V_MINOR=	$(word 2,$(MIQ_V_WORDS) 0 0 0)
MIQ_V_PATCH=	$(word 3,$(MIQ_V_WORDS) 0 0 0)
MIQ_V_VERSION=	$(MIQ_V_MAJOR).$(MIQ_V_MINOR).$(MIQ_V_PATCH)

# Check a common mistake with PRODUCTS= not being set or set without extension
# Even on Linux / Unix, the PRODUCTS variable must end in .exe for executables,
# in .lib for static libraries, and in .dll for dynamic libraries.
# This is to help executable build rules be more robust and not catch
# unknown extensions by mistake. The extension is replaced with the
# correct platform extension, i.e. .a for static libraries on Linux
ifneq ($(PRODUCTS),)
ifeq ($(MIQ_PRODEXE)$(MIQ_PRODLIB)$(MIQ_PRODDLL),)
$(error Error: Variable PRODUCTS must contain .exe, .lib or .dll)
endif
endif

MIQ_LIBS=	$(LIBRARIES) $(LINK_LIBS)
MIQ_LIBNAMES=   $(filter %.lib, $(notdir $(MIQ_LIBS)))
MIQ_DLLNAMES=   $(filter %.dll, $(notdir $(MIQ_LIBS)))
MIQ_OBJLIBS= 	$(MIQ_LIBNAMES:%.lib=$(OUTPUT)$(LIB_PFX)%$(LIB_EXT))
MIQ_OBJDLLS=    $(MIQ_DLLNAMES:%.dll=$(OUTPUT)$(DLL_PFX)%$(DLL_EXT))
MIQ_LINKLIBS=	$(MIQ_LIBNAMES:%.lib=$(LINK_LIB_OPT)%)	\
		$(MIQ_DLLNAMES:%.dll=$(LINK_DLL_OPT)%)
MIQ_TOLINK=     $(MIQ_OBJECTS) $(MIQ_OBJLIBS) $(MIQ_OBJDLLS)
MIQ_LINKARGS=   $(MIQ_OBJECTS)				\
		$(OUTPUT:%=$(LINK_DIR_OPT)%)		\
		$(MIQ_LINKLIBS)
MIQ_RECURSE=    $(MAKE) TARGET=$(TARGET)		\
			BUILDENV=$(RECURSE_BUILDENV) 	\
			TOP="$(abspath $(TOP))/"	\
			VARIANT=			\
			COLOR_FILTER=			\
			$(RECURSE)
MIQ_MAKEDEPS:=	$(MAKEFILE_LIST)
MIQ_INDEX:=     1
MIQ_COUNT:=     $(words $(MIQ_SOURCES))
MIQ_PROFOUT:=	$(subst $(EXE_EXT),,$(MIQ_OUTEXE))_prof_$(GIT_REVISION).vsp

MIQ_TARNAME=	$(PACKAGE_NAME)-$(PACKAGE_VERSION)
MIQ_TARBALL=	$(MIQ_TARNAME).tar.bz2

ifeq (3.80,$(firstword $(sort $(MAKE_VERSION) 3.80)))
MIQ_ORDERONLY=|
endif


#------------------------------------------------------------------------------
#   User targets
#------------------------------------------------------------------------------

all: $(TARGET)

debug opt release profile: $(LOGS).mkdir $(dir $(LAST_LOG)).mkdir
	$(PRINT_COMMAND) $(TIME) $(MAKE) TARGET=$@ RECURSE=.build LOG_COMMANDS= .build $(LOG_COMMANDS)

# Testing
test tests check installcheck: test-$(TARGET)

# Clean builds
rebuild: re-$(TARGET)

# Installation
install: install-$(TARGET)
uninstall: uninstall-$(TARGET)

clean: $(SUBDIRS:%=%.clean) $(VARIANTS:%=%.variant-clean)
	-$(PRINT_CLEAN) rm -f $(TO_CLEAN) $(MIQ_OBJECTS) $(DEPENDENCIES) $(MIQ_OUTPRODS) $(MIQ_TOLINK) config.h
%.clean:
	$(PRINT_COMMAND) cd $* && $(MIQ_RECURSE) clean $(COLORIZE)
%.variant-clean:
	$(PRINT_COMMAND) $(MIQ_RECURSE) VARIANT=$* VARIANTS= clean $(COLORIZE)

dist:	$(MIQ_TARBALL)
$(MIQ_TARBALL): AUTHORS NEWS
	$(PRINT_GENERATE) $(GEN_TARBALL)
AUTHORS: .ALWAYS
	$(PRINT_GENERATE) $(GEN_AUTHORS) > $@
NEWS: .ALWAYS
	$(PRINT_GENERATE) $(GEN_NEWS)

distclean nuke: clean
	-$(PRINT_CLEAN) rm -rf $(MIQ_OUTPRODS) $(OBJFILES) $(LOGS) $(MIQ_TARBALL)

help:
	@$(ECHO) "Available targets:"
	@$(ECHO) "  make                : Build default target (TARGET=$(TARGET))"
	@$(ECHO) "  make all            : Same"
	@$(ECHO) "  make debug          : Debug build"
	@$(ECHO) "  make opt            : Optimized build with debug info"
	@$(ECHO) "  make release        : Release build without debug info"
	@$(ECHO) "  make profile        : Profile build"
	@$(ECHO) "  make clean          : Clean build results (only BUILDENV=$(BUILDENV))"
	@$(ECHO) "  make rebuild        : Clean before building"
	@$(ECHO) "  make nuke           : Clean build directory"
	@$(ECHO) "  make check / test   : Build product and run sanity checks"
	@$(ECHO) "  make benchmark      : Build product, then run benchmarks"
	@$(ECHO) "  make install        : Build and install result"
	@$(ECHO) "  make uninstall      : Remove the installed results"
	@$(ECHO) "  make dist           : Create a tarball for packaging"
	@$(ECHO) "  make clang-format   : Reformat sources using clang-format"
	@$(ECHO) "  make v-[target]     : Build target in 'verbose' mode"
	@$(ECHO) "  make d-[target]     : Deep-checking of library dependencies"
	@$(ECHO) "  make top-[target]   : Rebuild from top-level directory"


#------------------------------------------------------------------------------
#   Internal targets
#------------------------------------------------------------------------------

.build: .hello .config .libraries .prebuild		\
	.recurse .objects .product			\
	.postbuild $(RUN_TESTS:%=.tests) .goodbye

.hello:
	@$(INFO) "[BEGIN]" $(TARGET) $(BUILDENV) in "$(MIQ_PRETTYDIR)"
.goodbye:
	@$(INFO) "[END]" $(TARGET) $(BUILDENV) in "$(MIQ_PRETTYDIR)"

# Sequencing build steps and build step hooks
.config: .hello
.config: $(VARIANTS:%=%.variant)
ifeq ($(VARIANTS),)
.config: $(CONFIG:%=config.h)
.config: $(MIQ_NORMCONFIG:%=$(MIQ_OBJDIR)CFG_HAVE_%.mk)
endif
.libraries: .config
.libraries: $(MIQ_OBJLIBS) $(MIQ_OBJDLLS)
.prebuild: .config
.objects: .prebuild
.objects: $(MIQ_OBJDIR:%=%.mkdir)
.product: $(MIQ_OUTPRODS)
.postbuild: .product .install
.install: $(DO_INSTALL:%=$(MIQ_INSTALL))
.tests: $(TESTS:%=%.test)
.goodbye: .postbuild


.PHONY: all debug opt release profile build test install rebuild
.PHONY: .hello .config .libraries .prebuild		\
	.recurse .objects .product			\
	.postbuild .goodbye
.PHONY: .ALWAYS


#------------------------------------------------------------------------------
#  Build target modifiers
#------------------------------------------------------------------------------
#  These are only defined when RECURSE is not set so that we can have
#  files that contain the patterns, e.g. log-file.c

ifndef RECURSE
# Make from the top-level directory (useful from child directories)
top-%:
	cd $(TOP); $(MAKE) $*

# Test build
test-%:
	$(PRINT_COMMAND) $(MAKE) RUN_TESTS=yes $*

# Verbose build (show all commands as executed)
v-% verbose-%:
	$(PRINT_COMMAND) $(MAKE) $* V=1

# Timed build (show the time for each step)
time-%:
	$(PRINT_COMMAND) time $(MAKE) TIME= $*

# Clean build
re-%: clean
	$(PRINT_COMMAND) $(MAKE) $*

# Timed build (show the time for each step)
notime-%:
	$(PRINT_COMMAND) $(MAKE) TIME= $*

# Installation build
install-%:
	$(PRINT_COMMAND) $(MAKE) $* DO_INSTALL=install
uninstall-%:
	$(PRINT_COMMAND) $(MAKE) TARGET=$* DO_INSTALL=uninstall .install

# Deep build (re-check all libraries instead of just resulting .a)
deep-%:
	$(PRINT_COMMAND) $(MAKE) $* DEEP_BUILD=.ALWAYS

# Silent build (logs errors only to build log
silent-%:
	$(PRINT_COMMAND) $(MAKE) $* -s --no-print-directory 2> $(MIQ_BUILDLOG)

# Logged build (show results and record them in build.log)
log-%:
	$(PRINT_COMMAND) $(MAKE) $*
nolog-%:
	$(PRINT_COMMAND) $(MAKE) $* LOG_COMMANDS=

# No colorization
nocolor-%:
	$(PRINT_COMMAND) $(MAKE) $* COLORIZE=

# For debug-install, run 'make TARGET=debug install'
debug-% opt-% release-% profile-%:
	@$(MAKE) TARGET=$(@:-$*=) $*
endif


#------------------------------------------------------------------------------
#  Subdirectories and requirements
#------------------------------------------------------------------------------

.recurse: $(SUBDIRS:%=%.recurse)
%.recurse:          $(MIQ_ORDERONLY:%=% .hello .prebuild)
	+$(PRINT_COMMAND) cd $* && $(MIQ_RECURSE) $(RECURSE_FLAGS_$*)

%.variant:
	$(PRINT_VARIANT) $(MAKE) VARIANTS= VARIANT=$* RECURSE=.build .build

%/.mkdir-only:
	$(PRINT_COMMAND) $(MAKE_DIR)
%/.mkdir:
	$(PRINT_COMMAND) $(MAKE_OBJDIR)
.PRECIOUS: %/.mkdir

# If LIBRARIES=foo/bar, go to directory foo/bar, which should build bar.a
$(OUTPUT)$(LIB_PFX)%$(LIB_EXT): $(DEEP_BUILD)
	+$(PRINT_COMMAND) cd $(firstword $(dir $(filter %$*, $(LIBRARIES:.lib=) $(SUBDIRS))) .nonexistent) && $(MIQ_RECURSE)
$(OUTPUT)$(DLL_PFX)%$(DLL_EXT): $(DEEP_BUILD)
	+$(PRINT_COMMAND) cd $(firstword $(dir $(filter %$*, $(LIBRARIES:.dll=) $(SUBDIRS))) .nonexistent) && $(MIQ_RECURSE)


#------------------------------------------------------------------------------
#  Progress printout
#------------------------------------------------------------------------------

MIQ_INCRIDX=	$(eval MIQ_INDEX:=$(shell echo $$(($(MIQ_INDEX)+1))))
MIQ_START=	$(eval MIQ_INDEX:=1) $(eval MIQ_COUNT:=$(words $?))
MIQ_PRINTCOUNT=	$(shell printf "%3d/%d" $(MIQ_INDEX) $(MIQ_COUNT))$(MIQ_INCRIDX)

# Printing out various kinds of statements
ifndef V
PRINT_COMMAND= 	@
PRINT_COMPILE=	$(PRINT_COMMAND) $(INFO) "[COMPILE$(MIQ_PRINTCOUNT)] " $<;
PRINT_BUILD= 	$(PRINT_COMMAND) $(INFO) "[BUILD]" $(shell basename $@);
PRINT_GENERATE= $(PRINT_COMMAND) $(INFO) "[GENERATE]" "$(shell basename "$@")";
PRINT_VARIANT=  $(PRINT_COMMAND) $(INFO) "[VARIANT]" "$*";
PRINT_INSTALL=  $(PRINT_COMMAND) $(INFO) "[INSTALL] " $(*F) in $(<D) $(COLORIZE);
PRINT_UNINSTALL=$(PRINT_COMMAND) $(INFO) "[UNINSTALL] " $(*F) $(COLORIZE);
PRINT_CLEAN=    $(PRINT_COMMAND) $(INFO) "[CLEAN] " $@ $(MIQ_PRETTYDIR) $(COLORIZE);
PRINT_COPY=     $(PRINT_COMMAND) $(INFO) "[COPY]" $< '=>' $@ ;
PRINT_DEPEND= 	$(PRINT_COMMAND) $(INFO) "[DEPEND] " $< ;
PRINT_TEST= 	$(PRINT_COMMAND) $(INFO) "[TEST]" $(@:.test=) ;
PRINT_CONFIG= 	$(PRINT_COMMAND) $(INFO_NONL) "[CONFIG]" "$(MIQ_ORIGTARGET)" ;
PRINT_PKGCONFIG=$(PRINT_COMMAND) $(INFO) "[PKGCONFIG]" "$*" ;
PRINT_LIBCONFIG=$(PRINT_COMMAND) $(INFO) "[LIBCONFIG]" "lib$*" ;
PRINT_REFORMAT= $(PRINT_COMMAND) $(INFO) "[REFORMAT]" "$*" $(COLORIZE);
endif

#------------------------------------------------------------------------------
#  Special for Fabien: make 'Directory'
#------------------------------------------------------------------------------

ifneq ($(filter $(MAKECMDGOALS:/=),$(SUBDIRS)),)
$(MAKECMDGOALS): .ALWAYS
	$(PRINT_COMMAND)	cd $@ && make
endif


ifdef RECURSE
#------------------------------------------------------------------------------
# Dependencies generation
#------------------------------------------------------------------------------

MIQ_DEPENDENCIES=$(MIQ_SOURCES:%=$(MIQ_OBJDIR)%$(OBJ_EXT).d)
MIQ_OBJDIR_DEPS=$(MIQ_OBJDIR)%.deps/.mkdir

MIQ_OBJDEPS=$(MIQ_OBJDIR_DEPS) $(MIQ_MAKEDEPS) $(MIQ_ORDERONLY:%=% .prebuild)

# Check if the compiler supports dependency flags (if not, do it the hard way)
ifndef CFLAGS_DEPENDENCIES

# The following is a trick to avoid errors if a header file appears in a
# generated dependency but no longer in the source code.
# The trick is quite ugly, but fortunately documented here:
# http://scottmcpeak.com/autodepend/autodepend.html
POSTPROCESS_DEPENDENCY?=                            \
    ( sed -e 's/.*://' -e 's/\\$$//' < $@ |         \
      fmt -1 |                                      \
      sed -e 's/^ *//' -e 's/$$/:/' >> $@ )

$(MIQ_OBJDIR)%.c$(OBJ_EXT).d:		%.c			$(MIQ_OBJDEPS)
	$(PRINT_DEPEND) ( $(CC_DEPEND) && $(POSTPROCESS_DEPENDENCY) )
$(MIQ_OBJDIR)%.cpp$(OBJ_EXT).d:		%.cpp			$(MIQ_OBJDEPS)
	$(PRINT_DEPEND) ( $(CXX_DEPEND) && $(POSTPROCESS_DEPENDENCY) )
$(MIQ_OBJDIR)%.ccc$(OBJ_EXT).d:		%.cc			$(MIQ_OBJDEPS)
	$(PRINT_DEPEND) ( $(CXX_DEPEND) && $(POSTPROCESS_DEPENDENCY) )
$(MIQ_OBJDIR)%.s$(OBJ_EXT).d: 		%.s			$(MIQ_OBJDEPS)
	$(PRINT_DEPEND) ( $(AS_DEPEND) && $(POSTPROCESS_DEPENDENCY) )
$(MIQ_OBJDIR)%.asm$(OBJ_EXT).d: 	%.asm			$(MIQ_OBJDEPS)
	$(PRINT_DEPEND) ( $(AS_DEPEND) && $(POSTPROCESS_DEPENDENCY) )

else

# Compiler has decent support for dependency generation
$(MIQ_OBJDIR)%$(OBJ_EXT).d: $(MIQ_OBJDIR)%$(OBJ_EXT)

endif


#------------------------------------------------------------------------------
#  Build inference rules
#------------------------------------------------------------------------------

# Compilation
$(MIQ_OBJDIR)%.c$(OBJ_EXT): 	%.c				$(MIQ_OBJDEPS)
	$(PRINT_COMPILE) $(MAKE_CC)
$(MIQ_OBJDIR)%.cpp$(OBJ_EXT): 	%.cpp 				$(MIQ_OBJDEPS)
	$(PRINT_COMPILE) $(MAKE_CXX)
$(MIQ_OBJDIR)%.cc$(OBJ_EXT): 	%.cc 				$(MIQ_OBJDEPS)
	$(PRINT_COMPILE) $(MAKE_CXX)
$(MIQ_OBJDIR)%.s$(OBJ_EXT): 	%.s				$(MIQ_OBJDEPS)
	$(PRINT_COMPILE) $(MAKE_AS)
$(MIQ_OBJDIR)%.asm$(OBJ_EXT): 	%.asm				$(MIQ_OBJDEPS)
	$(PRINT_COMPILE) $(MAKE_AS)

# Skip headers
$(MIQ_OBJDIR)%.h$(OBJ_EXT):
$(MIQ_OBJDIR)%.hpp$(OBJ_EXT):
$(MIQ_OBJDIR)%.hh$(OBJ_EXT):

# Include dependencies from current directory
# We only build when the target is set to avoid dependencies on 'clean'
ifeq ($(MAKECMDGOALS),.build)
-include $(MIQ_DEPENDENCIES)
endif

# Create output directory if necessary
$(MIQ_OUTPRODS):			| $(OUTPUT).mkdir-only

# Link
.SECONDEXPANSION:
MIQ_NOSRC=	$(@:$(OUTPUT)%=%)
MIQ_NOEXE=	$(MIQ_NOSRC:$(EXE_PFX)%$(EXE_EXT)=%)
MIQ_NOLIB=	$(MIQ_NOEXE:$(LIB_PFX)%$(LIB_EXT)=%)
MIQ_NODLL=	$(MIQ_NOLIB:$(DLL_PFX)%$(DLL_EXT)=%)
MIQ_OUT_SOURCES=$(SOURCES_$(MIQ_NODLL))
$(MIQ_OUTLIB): $(MIQ_TOLINK) $$(MIQ_TOLINK)	 		$(MIQ_MAKEDEPS)
	$(PRINT_BUILD) $(MAKE_LIB)
$(MIQ_OUTDLL): $(MIQ_TOLINK) $$(MIQ_TOLINK)			$(MIQ_MAKEDEPS)
	$(PRINT_BUILD) $(MAKE_DLL)
$(MIQ_OUTEXE): $(MIQ_TOLINK) $$(MIQ_TOLINK)			$(MIQ_MAKEDEPS)
	$(PRINT_BUILD) $(MAKE_EXE)

#------------------------------------------------------------------------------
#   Package configuration
#------------------------------------------------------------------------------

# Package configuration file
MIQ_PKGCFLAGS= 	$(PKGCONFIGS:%=$(MIQ_OBJDIR)%.pkg-config.cflags)
MIQ_PKGLDFLAGS=	$(PKGCONFIGS:%=$(MIQ_OBJDIR)%.pkg-config.ldflags)
MIQ_PKGCONFIGS=	$(PKGCONFIGS:%?=%)
MIQ_PKGCFG=	$(MIQ_PKGONFIGS:%=$(MIQ_OBJDIR)CFG_HAVE_PACKAGE_%.h)
MIQ_PKGLIBS=	$(patsubst %,$(MIQ_OBJDIR)%.cfg.ldflags,$(filter lib%,$(CONFIG)))
MIQ_PKGDEPS=	$(MIQ_MAKEDEPS) $(MIQ_OBJDIR).mkdir

# Build the package config from cflags, ldflags and libs config
$(MIQ_OBJDIR)pkg-config.mk: $(MIQ_PKGCFLAGS) $(MIQ_PKGLDFLAGS) $(MIQ_PKGLIBS)
	$(PRINT_COMMAND) $(MIQ_PKGCONFIG_BUILDMK)

# Include rules for makefiles
-include $(PKGCONFIGS:%=$(MIQ_OBJDIR)pkg-config.mk)
-include $(MIQ_PKGLIBS:%=$(MIQ_OBJDIR)pkg-config.mk)

# Optional packages end with ?, e.g. PKGCONFIG=openssl?
$(MIQ_OBJDIR)%?.pkg-config.cflags:				$(MIQ_PKGDEPS)
	$(PRINT_PKGCONFIG) $(MIQ_PKGCONFIG_CFLAGS_OPTIONAL)
$(MIQ_OBJDIR)%?.pkg-config.ldflags: 				$(MIQ_PKGDEPS)
	$(PRINT_COMMAND)  $(MIQ_PKGCONFIG_LIBS_OPTIONAL)

# Non-optional packages
$(MIQ_OBJDIR)%.pkg-config.cflags: 					$(MIQ_PKGDEPS)
	$(PRINT_PKGCONFIG)	$(MIQ_PKGCONFIG_CFLAGS_CHECK)
$(MIQ_OBJDIR)%.pkg-config.ldflags: 					$(MIQ_PKGDEPS)
	$(PRINT_COMMAND)	$(MIQ_PKGCONFIG_LIBS_CHECK)
$(MIQ_OBJDIR)lib%.cfg.ldflags: $(MIQ_OBJDIR)CFG_HAVE_lib%.h		$(MIQ_PKGDEPS)
	$(PRINT_COMMAND)  (grep -q 'define ' $< && echo $(LINK_CFG_OPT)$* || true) > $@


#------------------------------------------------------------------------------
#   Configuration rules
#------------------------------------------------------------------------------

# Normalize header configuration name (turn <foo.h> into .lt.foo.h.gt. and back)
MIQ_NORMCONFIG=$(subst <,.lt.,$(subst >,.gt.,$(subst /,.sl.,$(CONFIG) $(PKGCONFIGS:%=PACKAGE_%))))
MIQ_ORIGTARGET=$(subst .lt.,<,$(subst .gt.,>,$(subst .sl.,/,$*)))
MIQ_CONFIGDEPS=	$(MIQ_PKGDEPS) 						\
		$(PKGCONFIGS:%=$(MIQ_OBJDIR)pkg-config.mk)		\
		$(MIQ_PKGLIBS:%=$(MIQ_OBJDIR)pkg-config.mk)		\
		$(MIQ_ORDERONLY:%=% .hello)

# Generate the config.h by concatenating all the indiviual config files
config.h: $(MIQ_NORMCONFIG:%=$(MIQ_OBJDIR)CFG_HAVE_%.h)
	$(PRINT_GENERATE) cat $^ > $@

# Build makefile configuration files from generated .h files
$(MIQ_OBJDIR)CFG_HAVE_%.mk: $(MIQ_OBJDIR)CFG_HAVE_%.h 		$(MIQ_MAKEDEPS)
	$(PRINT_COMMAND) $(MIQ_MK_CFG)
-include $(MIQ_NORMCONFIG:%=$(MIQ_OBJDIR)CFG_HAVE_%.mk)

# C standard headers, e.g. HAVE_<stdio.h>
$(MIQ_OBJDIR)CFG_HAVE_.lt.%.h.gt..h: $(MIQ_OBJDIR)CFGCH%.c	$(MIQ_CONFIGDEPS)
	$(PRINT_CONFIG) $(MIQ_CC_CFG)
$(MIQ_OBJDIR)CFGCH%.c: $(MIQ_OBJDIR).mkdir			$(MIQ_CONFIGDEPS)
	$(PRINT_COMMAND) (echo '#include' "<$(MIQ_ORIGTARGET).h>" && echo 'int main() { return 0; }') > "$@"
.PRECIOUS: $(MIQ_OBJDIR)CFGCH%.c

# C++ Standard headers, e.g. HAVE_<iostream>
$(MIQ_OBJDIR)CFG_HAVE_.lt.%.gt..h: $(MIQ_OBJDIR)CFGCPPH%.cpp	$(MIQ_CONFIGDEPS)
	$(PRINT_CONFIG) $(MIQ_CXX_CFG)
$(MIQ_OBJDIR)CFGCPPH%.cpp: $(MIQ_OBJDIR).mkdir			$(MIQ_CONFIGDEPS)
	$(PRINT_COMMAND) (echo '#include' "<$(MIQ_ORIGTARGET)>" && echo 'int main() { return 0; }') > "$@"
.PRECIOUS: $(MIQ_OBJDIR)CFGCPPH%.cpp

# Library, e.g. libm
$(MIQ_OBJDIR)CFG_HAVE_lib%.h: $(MIQ_OBJDIR)CFGLIB%.c		$(MIQ_PKGDEPS)
	$(PRINT_CONFIG) $(MIQ_LIB_CFG)
$(MIQ_OBJDIR)CFGLIB%.c: 					$(MIQ_PKGDEPS)
	$(PRINT_COMMAND) echo 'int main() { return 0; }' > "$@"
.PRECIOUS: $(MIQ_OBJDIR)CFGLIB%.c

# Check if a function is present (code to test in config/check_foo.c)
$(MIQ_OBJDIR)CFG_HAVE_%.h: $(MIQ_OBJDIR)CFGFN%.c		$(MIQ_CONFIGDEPS)
	$(PRINT_CONFIG)	$(MIQ_FN_CFG)
$(MIQ_OBJDIR)CFGFN%.c: $(CONFIG_SOURCES)check_%.c		$(MIQ_CONFIGDEPS)
	$(PRINT_COMMAND) cp $< $@
$(MIQ_OBJDIR)CFGFN%.c: $(MIQ)config/check_%.c			$(MIQ_CONFIGDEPS)
	$(PRINT_COMMAND) cp $< $@
$(MIQ_OBJDIR)CFGFN%.c: config/check_%.c				$(MIQ_CONFIGDEPS)
	$(PRINT_COMMAND) cp $< $@
.PRECIOUS: $(MIQ_OBJDIR)CFGFN%.c

# Packages
$(MIQ_OBJDIR)CFG_HAVE_PACKAGE_%?.h: 				$(MIQ_CONFIGDEPS)
	$(PRINT_CONFIG) $(MIQ_PK_CFG)
$(MIQ_OBJDIR)CFG_HAVE_PACKAGE_%.h: 				$(MIQ_CONFIGDEPS)
	$(PRINT_CONFIG) $(MIQ_PK_CFG)

endif


#------------------------------------------------------------------------------
#  Documentation generation
#------------------------------------------------------------------------------

# Man pages
man/%.gz:	man/%
	$(PRINT_GENERATE)	gzip -9 < $< > $@
man/%.[1-9]: man/%.pod
	$(PRINT_GENERATE)	pod2man $< $@


#------------------------------------------------------------------------------
#   Test targets
#------------------------------------------------------------------------------

# Run the test (in the object directory)
product.test: .product
	$(PRINT_TEST) $(TEST_ENV) $(TEST_CMD) $(MIQ_OUTEXE) $(TEST_ARGS)

# Run a test from a C or C++ file to link against current library
%.c.test %.cpp.test: $(MIQ_OUTPRODS)
	$(PRINT_TEST) $(MIQ_BUILDTEST) && $(MIQ_RUNTEST)
%/.test:
	+$(PRINT_TEST) cd $* && $(MIQ_RECURSE) RUN_TESTS=yes .build


#------------------------------------------------------------------------------
#  Benchmark targets
#------------------------------------------------------------------------------

# Benchmarking (always done with profile target)
benchmark:	$(BENCHMARKS:%=%.benchmark)
%.benchmark:
	$(PRINT_COMMAND) $(MAKE) TEST_ENV=$(BENCHMARK_TEST_ENV) $*.test


#------------------------------------------------------------------------------
#  Install targets
#------------------------------------------------------------------------------

# Installing the product: always need to build it first
%.install: $(PACKAGE_INSTALL).mkdir-only %
	$(PRINT_INSTALL) $(INSTALL_DATA) $* $(PACKAGE_INSTALL)
%.install_exe: $(PACKAGE_INSTALL_BIN).mkdir-only %
	$(PRINT_INSTALL) $(INSTALL_BIN) $* $(PACKAGE_INSTALL_BIN)
%.install_lib: $(PACKAGE_INSTALL_LIB).mkdir-only %
	$(PRINT_INSTALL) $(INSTALL_LIB) $* $(PACKAGE_INSTALL_LIB)
%.install_dll: $(PACKAGE_INSTALL_DLL).mkdir-only %
	$(PRINT_INSTALL) $(INSTALL_DLL)
%.install_hdr: $(PACKAGE_INSTALL_HDR).mkdir-only %
	$(PRINT_INSTALL) $(INSTALL_HDR) $* $(PACKAGE_INSTALL_HDR)
%.install_shr: $(PACKAGE_INSTALL_SHR).mkdir-only %
	$(PRINT_INSTALL) $(INSTALL_SHR) $* $(PACKAGE_INSTALL_SHR)
%.install_man: $(PACKAGE_INSTALL_MAN).mkdir-only %
	$(PRINT_COMMAND) $(MKDIR) -p $(MIQ_MANDIR)
	$(PRINT_INSTALL) $(INSTALL_MAN) $* $(MIQ_MANDIR)
%.install_doc: $(PACKAGE_INSTALL_DOC).mkdir-only %
	$(PRINT_INSTALL) $(INSTALL_DOC) $* $(PACKAGE_INSTALL_DOC)
%.install_etc: $(PACKAGE_INSTALL_SYSCONFIG).mkdir-only %
	$(PRINT_INSTALL) $(INSTALL_ETC) $* $(PACKAGE_INSTALL_SYSCONFIG)
%.install_pc: $(PACKAGE_INSTALL_PKGCONFIG).mkdir-only %
	$(PRINT_INSTALL) $(INSTALL_DATA) $* $(PACKAGE_INSTALL_PKGCONFIG)

# Uninstalling the product
%.uninstall:
	$(PRINT_UNINSTALL) $(UNINSTALL) $(*F:%=$(PACKAGE_INSTALL)%) ; $(UNINSTALL_DIR) $(PACKAGE_INSTALL) $(UNINSTALL_OK)
%.uninstall_exe:
	$(PRINT_UNINSTALL) $(UNINSTALL) $(*F:%=$(PACKAGE_INSTALL_BIN)%) ; $(UNINSTALL_DIR) $(PACKAGE_INSTALL_BIN) $(UNINSTALL_OK)
%.uninstall_lib:
	$(PRINT_UNINSTALL) $(UNINSTALL) $(*F:%=$(PACKAGE_INSTALL_LIB)%) ; $(UNINSTALL_DIR) $(PACKAGE_INSTALL_LIB) $(UNINSTALL_OK)
%.uninstall_dll:
	$(PRINT_UNINSTALL) $(UNINSTALL) $(*F:%=$(PACKAGE_INSTALL_DLL)%) ; $(UNINSTALL_DIR) $(PACKAGE_INSTALL_DLL) $(UNINSTALL_OK)
%.uninstall_hdr:
	$(PRINT_UNINSTALL) $(UNINSTALL) $(*F:%=$(PACKAGE_INSTALL_HDR)%) ; $(UNINSTALL_DIR) $(PACKAGE_INSTALL_HDR) $(UNINSTALL_OK)
%.uninstall_shr:
	$(PRINT_UNINSTALL) $(UNINSTALL) $(*F:%=$(PACKAGE_INSTALL_SHR)%) ; $(UNINSTALL_DIR) $(PACKAGE_INSTALL_SHR) $(UNINSTALL_OK)
%.uninstall_doc:
	$(PRINT_UNINSTALL) $(UNINSTALL) $(*F:%=$(PACKAGE_INSTALL_DOC)%) ; $(UNINSTALL_DIR) $(PACKAGE_INSTALL_DOC) $(UNINSTALL_OK)
%.uninstall_man:
	$(PRINT_UNINSTALL) $(UNINSTALL) $(*F:%=$(PACKAGE_INSTALL_MAN)%)
%.uninstall_etc:
	$(PRINT_UNINSTALL) $(UNINSTALL) $(*F:%=$(PACKAGE_INSTALL_SYSCONFIG)%)
%.uninstall_pc:
	$(PRINT_UNINSTALL) $(UNINSTALL) $(*F:%=$(PACKAGE_INSTALL_PKGCONFIG)%) ; $(UNINSTALL_DIR) $(PACKAGE_INSTALL_PKGCONFIG) $(UNINSTALL_OK)


#------------------------------------------------------------------------------
#  Generation of pkg-config data file
#------------------------------------------------------------------------------

MIQ_PACKAGELIBS=$(MIQ_PACKAGELDPATH)			\
		$(PACKAGE_LIBS:%.lib=$(LINK_LIB_OPT)%)	\
		$(PACKAGE_DLLS:%.dll=$(LINK_DLL_OPT)%)
MIQ_PACKAGELDPATH=$(firstword 				\
		$(PACKAGE_LIBS:%=-L$${libdir})		\
		$(PACKAGE_DLLS:%=-L$${libdir}))

MIQ_GENPC=					  	 \
	(echo 'prefix=$(PREFIX_BIN)'			;\
	echo 'exec_prefix=$${prefix}'			;\
	echo 'libdir=$(PREFIX_LIB)'			;\
	echo 'includedir=$(PREFIX__HDR)'		;\
	echo 'Name: $(PACKAGE_NAME)'			;\
	echo 'Description: $(PACKAGE_DESCRIPTION)'	;\
	echo 'Version: $(PACKAGE_VERSION)'		;\
	echo 'URL: $(PACKAGE_URL)'			;\
	echo 'Requires: $(PACKAGE_REQUIRES)'		;\
	echo 'Conflicts: $(PACKAGE_CONFLICTS)'		;\
	echo 'Libs: $(MIQ_PACKAGELIBS)'  		;\
	echo 'Cflags: -I$${includedir}'			)

$(MIQ_PACKAGE):						$(MIQ_MAKEDEPS)
	$(PRINT_BUILD)	$(MIQ_GENPC) > $@


#------------------------------------------------------------------------------
#  Clang format
#------------------------------------------------------------------------------

reformat clang-format:	$(CLANG_FORMAT_SOURCES:%=%.clang-format)
%.clang-format:
	$(PRINT_REFORMAT)	clang-format $* > $*.tmp && mv $*.tmp $*


#------------------------------------------------------------------------------
#  Makefile optimization tricks
#------------------------------------------------------------------------------

# Disable all built-in rules for performance
.SUFFIXES:

# Build with a single shell for all commands
.ONESHELL:

# Only build the leaf projects in parallel,
# since we don't have proper dependency between independent
# libraries and we may otherwise end up building the same
# library multiple times "in parallel" (wasting energy)
ifneq ($(SUBDIRS)$(VARIANTS),)
$(NOT_PARALLEL):
endif
