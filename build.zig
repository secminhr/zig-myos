const std = @import("std");

pub fn build(b: *std.Build) !void {
    const debug = b.option(bool, "debug", "Debug with qemu") orelse false;

    const kernel = b.addExecutable(.{
        .name = "kernel",
        .root_module = b.createModule(.{
            .root_source_file = b.path("kernel.zig"),
            .target = b.resolveTargetQuery(.{
                .cpu_arch = .riscv32,
                .os_tag = .freestanding
            })
        }),
        .linkage = .static
    });
    kernel.entry = .{ .symbol_name = "boot" };
    
    kernel.setLinkerScript(b.path("kernel.ld"));
    b.installArtifact(kernel);

    var kernel_out_path_buf: [100]u8 = undefined;
    const kernel_out_path = try std.fmt.bufPrint(&kernel_out_path_buf, "{s}/bin/kernel", .{ b.install_path });

    const run_script = if (debug) "./script/debug.sh" else "./script/run.sh";
    const run_qemu = b.addSystemCommand(&[_][]const u8 { run_script, kernel_out_path });
    run_qemu.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run kernel with qemu-system-riscv32");
    run_step.dependOn(&run_qemu.step);
}
