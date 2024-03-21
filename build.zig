const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const libmnl_dep = b.dependency("libmnl", .{});
    const config_h = b.addConfigHeader(
        .{
            .style = .{
                .autoconf = .{
                    .path = "include/config.h.in",
                },
            },
            .include_path = "config.h",
        },
        .{
            .HAVE_DLFCN_H = 1,
            .HAVE_INTTYPES_H = 1,
            .HAVE_STDINT_H = 1,
            .HAVE_STDIO_H = 1,
            .HAVE_STDLIB_H = 1,
            .HAVE_STRINGS_H = 1,
            .HAVE_STRING_H = 1,
            .HAVE_SYS_STAT_H = 1,
            .HAVE_SYS_TYPES_H = 1,
            .HAVE_UNISTD_H = 1,
            .HAVE_VISIBILITY_HIDDEN = 1,
            .LT_OBJDIR = ".libs/",
            .PACKAGE = "libmnl",
            .PACKAGE_BUGREPORT = "",
            .PACKAGE_NAME = "libmnl",
            .PACKAGE_STRING = "libmnl",
            .PACKAGE_TARNAME = "libmnl",
            .PACKAGE_URL = "",
            .PACKAGE_VERSION = "1.0.5",
            .STDC_HEADERS = 1,
            .VERSION = "1.0.5",
        },
    );
    const lib = b.addStaticLibrary(.{
        .name = "mnl",
        .target = target,
        .optimize = optimize,
    });
    lib.addConfigHeader(config_h);
    lib.linkLibC();
    lib.addCSourceFiles(.{
        .root = libmnl_dep.path("."),
        .files = &mnl_src,
        .flags = &.{},
    });
    lib.addIncludePath(.{ .path = "include" });
    lib.addIncludePath(libmnl_dep.path("include"));
    lib.installHeadersDirectoryOptions(.{
        .source_dir = libmnl_dep.path("include"),
        .install_dir = .header,
        .install_subdir = "",
        .include_extensions = &.{".h"},
    });
    b.installArtifact(lib);

    const mnl_mod = b.addModule("mnl", .{
        .link_libc = true,
        .root_source_file = .{ .path = "src/root.zig" },
        .target = target,
        .optimize = optimize,
    });
    mnl_mod.linkLibrary(lib);

    const lib_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/root.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib_unit_tests.root_module.linkLibrary(lib);
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}

const mnl_src = [_][]const u8{
    "src/socket.c",
    "src/callback.c",
    "src/nlmsg.c",
    "src/attr.c",
};
