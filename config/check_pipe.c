#include <unistd.h>

int main(void)
{
    int fds[2];
    return pipe(fds);
}
