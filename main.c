#include <stdio.h>

// Function to add two integers
int add(int a, int b) {
    return a + b;
}

int main() {
    int x = 5;
    int y = 7;

    int result = add(x, y);

    printf("The sum of %d and %d is %d\n", x, y, result);

    return 0; // program ends successfully
}

