const fmt = @import("std").fmt;

fn int_to_string(value: comptime_int, comptime buf: []u8) ![]u8 {
    return fmt.bufPrint(buf, "{d}", .{ value });
}

fn csr_imm_instr(comptime instr: []const u8, comptime csr: []const u8, comptime value: u32) []const u8 {
    if (value < 0 or value >= 32) {
        @compileError("imm for csr instructions should between 0 to 31");
    }

    comptime var imm_str_buf: [2]u8 = @splat(0);
    const imm_str = comptime int_to_string(value, &imm_str_buf) catch {
        @compileError("failed convert value to string");
    };
    return instr ++ " " ++ csr ++ ", " ++ imm_str;
}

pub fn write_csr(comptime csr: []const u8, value: anytype) void {
    if (@typeInfo(@TypeOf(value)) == .comptime_int and 0 <= value and value < 32) {
        asm volatile (csr_imm_instr("csrwi", csr, value));
    } else {
        asm volatile (
            "csrw " ++ csr ++ ", %[value]"
            :
            : [value] "r" (value)
        );
    }
}

pub fn read_csr(comptime csr: []const u8) u32 {
    return asm volatile (
        "csrr %[ret], " ++ csr
        : [ret] "=r" (-> u32)
    );
}

pub inline fn set_csr(comptime csr: []const u8, value: anytype) void {
    if (@typeInfo(@TypeOf(value)) == .comptime_int and 0 <= value and value < 32) {
        asm volatile (csr_imm_instr("csrsi", csr, value));
    } else {
        asm volatile (
            "csrs " ++ csr ++ ", %[value]"
            : 
            : [value] "r" (value)
        );
    }
}

pub inline fn clear_csr(comptime csr: []const u8, value: anytype) void {
    if (@typeInfo(@TypeOf(value)) == .comptime_int and 0 <= value and value < 32) {
        asm volatile (csr_imm_instr("csrci", csr, value));
    } else {
        asm volatile (
            "csrc " ++ csr ++ ", %[value]"
            : 
            : [value] "r" (value)
        );
    }
}