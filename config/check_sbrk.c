// ****************************************************************************
//  check_sbrk.c                                                 make-it-quick 
// ****************************************************************************
// 
//   File Description:
// 
//     Check if sbrk() exists
//     (macOS has been warning about deprecation for a while)
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

#include <unistd.h>
#include <stdio.h>

int main()
{
    printf("#define CONFIG_SBRK_BASE ((void *) %p)\n", sbrk(0));
    return 0;
}
