# Make-It-Quick (MIQ)
A simple makefile-based build system for C / C++ programs

## Features

Make-It-Quick is a simple build system destined to make it easy to build C or
C++ programs without having to write lengthy makefiles or going
through the complexity of tools such as `automake` or `cmake`. It is
well suited for relatively small programs, although it has been used
for at least one much larger program.

* Very short and readable makefiles offering all the most useful features
* Compact size (about 500 lines of active makefile code for a typical build)
* Fast, since short makefiles with few rules are quickly parsed
* Automatic, incremental project configuration, generating a `config.h` file
* Automatic logging of detailed build commands in log files
* Product testing with `make test`
* Product installation with `make install`
* Compact, colorized progress report
* Summary of errors and warnings at end of build
* Colorization of error and warning messages
* Rules to build various targets (optimized, debug, release, profile)
* Rule modifiers for common build options, e.g. `v-debug` for verbose debug
* Personal preferences easily defined with environment variables
* Built-in help (`make help`)
* Pure `make`, allowing you to use all standard `Makefile` syntax and features
* Automatic, single-pass generation of header-file dependencies
* Supports parallel builds
* Supports separate libraries, to accelerate builds (libraries are
  only built the first time, unless you request a "deep" build)
* Portable (tested on Linux, macOS and Windows platforms)

You can find examples of how 'Make-It-Quick' is used in other projects:

