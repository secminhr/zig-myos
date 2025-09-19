SECTIONS {
    . = 0x80200000;

    .text :{
        KEEP(*(.text.boot));
        *(.text .text.*);
    }

    .rodata : ALIGN(4) {
        *(.rodata .rodata.*);
    }

    .data : ALIGN(4) {
        *(.data .data.*);
    }

    .bss : ALIGN(4) {
        _bss_start = .;
        *(.bss .bss.* .sbss .sbss.*);
        _bss_end = .;
    }

    . = ALIGN(4);
    . += 128 * 1024;  /* 128 kb for stack, stack grows from higher addr to lower */
    _stack_top = .;
}