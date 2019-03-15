// ****************************************************************************
//  check_getpeereid.c                                           make-it-quick 
// ****************************************************************************
// 
//   File Description:
// 
//     Check if getpeereid exists
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

#include <sys/types.h>
#include <unistd.h>

int main()
{
    if (0) {
        int socket = 0;
        uid_t euid = 0;
        gid_t egid = 0;
        getpeereid(socket, &euid, &egid);
    }
    return 0;
}
