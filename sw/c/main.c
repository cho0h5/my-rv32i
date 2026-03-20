const int a = 21;

#define TOHOST (*((volatile int *)0x1000))
#define UART_TX (*((volatile char *)0x4000))

void putchar(char c) {
    UART_TX = c;
}

void putstr(const char *s) {
    while (*s) putchar(*s++);
}

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

    putstr("hello, world\n");

    exit(0);
}
