const io = @import("std").Io;
const ecall = @import("ecall.zig");

pub var kwriter: io.Writer = .{
    .vtable = &io.Writer.VTable {
        .drain = kdrain
    },
    .buffer = &.{}
};

fn print_single(ch: u8) io.Writer.Error!void {
    const result = ecall.ecall(1, 0, ch, 0, 0, 0, 0, 0);
    if (result.error_code != 0) {
        return io.Writer.Error.WriteFailed;
    }
}

fn print_string(str: []const u8) io.Writer.Error!usize {
    for (str) |ch| {
        try print_single(ch);
    }

    return str.len;
}

fn kdrain(w: *io.Writer, data: []const []const u8, splat: usize) io.Writer.Error!usize {
    // buffer first
    _ = try print_string(w.buffer[0..w.end]);

    // then data
    var acc_bytes: usize = 0;
    for (data, 0..data.len) |string, i| {
        if (i == data.len - 1) {
            // last element, print splat times, only acc one time
            for (0..splat) |_| {
                _ = try print_string(data[data.len-1]);
            }
            acc_bytes += data[i].len;
        } else {
            acc_bytes += try print_string(string);
        }
    }

    return acc_bytes;
}