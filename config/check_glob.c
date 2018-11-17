#include <glob.h>

int glob_error(const char *epath, int errno)
{
    return 0;
}

int main()
{
    glob_t files;
    const char *pattern = "*";
    glob(pattern, GLOB_MARK, glob_error, &files);
    globfree(&files);
}
