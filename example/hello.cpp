// ****************************************************************************
//  hello.cpp                                                    make-it-quick 
// ****************************************************************************
// 
//   File Description:
// 
//     A simple "hello-world" test for make-it-quick
// 
// 
// 
// 
// 
// 
// 
// 
// ****************************************************************************
//   (C) 2019 Christophe de Dinechin <christophe@dinechin.org>
//   This software is licensed under the GNU General Public License v3
// ****************************************************************************
//   This file is part of make-it-quick.
// 
//   make-it-quick is free software: you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation, either version 3 of the License, or
//   (at your option) any later version.
// 
//   Foobar is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
// 
//   You should have received a copy of the GNU General Public License
//   along with make-it-quick.  If not, see <https://www.gnu.org/licenses/>.
// ****************************************************************************

#include "config.h"
#if HAVE_IOSTREAM
#include <iostream>
#elif HAVE_STDIO_H
#include <stdio.h>
#endif // IO

#if HAVE_SYS_IMPROBABLE_H
#warning "Improbable header present, probably a fault in the build system"
#endif

#ifndef HAVE_IOSTREAM
#warning "We expect to have iostream"
#endif

extern "C" int lib1_foo(void);
extern "C" int lib2_bar(void);

int main()
{
#if HAVE_IOSTREAM
    std::cout << "You successfully built using build\n";
#elif HAVE_STDIO_H
    printf("You successfully built using build (without iostream)\n");
#else
#warning "Building without <iostream> or <stdio.h>. Cross-compiling?"
#endif // HAVE_IOSTREAM

    if (lib1_foo() != 42)
      exit(1);
    if (lib2_bar() != 42)
      exit(2);

    return 0;
}
