const uXLEN = u32;

const EcallRet = struct { error_code: uXLEN, value: uXLEN };
pub fn ecall(eid: uXLEN, fid: uXLEN, arg0: uXLEN, arg1: uXLEN, arg2: uXLEN, arg3: uXLEN, arg4: uXLEN, arg5: uXLEN) EcallRet {
    var error_code: uXLEN = 0;
    var value: uXLEN = 0;
    asm volatile (
        \\ecall
        : [error_code] "={a0}" (error_code),
          [value] "={a1}" (value),
        : [arg0] "{a0}" (arg0),
          [arg1] "{a1}" (arg1),
          [arg2] "{a2}" (arg2),
          [arg3] "{a3}" (arg3),
          [arg4] "{a4}" (arg4),
          [arg5] "{a5}" (arg5),
          [fid] "{a6}" (fid),
          [eid] "{a7}" (eid),
        : .{ .memory = true }
    );

    return .{
        .error_code = error_code,
        .value = value
    };
}