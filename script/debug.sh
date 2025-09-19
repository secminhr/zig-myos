#!/bin/bash
qemu-system-riscv32 -machine virt -bios default -nographic -serial mon:stdio --no-reboot -kernel "$1" -S -s