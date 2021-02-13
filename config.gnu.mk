# ******************************************************************************
# config.gnu.mk                                            make-it-quick project
# ******************************************************************************
#
# File description:
#
#    Makefile configuration file for GNU tools
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

#------------------------------------------------------------------------------
#  Tools
#------------------------------------------------------------------------------

CC=             $(CROSS_COMPILE:%=%-)gcc
CXX=            $(CROSS_COMPILE:%=%-)g++
LD=		$(LD_$(words $(filter-out 0,$(words $(filter %.cpp,$(MIQ_SOURCES))))))
LD_0=		$(CC)
LD_1=           $(CXX)
CPP=            $(CC) -E
PYTHON=         python
AR=             $(CROSS_COMPILE:%=%-)ar -rcs
RANLIB=         $(CROSS_COMPILE:%=%-)ranlib
INSTALL=	install
INSTALL.data=   $(INSTALL) -m 644
INSTALL.bin=	$(INSTALL)
INSTALL.h=	$(INSTALL.data)
INSTALL.share=	$(INSTALL.data)
INSTALL.lib=	$(INSTALL)
INSTALL.man=	$(INSTALL.data)
INSTALL.doc=	$(INSTALL.data)
INSTALL.etc=	$(INSTALL.data)
UNINSTALL=	/bin/rm -f
UNINSTALL.dir=	/bin/rmdir > /dev/null 2>&1
UNINSTALL.ok=	|| true
CAT=		cat /dev/null

# Tarball generation
GEN_TARBALL=	mkdir $(MIQ_TARNAME) &&				\
		tar cf - AUTHORS NEWS $(shell git ls-files)  |	\
		(cd $(MIQ_TARNAME); tar xf - ) &&		\
		tar cfj $@ $(MIQ_TARNAME) &&			\
		rm -rf $(MIQ_TARNAME)

GEN_AUTHORS=	(echo "This software was brought to you by:";	\
	         echo "" ;					\
		 git log --format='%aN <%aE>' | sort -u |	\
		 sed -e 's/^/- /g';				\
		 echo ""; 					\
		 echo "Thank you!")
GEN_NEWS_TAG=	$(shell git tag -n1 `git describe`)
GEN_NEWS=	$(GEN_NEWS_TAG:%=grep '^$(GEN_NEWS_TAG' $@ || 		\
		 (touch $@;						\
		  (git tag -l $(shell git describe) -n999 ;		\
		  echo "";						\
		  cat $@)						\
		  > $@.latest && mv $@.latest $@))


#------------------------------------------------------------------------------
#  Compilation flags
#------------------------------------------------------------------------------

CFLAGS_STD=		$(CC_STD:%=-std=%)	$(CFLAGS_PIC)
CXXFLAGS_STD=		$(CXX_STD:%=-std=%)	$(CFLAGS_PIC)
CFLAGS_DEPENDENCIES=	-MD -MP -MF "$(@).d" -MT "$(@:$(MIQ_OBJDIR)%=\$$(MIQ_OBJDIR)%)"

CFLAGS_TARGET_debug=	-g -Wall -fno-inline
CFLAGS_TARGET_opt=	-g -O3 -Wall
CFLAGS_TARGET_release=	-O3 -Wall
CFLAGS_TARGET_profile=	-pg
LDFLAGS_TARGET_debug=	-g
LDFLAGS_TARGET_profile=	-pg


#------------------------------------------------------------------------------
#  File extensions
#------------------------------------------------------------------------------

EXT.exe=
ifdef LIBTOOL
EXT.obj=        .lo
EXT.lib=	.la
EXT.dll=	.la
else
EXT.obj=        .o
EXT.lib=        .a
EXT.dll=        .so
endif

PFX.exe=
PFX.lib=	lib
PFX.dll=	lib


#------------------------------------------------------------------------------
#  Shared libraries versioning
#------------------------------------------------------------------------------

MIQ_SOBASE=		$(@F:%.install_dll=%)
MIQ_SONAME=		$(MIQ_SOBASE)$(MIQ_V_MAJOR:%=.%)
MIQ_DLLNAME=		$(@:%.install_dll=%)$(PRODUCTS_VERSION:%=.$(MIQ_V_VERSION))

# Conversion to libttool input
MIQ_LT_CURRENT=	$(shell echo $$(($(MIQ_V_MAJOR) + $(MIQ_V_MINOR))))
MIQ_LT_REVISION=$(MIQ_V_PATCH)
MIQ_LT_AGE=	$(MIQ_V_MINOR)
MIQ_LT_VERSION=	$(MIQ_LT_CURRENT):$(MIQ_LT_REVISION):$(MIQ_LT_AGE)
MIQ_LT_VERS_OPT=$(PRODUCTS_VERSION:%=-version-info $(MIQ_LT_VERSION))

