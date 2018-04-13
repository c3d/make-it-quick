#include <signal.h>

int main()
{
    struct sigaction sa;
    sigaction(11, &sa, NULL);
    return 0;
}
