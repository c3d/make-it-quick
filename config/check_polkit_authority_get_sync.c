#include <polkit/polkit.h>
int main()
{
    if (0)
    {
        GCancellable cancellable;
        GError *error;
        polkit_authority_get_sync (&cancellable, &error);
    }

    return 0;
}
