#![no_std]
#![no_main]

use core::hint::black_box;
use core::panic::PanicInfo;

#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
fn __mulsi3(mut a: i32, mut b: i32) -> i32 {
    let mut result = 0;
    while b != 0 {
        if b & 1 != 0 {
            result += a;
        }
        a <<= 1;
        b >>= 1;
    }
    result
}

fn exit(code: i32) {
    let value = if code == 0 { 1 } else { 2 };

    unsafe {
        (0x1000 as *mut u32).write_volatile(value);
    }
}

#[no_mangle]
fn main() {
    let a = black_box(21);
    let b = black_box(2);

    if a + b != 23 {
        exit(1);
    }

    if a * b != 42 {
        exit(1);
    }

    exit(0);
}
