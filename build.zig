const std = @import("std");
const deps = @import("./deps.zig");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.option(std.builtin.Mode, "mode", "") orelse .Debug;

    addExe(b, target, mode, "dftables");
    addExe(b, target, mode, "pcredemo");
    addExe(b, target, mode, "pcregrep");
    addExe(b, target, mode, "pcretest");
    // addExe(b, target, mode, "pcre_jit_test");

    const test_step = b.step("test", "dummy test step to pass CI checks");
    _ = test_step;
}

fn addExe(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode, comptime name: []const u8) void {
    const exe = b.addExecutable(.{
        .name = name,
        .target = target,
        .optimize = mode,
    });
    deps.addAllTo(exe);
    exe.addCSourceFile(.{
        .file = .{ .path = name ++ ".c" },
        .flags = &.{
            "-DHAVE_CONFIG_H",
        },
    });
    b.installArtifact(exe);
}
