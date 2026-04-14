#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

typedef int (*op_fn)(int, int);

int main(void) {
    char op[6];
    int a, b;

    while (scanf("%5s %d %d", op, &a, &b) == 3) {
        char libname[32];
        int n = snprintf(libname, sizeof(libname), "./lib%s.so", op);
        if (n < 0 || n >= (int)sizeof(libname)) {
            return 1;
        }

        void *handle = dlopen(libname, RTLD_NOW);
        if (handle == NULL) {
            return 1;
        }

        dlerror();
        op_fn fn = (op_fn)dlsym(handle, op);
        char *err = dlerror();
        if (err != NULL) {
            dlclose(handle);
            return 1;
        }

        int result = fn(a, b);
        printf("%d\n", result);

        if (dlclose(handle) != 0) {
            return 1;
        }
    }

    return 0;
}
