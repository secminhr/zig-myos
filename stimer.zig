const csr = @import("csr.zig");
const ecall = @import("ecall.zig");
const math = @import("std").math;

pub fn read_time() u64 {
    const lower: u64 = csr.read_csr("time");
    const higher: u64 = csr.read_csr("timeh");
    return (higher << 32) | lower;
}

const TimerError = error {
    EcallFailed,
    TimeOverflow
};

pub fn set_timer(future_time: u64) TimerError!void {
    const ret = ecall.ecall(0x54494D45, 0, @truncate(future_time) , @truncate(future_time / 0x100000000), 0, 0, 0, 0);
    if (ret.error_code != 0) {
        return TimerError.EcallFailed;
    }
}

pub fn set_timer_from_now(advance: u64) TimerError!void {
    const time = math.add(u64, read_time(), advance) catch {
        @panic("time overflow");
    };
    try set_timer(time);
}

