const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const copyFiles = b.addWriteFiles();
    _ = copyFiles.addCopyFile(.{ .path = "config.h.generic" }, "config.h");
    _ = copyFiles.addCopyFile(.{ .path = "pcre.h.generic" }, "pcre.h");
    const lib = b.addStaticLibrary(.{
        .name = b.fmt("pcre", .{}),
        .target = target,
        .optimize = optimize,
    });
    lib.addIncludePath(.{ .path = b.pathFromRoot(".") });
    lib.addIncludePath(copyFiles.getDirectory());
    lib.addIncludePath(std.Build.LazyPath{ .cwd_relative = "/usr/include" }); // temporary hack

    lib.addCSourceFiles(.{
        .flags = &[_][]const u8{
            "-Wno-implicit-function-declaration",
            "-DHAVE_CONFIG_H",
        },
        .files = &[_][]const u8{
            "pcre_byte_order.c",
            "pcre_chartables.c",
            "pcre_compile.c",
            "pcre_config.c",
            "pcre_dfa_exec.c",
            "pcre_exec.c",
            "pcre_fullinfo.c",
            "pcre_get.c",
            "pcre_globals.c",
            "pcre_jit_compile.c",
            "pcre_maketables.c",
            "pcre_newline.c",
            "pcre_ord2utf8.c",
            "pcre_printint.c",
            "pcre_refcount.c",
            "pcre_string_utils.c",
            "pcre_study.c",
            "pcre_tables.c",
            "pcre_ucd.c",
            "pcre_valid_utf8.c",
            "pcre_version.c",
            "pcre_xclass.c",
        },
    });
    b.installArtifact(lib);
}
