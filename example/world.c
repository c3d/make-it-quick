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
