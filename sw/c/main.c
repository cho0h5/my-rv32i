const int a = 21;

#define TOHOST (*((volatile int *)0x1000))

void exit(const int code) {
    if (code == 0) TOHOST = 1;
    else TOHOST = 2;
}

int __mulsi3(int a, int b) {
    int result = 0;
    while (b) {
        if (b & 1) result += a;
        a <<= 1;
        b >>= 1;
    }
    return result;
}

void main() {
    const int b = 2;

    if (a + b != 23) exit(1);

    if (a * b != 42) exit(1);

    exit(0);
}