* [SPICE - Simple Protocol for Independent Computing Environments](https://github.com/c3d/spice)
* [Flight recorder](https://github.com/c3d/recorder/blob/master/Makefile)
* [XL programming language](https://github.com/c3d/XL-programming-language/blob/master/xlr/Makefile)
* [ELFE programming language](https://github.com/c3d/elfe/blob/master/src/Makefile)
* [XL reboot](https://github.com/c3d/xl/blob/master/Makefile)

## Using Make-It-Quick

To use `make-it-quick`, you create a `Makefile`. A minimal makefile only needs
to specify the name of the `SOURCES`, the name of the build `PRODUCTS`,
and include the `make-it-quick/rules.mk` file, which contains the makefile rules:

    MIQ=make-it-quick/
    SOURCES=my-super-tool.cpp helper.c
    PRODUCTS=my-super-tool.exe
    include $(MIQ)rules.mk

That's all you need to get started. There is a small sample `Makefile`
in this distribution.

In order to get a summary of the available build targets, use `make help`.

### Using Make-It-Quick as a submodule or integrated in a project

In case you want to add Make-It-Quick to a project without adding
another dependency, you can add Make-It-Quick as a submodule of your
project, or copy it directly in your project. In that case, you would
set the `MIQ` variable to point to a location of the `make-it-quick`
directory relative to the makefiles, for example:

    TOP=../
    MIQ=$(TOP)make-it-quick/
    SOURCES=my-super-tool.cpp helper.c
    PRODUCTS=my-super-tool.exe
    include $(MIQ)rules.mk


## Building libraries and shared libraries

The kind of output your makefile produces depends on the extension in
`PRODUCTS`. You can use:

* `.exe` for an executable binary
* `.lib` for a static library
* `.dll` for a dynamic library

The build commands for each case are defined in build environment
configurations, e.g. `config.gnu.mk`, by variables called `MAKE_EXE`,
`MAKE_LIB` and `MAKE_DLL`. The actual extension being used are also
defined in the same file, as `EXE_EXT`, `LIB_EXT` and `DLL_EXT`. For
example, on Linux, `LIB_EXT` is set to `.a`.


## Building the products

If you simply type `make`, a default build is launched. This is what
you should see if you do that in the `make-it-quick` directory itself:

    make-it-quick> make

    ****************************************************************
    * The BUILDENV environment variable is not set
    * You will accelerate builds by setting it as appropriate for
    * your system. The best guess is BUILDENV=macosx-clang
    * Attempting to build opt with macosx-clang DIR=/make-it-quick
    ****************************************************************

    [BEGIN]              opt macosx-clang in [top]/make-it-quick
    [GENERATE]           CONFIG_HAVE_stdio.c
    [CONFIG]             stdio
    [GENERATE]           CONFIG_HAVE_unistd.c
    [CONFIG]             unistd
    [GENERATE]           CONFIG_HAVE_nonexistent.c
    [CONFIG]             nonexistent
    [GENERATE]           CONFIG_HAVE_sys.sl.time.c
    [CONFIG]             sys.sl.time
    [GENERATE]           CONFIG_HAVE_sys.sl.improbable.c
    [CONFIG]             sys.sl.improbable
    [GENERATE]           CONFIG_HAVE_iostream.cpp
    [CONFIG]             iostream
    [COPY]               config/check_clearenv.c => objects/macosx-clang/opt/make-it-quick/CONFIG_CHECK_clearenv.c
    [CONFIG]             clearenv
    [GENERATE]           CONFIG_LIBm.c
    [CONFIG]             libm
    [GENERATE]           CONFIG_LIBoony.c
    [CONFIG]             liboony
    [COPY]               config/check_sbrk.c => objects/macosx-clang/opt/make-it-quick/CONFIG_CHECK_sbrk.c
    [CONFIG]             sbrk
    [GENERATE]           config.h
    [COMPILE  1/1]       hello.cpp
    [BUILD]              hello
    [END]                opt macosx-clang in [top]/make-it-quick

    real	0m2.243s
    user	0m1.206s
    sys	0m0.750s

The output of the build will be located by default in the top-level
directory for the build, or the directory specified by the `OUTPUT`
environment variable if it's set.

Temoprary files are placed in the `.objects` directory, or the
directory set by the `OBJFILES` environment variable if it's set.
There are subdirectories corresponding to the build environment and
the build target, so the final product could be for instance under
`.objects/macosx-clang/opt/hello`. This is explained below.

The log files will be located by default in `.logs`, the latest
one being called `make.log`, or in the directory specified by the
`LOGS` environment variable.

You can clean the build products with `make clean` and force a clean
build with `make rebuild`.

### Build tips

The makefiles are self-documented. You can get information
about the avaiable build targets using `make help`, and add your
own documentation by adding dependencies to the `help` target.

There are three primary build targets, `debug`, `opt` and
`release`, which are described in detail below. Build objects for
these primary targets are kept in separate locations, so that you can
quickly alternate between debug and optimized builds.

You can customize your build using either command-line variables or
target prefixes. Here are some examples:

    make v-debug          # Verbose debug build using v- prefix
    make V=1 debug        # Verbose build using variable
    make nocolor-debug    # Do not colorize output (prefix)
    make COLORIZE= debug  # Do not colorize output (variable)
    make notime-debug     # Do not collect build time (prefix)
    make TIME= debug      # Do not collect build time (variable)

You can build the target you prefer by default by setting the `TARGET`
environment variable, e.g.

    export TARGET=notime-nocolor-debug
    make                  # Builds a 'notime-nocolor-debug'


## Testing the products

Use `make test` or `make check` to test the product. The `check` target ensures
that everything is rebuilt before testing.

The simplest possible test is to simply run the generated program. You
can do this by adding a `TESTS` variable to your `Makefile`:

    SOURCES=hello.cpp
    PRODUCTS=hello.exe
    TESTS=product
    include make-it-quick/rules.mk

If you run `make test` (or `make check`) on the sample makefile found in the
distribution directory, you will run the `hello` program, after
building it if necessary:

     build> make test
     [BEGIN]              opt macosx-clang in [top]/build
     [COMPILE  1/1]       hello.cpp
     [BUILD]              hello
     [TEST]               product
     You successfully built using build
     Output has 35 characters, should be 35

As you can see in the sample `Makefile`, it is easy to add tests,
simply by adding a rule that ends in `.test`. In the sample file,
it is called `count-characters.test`.


## Building for debugging, release or profiling

The default build is an optimized build similar to what you would
achieve by running `make opt`. It is well optimized, but still retains
some debugging capabilities. The `DEBUG` and `OPTIMIZED` macros are
defined.

If you need more debugging capabilities, you can create a debug build
by using `make debug`. This disables most optimizations, making it
easier for the debugger to relate machine code to source code. The
`DEBUG` macro is defined for these builds.

If you want to remove all debugging symbols, you can generate a
release build by using `make release`. In that configuration, the
`NDEBUG`, `OPTIMIZED` and `RELEASE` flags are defined.

Finally, you can build for profiling using `make profile` and
benchmark the result using `make benchmark`. This is still only
partially tested and supported.

This list is likely to evolve over time, most notably with support for
Valgrind and other debug / analysis tools.


## Installing the product

To install the product, use `make install`. This often requires
super-user privileges.

    build> make install
    [INSTALL]            opt macosx-clang in [top]/build
    [INSTALL]            hello in /usr/local/bin


## Build modifiers

Several built target modifiers can be used to modify the meaning of a
following target. For example, the `v-` prefix disables output
filtering, so that you can see the complete build commands:

     build> make v-debug
     [...]
     [BEGIN]              debug macosx-clang in [top]/build
     g++ -std=gnu++0x                             -DCONFIG_MACOSX -DDEBUG   -g -Wall -fno-inline           -c hello.cpp -o objects/macosx-clang/debug/build/hello.cpp.o
     g++ -o objects/macosx-clang/debug/hello ./objects/macosx-clang/debug/build/hello.cpp.o   -framework CoreFoundation -framework CoreServices  -g
     [END]                debug macosx-clang in [top]/build


Note that this is not normally necessary, since the build commands are
preserved automatically in the build log every time you use `make`.

The build targets can be used also as build modifiers. For example, if
you do `make clean`, you only clean `opt` objects since this is the
default target. If you want to clean debug objects, use `make debug-clean`.
Similarly, you can do a release install with `make release-install`.

Note that you can make `debug` your default target by setting the
`TARGET` environment variable, see below.


## Environment variables

Several environment variables control the behavior of `make-it-quick`. The
variables that can be configured are found at the beginning of `config.mk`.
Note that all directory names should end with a trailing `/`.
Some of the most useful environment variables include:

* `BUILDENV` specifies the build environment, for example
  `macosx-clang` when building on MacOSX with Clang. Parameters for
  this build environment are defined in `config.$(BUILDENV).mk`, for
  example `config.macosx-clang.mk`. If not set, heuristics defined in
  `config.auto.mk` are used to try and determine the correct
  `BUILDENV`.

* `TARGET` specifies the default build target, which can be `opt`,
  `debug`, `release` or `profile` at the moment. If you often build
  debug targets, you only need to `export TARGET=debug`, and
  the default `make` will become equivalent to `make debug`.

* `PREFIX` specifies the installation location. You can also specify
  the installation location for executables (`PREFIX_BIN`), libraries
  (`PREFIX_LIB`) or shared libraries (`PREFIX_DLL`).
  For compatibility with `automake`-generated makefiles, you can also
  execute a staged install by setting `DESTDIR` when running `make`.

* `TOP` is the top-level directory for the build, which defaults to
  the directory in which `make` is started.

* `OUTPUT` is the directory where all build products should go. The
  default is the `$(TOP)`.

* `OBJFILES` is the directory where all build intermediate files
  should go. The default is `.objects/` in `$(TOP)

* `LOGS` is the directory where all logs should go. The default is
  `.logs/` in `$(TOP)`.


## Hierarchical projects

Often, a project is made of several directories or libraries. In
`make-it-quick`, this is supported with two makefile variables:

* `SUBDIRS` lists subdirectories of the top-level directory that
  must be built every time.

* `LIBRARIES` lists libraries, which can be subdirectories or not,
  which the products depends on. Each library should end in either
  `.lib` or `.dll` to indicate if it's to be shared statically or
  dynamically. Note that the `PRODUCTS` in the corresponding
  subdirectory should match and produce the correct output.

* `TOP` is the top-level directory, which is used for example when
  you build `make top-debug`.

Subdirectories are re-built everytime a top-level build is started,
whereas libraries are re-built only if they are missing. It is
possible to force a re-build of libraries using the `d-` or `deep-`
prefix for builds, for example `make deep-debug`.


## Project configuration

Often, projects have dependencies on specific features that are only
available on some platforms or after installing specific
dependencies. Tools such as `autoconf` and `automake`  address this
problem in a separate build step.

The `make-it-quick` configuration step is designed to generate a `config.h`
file with a content that is close enough to the output of `autoconf`
to allow a same project to be adapted for `make-it-quick` with minimal changes
in the source code.

In `make-it-quick`, you specify the configuration dependencies using the
`CONFIG` variable, which will define the various conditions you want
to test for. The result of the tests will be stored in a `config.h`
header file.

Here is an example from the sample `Makefile`:

    CONFIG= <stdio.h>                  \
            <unistd.h>                 \
            <nonexistent.h>            \
            <sys/time.h>               \
            <sys/improbable.h>         \
            <iostream>                 \
            clearenv                   \
            libm                       \
            liboony                    \
            sbrk

Here is what the generated `config.h` might look like:

    #define HAVE_STDIO_H 1
    #define HAVE_UNISTD_H 1
    /* #undef HAVE_NONEXISTENT_H */
    #define HAVE_SYS_TIME_H 1
    /* #undef HAVE_SYS_IMPROBABLE_H */
    #define HAVE_IOSTREAM 1
    /* #undef HAVE_CLEARENV */
    #define HAVE_LIBM 1
    /* #undef HAVE_LIBOONY */
    #define HAVE_SBRK 1
    #define CONFIG_SBRK_BASE ((void *) 0x104ab3000)

The following configuration options are recognized:

* C header files, such as `<stdio.h>`
* C++ header files, such as `<iostream>`
* Function names, such as `clearenv` or `sbrk`
* Library names, such as `libm`

For function names, a source file in the `config/` subdirectory will
specify how you test for the given function, and possibly return
additional output that will be integrated in the `config.h` file. The
file name begins with `check_` followed by the function being tested,
and can be located either in the `make-it-quick` directory, or in the
project directory. The `build/config` directory contains a few
examples of such tests for simple functions.

For example, the `config/check_sbrk.c` file contains the following:

    #include <unistd.h>
    #include <stdio.h>

    int main()
    {
        printf("#define CONFIG_SBRK_BASE ((void *) %p)\n", sbrk(0));
        return 0;
    }

Note that the example adds a `#define CONFIG_SBRK_BASE` in the
`config.h`. This is only for illustration purpose, since modern
systems attempt to randomize address space, making the value
returned by `sbrk(0)` different with each run.


## Package dependencies

A `make-it-quick` project can depend on other packages and use
`pkg-config` to easily get the required compilation or link flags. The
`PKGCONFIGS` variable lists the name of the required packages. if the
name ends with `?`, the package is optional, and the build with
succceed even if the package is not present.

For example, `PKGCONFIGS` may look like this, in which case packages
`pixman-1` and `gstreamer-1.0` are required, whereas package `openssl`
is optional.

    PKGCONFIGS=     pixman-1                    \
                    openssl?                    \
                    gstreamer-1.0


# Package configuration (for `pkg-config`)

To generate a `.pc` file suitable for `pkg-config`, set variables
in your makefile as follows:

    PACKAGE_NAME=my-great-stuff
    PACKAGE_VERSION=0.0.1
    PACKAGE_DESCRIPTION=This is insanely great stuff
    PACKAGE_URL=http://www.my-great-stuff.org
    PACKAGE_REQUIRES=some-library >= 0.3
    PACKAGE_BUGS=bugreports@my-great-stuff.org

A file called `my-great-stuff.pc` will be generated and installed
along with your product.

# Shared library versioning

Shared libraries can be versioned. Version numbers are typically
in the form major.minor.patch. The version number for a shared library
is taken from `PRODUCTS_VERSION`, which defaults to `PACKAGE_VERSION`.

For example, if `foo.dll` has `PRODUCTS_VERSION` is 1.3.2, this is
interpreted as major version 1, minor version 3 and patchlevel 2.
Accordingly, the library name is set to `libfoo.so.1.3.2`, the
soname is set to `libfoo.so.1`, and symbolc links `libfoo.so`
and `libfoo.so.1` will both point to `libfoo.so.1.3.2`.

## Other stuff

There a few utility targets, in particular:

* `clang-format` reformats all sources specified in `CLANG_FORMAT_SOURCES`
  (which defaults to `SOURCES` and `HDR_INSTALL`)


## Redistribution

The `make-it-quick` project is released under the GNU General Public
License version 3. The project author's reading of said license is
that it only "contaminates" derivative products, but not products
created *using* the product. In other words:

* Creating derivative software, e.g. a 'nanotoconf' project that uses
  `make-it-quick` code, requires you to comply with the GPL, and in
  particular to redistribute your code in source form. The fact that
  it's really hard to distribute makefiles in binary form should help
  you comply with this anyway :-)

* Building software using `make-it-quick` does not make that software
  GPL, any more than building it using GCC or GNU Make. I believe that
  `make-it-quick` can legally be used for proprietary software or for
  software using any other open-source license.

As long as I (Christophe de Dinechin) am the sole author / maintainer
of this software, this interpretation will prevail. If you believe
that I am in error in my understanding of the GPL v3, please send me
e-mail or raise an issue on GitHub or GitLab, and I will add a
licensing exception to that effect.


## Comparing build vs. autoconf on a real project

[![Building SPICE: autoconf vs. c3d/build](https://img.youtube.com/vi/uAAynpfCJa0/0.jpg)](https://www.youtube.com/watch?v=uAAynpfCJa0)
