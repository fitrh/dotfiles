#include <stdio.h>

int main(void) {
        for (int i = 0; i < 11; i++) {
                for (int j = 0; j < 10; j++) {
                        int n = 10 * i + j;
                        printf("\033[%dm %3d\033[m", n, n);
                }
                printf("\n");
        }
        return 0;
}
