// *****************************************************************************
// world.c                                                 make-it-quick project
// *****************************************************************************
//
// File description:
//
//     Simple test file for make-it-quick
//
//
//
//
//
//
//
//
// *****************************************************************************
// This software is licensed under the GNU General Public License v3
// (C) 2018-2019, Christophe de Dinechin <christophe@dinechin.org>
// *****************************************************************************
// This file is part of make-it-quick
//
// make-it-quick is free software: you can r redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// make-it-quick is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with make-it-quick, in a file named COPYING.
// If not, see <https://www.gnu.org/licenses/>.
// *****************************************************************************

#include "config.h"
#include <stdio.h>
#include <stdlib.h>

#if HAVE_SYS_IMPROBABLE_H
#warning "Improbable header present, probably a fault in the build system"
#endif

extern int lib1_foo(void);
extern int lib2_bar(void);

int world()
{
    if (lib1_foo() != 0)
      exit(1);
    if (lib2_bar() != 0)
      exit(2);
    printf("Hello World\n");
    return 0;
}
