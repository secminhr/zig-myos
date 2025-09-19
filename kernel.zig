const std = @import("std");
const io = @import("io.zig");

const bss_start = @extern([*]i8, .{ .name = "_bss_start" });
const bss_end = @extern([*]i8, .{ .name = "_bss_end" });
const tvec_start = @extern(*i8, .{ .name = "_tvec_base" });

pub export fn boot() linksection(".text.boot") callconv(.naked) noreturn {
    asm volatile (
        \\la sp, _stack_top
        \\j kernel_main
    );
}

fn read_csr(comptime csr: []const u8) u32 {
    return asm volatile (
        "csrr %[ret], " ++ csr
        : [ret] "=r" (-> u32)
    );
}

fn write_csr(comptime csr: []const u8, value: u32) void {
    asm volatile (
        "csrw " ++ csr ++ ", %[value]"
        :
        : [value] "ri" (value)
    );
}

pub export fn tvec() linksection(".tvec") callconv(.naked) noreturn {
    asm volatile (
        @embedFile("tvec.s")
    );
}

pub export fn trap_handler(_: [*]u8) callconv(.c) noreturn {
    _ = io.kwriter.print("cause: 0x{x}, val: 0x{x}, exception pc: 0x{x}", .{read_csr("scause"), read_csr("stval"), read_csr("sepc")}) catch {};

    while (true) {
        
    }
}

pub export fn kernel_main() void {
    @memset(bss_start[0..(bss_end - bss_start)], 0);
    _ = io.kwriter.print("Hello {d}\n", .{10}) catch {};

    write_csr("stvec", @truncate(@intFromPtr(tvec_start)));
    asm volatile(
        \\unimp
    );
    // while (true) {
    //     // infinite
    // }
}
