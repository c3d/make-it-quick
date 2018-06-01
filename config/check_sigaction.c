#include <signal.h>

int main()
{
    struct sigaction sa;
    sigaction(11, &sa, (void *) 0);
    return 0;
}
