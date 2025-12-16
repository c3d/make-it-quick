#include <string.h>
#include <signal.h>

int main()
{
    const char *s = strsignal(SIGINT);
    return s != 0;
}

