# blink raspbery pi 4 (baremetal)
This repo show the code to blink LED without OS.

## environment
host: macOS Big Sur 11.2.2

compiler: clang version 11.1.0

linker: LLD 11.1.0 (compatible with GNU linkers)

I used llvm to compile the program. If you want to use gnu compiler, edit Makefile.

## build
just run `make build` to build the program.

the datasheet for BCM2711 is [here](https://datasheets.raspberrypi.org/bcm2711/bcm2711-peripherals.pdf).