# Symbolic links for shared libraries
MIQ_SONAME_OPT=	$(PRODUCTS_VERSION:%=-Wl,-soname -Wl,$(MIQ_SONAME))
MIQ_SYMLINKS_SO=ln -sf $(notdir $(MIQ_DLLNAME)) $(MIQ_SOBASE) && 	\
		ln -sf $(notdir $(MIQ_DLLNAME)) $(MIQ_SONAME)
MIQ_SYMLINKS=	$(PRODUCTS_VERSION:%=&& $(MIQ_SYMLINKS_SO))


#------------------------------------------------------------------------------
#  Build rules
#------------------------------------------------------------------------------

# Select RPATH to include test paths for debug and opt
# For TARGET==release, you must install to test
RPATH=		$(RPATH_$(TARGET)) $(PREFIX.dll)
RPATH_debug=	. $(OUTPUT)
RPATH_opt=	. $(OUTPUT)
RPATH_release=

MAKE_DIR=	mkdir -p $*
MAKE_OBJDIR=	$(MAKE_DIR) && touch $@
LDFLAGS_RPATH=	$(RPATH:%=-Wl,-rpath,%)

ifdef LIBTOOL
COMPILE-lt=	$(LIBTOOL) --silent --mode=compile
LINK-lt=	$(LIBTOOL) --silent --mode=link
COMPILE.c=	$(COMPILE-lt) $(CC)  $(MIQ_CFLAGS)   -c $< -o $@
COMPILE.cpp=	$(COMPILE-lt) $(CXX) $(MIQ_CXXFLAGS) -c $< -o $@
COMPILE.s=	$(COMPILE-lt) $(CC)  $(MIQ_CFLAGS)   -c $< -o $@
LINK.lib=	$(LINK-lt)    $(LD)  $(MIQ_LDFLAGS) $(MIQ_LINKARGS)	\
			-o $@						\
			$(MIQ_LT_VERS_OPT)
LINK.dll=	$(LINK.lib)
INSTALL.dll=	$(LIBTOOL) --silent --mode=install			\
			$(INSTALL) $(MIQ_DLLNAME) $(PACKAGE_INSTALL.dll)
LINK.exe=	$(MIQ_LINK)    $(LD)  $(MIQ_LINKARGS) $(MIQ_LDFLAGS) -o $@
else
# Non-libtool case: manage manually
CFLAGS_PIC=	-fPIC
COMPILE.c=	$(CC)	$(MIQ_CFLAGS)	-c $< -o $@
COMPILE.cpp=	$(CXX)	$(MIQ_CXXFLAGS)	-c $< -o $@
COMPILE.s=	$(CC)	$(MIQ_CFLAGS)	-c $< -o $@
LINK.lib=	$(AR) $@ $^ && $(RANLIB) $@
LINK.dll=	$(LD) -shared	$(MIQ_LINKARGS)	$(MIQ_LDFLAGS)  \
				-o $(MIQ_DLLNAME)		\
				$(MIQ_SONAME_OPT)		\
		&& (cd $(OUTPUT) $(MIQ_SYMLINKS))
INSTALL.dll= 	$(INSTALL) $(MIQ_DLLNAME) $(PACKAGE_INSTALL.dll) \
		&& (cd $(PACKAGE_INSTALL.dll) $(MIQ_SYMLINKS))
LINK.exe=	$(LD)		 $(MIQ_LINKARGS) $(MIQ_LDFLAGS) -o $@
endif

COMPILE.cc=	$(COMPILE.cpp)
COMPILE.asm=	$(COMPILE.s)

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
			sed -e 's|// [A-Z]*FLAGS=||g')			\
		$(shell $(CAT) $(MIQ_PKGLDFLAGS))
MIQ_CFGFLAGS=	$(MIQ_CFGLFLAGS)					\
		$(shell $(CAT) $(MIQ_PKGCFLAGS))

MIQ_CFGSET=	&& MIQ_CFGRC=1 || MIQ_CFGRC=0;
MIQ_CFGTEST=	"$<" -o "$<".exe > "$<".err 2>&1 &&			\
		[ -x "$<".exe ] &&					\
		"$<".exe > "$<".out					\
		$(MIQ_CFGSET)
MIQ_CFG_PRINT=	if [ $$MIQ_CFGRC == 1 ]; then				\
		    echo "[OK]";					\
		else							\
		    echo "[NO]";					\
		fi;
