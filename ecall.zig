const iXLEN = i32;

const EcallRet = struct { error_code: iXLEN, value: iXLEN };
pub fn ecall(eid: iXLEN, fid: iXLEN, arg0: iXLEN, arg1: iXLEN, arg2: iXLEN, arg3: iXLEN, arg4: iXLEN, arg5: iXLEN) EcallRet {
    var error_code: iXLEN = 0;
    var value: iXLEN = 0;
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