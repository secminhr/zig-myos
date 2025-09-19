const std = @import("std");
const io = @import("io.zig");

const bss_start = @extern([*]i8, .{ .name = "_bss_start" });
const bss_end = @extern([*]i8, .{ .name = "_bss_end" });

pub export fn boot() linksection(".text.boot") callconv(.naked) noreturn {
    asm volatile (
        \\la sp, _stack_top
        \\j kernel_main
    );
}

pub export fn kernel_main() void {
    @memset(bss_start[0..(bss_end - bss_start)], 0);
    _ = io.kwriter.print("Hello {d}", .{10}) catch {};

    while (true) {
        // infinite
    }
}