MIQ_CFGUNDEF0=	$$MIQ_CFGRC						\
	| sed -e 's|^\#define \(.*\) 0$$|/* \#undef \1 */|g' > "$@";	\
	[ -f "$<".out ] && cat >> "$@" "$<".out; 			\
	$(MIQ_CFG_PRINT)						\
	true

MIQ_CFGDEF=	echo '\#define'

MIQ_CFGCFLAGS=	$(CFLAGS)   $(CFLAGS_CONFIG_$*) $(MIQ_CFGFLAGS)
MIQ_CFGCXXFLAGS=$(CXXFLAGS) $(CFLAGS_CONFIG_$*) $(MIQ_CFGFLAGS)

MIQ_CFGCC_CMD=	$(CC)  $(MIQ_CFGCFLAGS)   			$(MIQ_CFGTEST)
MIQ_CFGCXX_CMD=	$(CXX) $(MIQ_CFGCXXFLAGS) 			$(MIQ_CFGTEST)
MIQ_CFGLIB_CMD=	$(CC)  $(MIQ_CFGLFLAGS)  -l$* 			$(MIQ_CFGTEST)
MIQ_CFGFN_CMD=	$(CC)  $(MIQ_CFGCFLAGS) $(CFLAGS_CONFIG_$*)	$(MIQ_CFGTEST)
MIQ_CFGPK_CMD=  pkg-config $* --silence-errors 			$(MIQ_CFGSET)

MIQ_CC_CFG=	$(MIQ_CFGCC_CMD)  $(MIQ_CFGDEF) HAVE_$(MIQ_CFGUPPER)_H 	$(MIQ_CFGUNDEF0)
MIQ_CXX_CFG=	$(MIQ_CFGCXX_CMD) $(MIQ_CFGDEF) HAVE_$(MIQ_CFGUPPER)   	$(MIQ_CFGUNDEF0)
MIQ_LIB_CFG=	$(MIQ_CFGLIB_CMD) $(MIQ_CFGDEF) HAVE_LIB$(MIQ_CFGUPPER)	$(MIQ_CFGUNDEF0)
MIQ_FN_CFG=	$(MIQ_CFGFN_CMD)  $(MIQ_CFGDEF) HAVE_$(MIQ_CFGUPPER) 	$(MIQ_CFGUNDEF0)
MIQ_PK_CFG=	$(MIQ_CFGPK_CMD)  $(MIQ_CFGDEF) HAVE_$(MIQ_CFGUPPER)    $(MIQ_CFGUNDEF0)

MIQ_MK_CFG=	sed	-e 's|^\#define \([^ ]*\) \(.*\)$$|\1=\2|g' 	\
			-e 's|.*undef.*||g' < "$<" > "$@"


#------------------------------------------------------------------------------
#  pkg-config checks
#------------------------------------------------------------------------------

MIQ_PKGCONFIG_CFLAGS_CHECK=						\
	pkg-config --cflags $* > $@	$(MIQ_PKGCONFIG_ERROR_CHECK)

MIQ_PKGCONFIG_LIBS_CHECK=						\
	pkg-config --libs $* > $@	$(MIQ_PKGCONFIG_ERROR_CHECK)

MIQ_PKGCONFIG_ERROR_CHECK=						\
	|| (echo "Error"": Required package $* not found" && false)

MIQ_PKGCONFIG_BUILDMK=							\
	(echo CFLAGS_PKGCONFIG=`$(CAT) $(MIQ_PKGCFLAGS)`;		\
	 echo LDFLAGS_PKGCONFIG=`$(CAT) $(MIQ_PKGLDFLAGS) $(MIQ_PKGLIBS)` ) > $@

MIQ_PKGCONFIG_CFLAGS_OPTIONAL=						\
	(pkg-config --cflags $* --silence-errors > $@			\
	&& MIQ_CFGRC=1 || MIQ_CFGRC=0;					\
	true)

MIQ_PKGCONFIG_LIBS_OPTIONAL=						\
	(pkg-config --libs $* --silence-errors > $@			\
	&& MIQ_CFGRC=1 || MIQ_CFGRC=0;					\
	true)



#------------------------------------------------------------------------------
#   Test checks
#------------------------------------------------------------------------------

MIQ_TEST=	&& MIQ_RC=1 || MIQ_RC=0; true
PRINT_TEST_OK=	if [ $$MIQ_RC == 1 ]; then				\
		    echo "[OK]";					\
		else							\
		    echo "[KO]";					\
		fi;
