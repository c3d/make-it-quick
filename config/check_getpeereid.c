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
