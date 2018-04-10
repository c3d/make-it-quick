#******************************************************************************
# config.gnu.mk                                          Make-It-Quick project
#******************************************************************************
#
#  File Description:
#
#    Makefile configuration file for GNU tools
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

#------------------------------------------------------------------------------
#  Tools
#------------------------------------------------------------------------------

CC=             $(CROSS_COMPILE:%=%-)gcc
CXX=            $(CROSS_COMPILE:%=%-)g++
ifeq ($(filter %.cpp,$(SOURCES)),)
LD=		$(CC)
else
LD=             $(CXX)
endif
CPP=            $(CC) -E
PYTHON=         python
AR=             $(CROSS_COMPILE:%=%-)ar -rcs
RANLIB=         $(CROSS_COMPILE:%=%-)ranlib
INSTALL=	install
CAT=		cat /dev/null


#------------------------------------------------------------------------------
#  Compilation flags
#------------------------------------------------------------------------------

CFLAGS_STD=		$(CC_STD:%=-std=%)	$(CFLAGS_PIC)
CXXFLAGS_STD=		$(CXX_STD:%=-std=%)	$(CFLAGS_PIC)
CFLAGS_DEPENDENCIES=	-MD -MP -MF $(@).d -MT $@

CFLAGS_TARGET_debug=	-g -Wall -fno-inline
CFLAGS_TARGET_opt=	-g -O3 -Wall
CFLAGS_TARGET_release=	-O3 -Wall
CFLAGS_TARGET_profile=	-pg
LDFLAGS_TARGET_debug=	-g
LDFLAGS_TARGET_profile=	-pg


#------------------------------------------------------------------------------
#  File extensions
#------------------------------------------------------------------------------

EXE_EXT=
ifdef LIBTOOL
OBJ_EXT=        .lo
LIB_EXT=	.la
DLL_EXT=	.la
else
OBJ_EXT=        .o
LIB_EXT=        .a
DLL_EXT=        .so
endif

EXE_PFX=
LIB_PFX=	lib
DLL_PFX=	lib

#------------------------------------------------------------------------------
#  Build rules
#------------------------------------------------------------------------------

MAKE_DIR=	mkdir -p $*
MAKE_OBJDIR=	$(MAKE_DIR) && touch $@

ifdef LIBTOOL
MIQ_COMPILE=	$(LIBTOOL) --silent --mode=compile
MIQ_LINK=	$(LIBTOOL) --silent --mode=link
MAKE_CC=	$(MIQ_COMPILE) $(CC)  $(MIQ_CFLAGS)   -c $< -o $@
MAKE_CXX=	$(MIQ_COMPILE) $(CXX) $(MIQ_CXXFLAGS) -c $< -o $@
MAKE_AS=	$(MIQ_COMPILE) $(CC)  $(MIQ_CFLAGS)   -c $< -o $@
MAKE_LIB=	$(MIQ_LINK)    $(LD)  $(MIQ_LDFLAGS) $(MIQ_TOLINK) -rpath $(PREFIX_DLL) -o $@
MAKE_DLL=	$(MAKE_LIB)
MAKE_EXE=	$(MIQ_LINK)    $(LD)  $(MIQ_LDFLAGS) $(MIQ_TOLINK) -o $@
else
# Non-libtool case: manage manually
CFLAGS_PIC=	-fPIC
MAKE_CC=	$(CC)	$(MIQ_CFLAGS)	-c $< -o $@
MAKE_CXX=	$(CXX)	$(MIQ_CXXFLAGS)	-c $< -o $@
MAKE_AS=	$(CC)	$(MIQ_CFLAGS)	-c $< -o $@
MAKE_LIB=	$(AR) $@	$(MIQ_TOLINK)	&& $(RANLIB) $@
MAKE_DLL=	$(LD) -shared	$(MIQ_LDFLAGS) $(MIQ_TOLINK) -o $@ -Wl,-rpath $(PREFIX_DLL)
MAKE_EXE=	$(LD)		$(MIQ_LDFLAGS) $(MIQ_TOLINK) -o $@
endif

