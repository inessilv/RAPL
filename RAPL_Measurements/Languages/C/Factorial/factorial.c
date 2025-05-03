#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

long factorial(int n) 
{
    if (n <= 1)
        return 1;
    else
        return n * factorial(n - 1);
}

int main(int argc, char *argv[]) 
{
    if (argc != 2) 
    {
        printf("Usage: %s <n>\n", argv[0]);
        return 1;
    }

    int n = atoi(argv[1]);

    if (n < 0) 
    {
        printf("Value of n must be non-negative.\n");
        return 1;
    }

    long result = factorial(n);
    printf("Factorial(%d) = %ld\n", n, result);

    return 0;
}
