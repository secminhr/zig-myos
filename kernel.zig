const std = @import("std");
const io = @import("io.zig");
const ecall = @import("ecall.zig");
const csr = @import("csr.zig");
const stimer = @import("stimer.zig");

const bss_start = @extern([*]i8, .{ .name = "_bss_start" });
const bss_end = @extern([*]i8, .{ .name = "_bss_end" });
const tvec_start = @extern(*i8, .{ .name = "_tvec_base" });
const stimer_period = 500000;

pub const panic = std.debug.FullPanic(panic_handler);
fn panic_handler(msg: []const u8, _: ?usize) noreturn {
    _ = io.kwriter.print("PANIC: {s}\n", .{ msg }) catch {};
    while (true) {}
}

pub export fn boot() linksection(".text.boot") callconv(.naked) noreturn {
    asm volatile (
        \\la sp, _stack_top
        \\j kernel_main
    );
}

pub export fn tvec() linksection(".tvec") callconv(.naked) noreturn {
    asm volatile (
        @embedFile("tvec.s")
    );
}

pub export fn trap_handler(_: [*]u8) callconv(.c) void {
    const cause = csr.read_csr("scause");
    const sync = (cause | 0x80000000) == 0;
    const code = cause & (~ @as(u32, 0x80000000));
    if (!sync and code == 5) {
        // stimer
        _ = io.kwriter.print("timer\n", .{}) catch {};
        stimer.set_timer_from_now(stimer_period) catch {
            // we can't work without stimer
            @panic("failed to set stimer");
        };
    } else {
        _ = std.debug.panic("cause: 0x{x}, val: 0x{x}, exception pc: 0x{x}", .{csr.read_csr("scause"), csr.read_csr("stval"), csr.read_csr("sepc")}) catch {};
    }
}

pub export fn kernel_main() void {
    @memset(bss_start[0..(bss_end - bss_start)], 0);
    _ = io.kwriter.print("Hello {d}\n", .{10}) catch {};

    csr.write_csr("stvec", @as(u32, @truncate(@intFromPtr(tvec_start))));
    csr.set_csr("sstatus", 2);
    csr.set_csr("sie", 32);
    csr.clear_csr("sip", 32);

    stimer.set_timer_from_now(stimer_period) catch {
        @panic("failed to set stimer\n");
    };
    
    var counter: u32 = 0;
    while (true) {
        counter +%= 1;
        for (0..10000000) |_| {

        }

        _ = io.kwriter.print("counter: {d}\n",.{counter}) catch {};
    }
}