LINK_DIR_OPT=	-L
LINK_LIB_OPT=	-l
LINK_DLL_OPT=	-l
LINK_CFG_OPT=	-l


#------------------------------------------------------------------------------
#   Dependencies
#------------------------------------------------------------------------------

CC_DEPEND=      $(CC)  $(MIQ_CPPFLAGS) -MM -MP -MF $@ -MT $(@:.d=) $<
CXX_DEPEND=     $(CXX) $(MIQ_CPPFLAGS) -MM -MP -MF $@ -MT $(@:.d=) $<
AS_DEPEND=      $(CC)  $(MIQ_CPPFLAGS) -MM -MP -MF $@ -MT $(@:.d=) $<


#------------------------------------------------------------------------------
#  Test environment
#------------------------------------------------------------------------------

TEST_ENV=	LD_LIBRARY_PATH=$(OUTPUT)


#------------------------------------------------------------------------------
#  Configuration checks
#------------------------------------------------------------------------------

MIQ_CFGUPPER=	$(shell echo -n "$(MIQ_ORIGTARGET)" | tr '[:lower:]' '[:upper:]' | tr -c '[:alnum:]' '_')
MIQ_CFGLFLAGS=	$(MIQ_LDFLAGS)						\
		$(shell grep '// [A-Z]*FLAGS=' "$<" |			\
			sed -e 's|// [A-Z]*FLAGS=||g')
MIQ_CFGFLAGS=	$(MIQ_CFGLFLAGS)					\
		$(shell $(CAT) $(MIQ_PKGCFLAGS) $(MIQ_PKGLDFLAGS))

MIQ_CFGTEST=	"$<" -o "$<".exe > "$<".err 2>&1 &&			\
		[ -x "$<".exe ] &&					\
		"$<".exe > "$<".out && MIQ_CFGRC=1 || MIQ_CFGRC=0;
MIQ_CFGUNDEF0=	$$MIQ_CFGRC						\
	| sed -e 's|^\#define \(.*\) 0$$|/* \#undef \1 */|g' > "$@";	\
	[ -f "$<".out ] && cat >> "$@" "$<".out; true

MIQ_CFGDEF=	echo '\#define'

MIQ_CFGCFLAGS=	$(MIQ_CFLAGS)  $(MIQ_CFGFLAGS) $(CFLAGS_CONFIG_$*)
MIQ_CFGCXXFLAGS=$(MIQCXXFLAGS) $(MIQ_CFGFLAGS) $(CFLAGS_CONFIG_$*)

MIQ_CFGCC_CMD=	$(CC)  $(MIQ_CFGCFLAGS)   $(MIQ_CFGTEST)
MIQ_CFGCXX_CMD=	$(CXX) $(MIQ_CFGCXXFLAGS) $(MIQ_CFGTEST)
MIQ_CFGLIB_CMD=	$(CC)  $(MIQ_CFGLFLAGS)  -l$* $(MIQ_CFGTEST)
MIQ_CFGFN_CMD=	$(CC)  $(MIQ_CFGCFLAGS) $(CFLAGS_CONFIG_$*)        $(MIQ_CFGTEST)

CC_CONFIG=	$(MIQ_CFGCC_CMD)  $(MIQ_CFGDEF) HAVE_$(MIQ_CFGUPPER)_H 	$(MIQ_CFGUNDEF0)
CXX_CONFIG=	$(MIQ_CFGCXX_CMD) $(MIQ_CFGDEF) HAVE_$(MIQ_CFGUPPER)   	$(MIQ_CFGUNDEF0)
LIB_CONFIG=	$(MIQ_CFGLIB_CMD) $(MIQ_CFGDEF) HAVE_LIB$(MIQ_CFGUPPER)	$(MIQ_CFGUNDEF0)
FN_CONFIG=	$(MIQ_CFGFN_CMD)  $(MIQ_CFGDEF) HAVE_$(MIQ_CFGUPPER) 	$(MIQ_CFGUNDEF0)

MAKE_CONFIG=	sed	-e 's|^\#define \([^ ]*\) \(.*\)$$|\1=\2|g' 	\
			-e 's|.*undef.*||g' < "$<" > "$@"
