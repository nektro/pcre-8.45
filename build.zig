const std = @import("std");
const deps = @import("./deps.zig");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    addExe(b, target, mode, "dftables");
    addExe(b, target, mode, "pcredemo");
    addExe(b, target, mode, "pcregrep");
    addExe(b, target, mode, "pcretest");
    // addExe(b, target, mode, "pcre_jit_test");
}

fn addExe(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode, comptime name: []const u8) void {
    const exe = b.addExecutable(name, null);
    exe.setTarget(target);
    exe.setBuildMode(mode);
    deps.addAllTo(exe);
    exe.addCSourceFile(name ++ ".c", &.{});
    exe.install();
}
