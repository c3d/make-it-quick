// *****************************************************************************
// check_gdk_event_get_scancode.c                          make-it-quick project
// *****************************************************************************
//
// File description:
//
//    Check if gdk_event_get_scancode function is sane
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

#include <gdk/gdk.h>

int main()
{
    if (0)
    {
        GdkEvent event;
        gdk_event_get_scancode(&event);
    }
    return 0l;
}
