# Description
#    lzma is a general purpose data compression library https://tukaani.org/xz/
#    Public Domain

load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load("@bazel_skylib//lib:selects.bzl", "selects")

# Hopefully, the need for these OSxCPU config_setting()s will be obviated by a fix to https://github.com/bazelbuild/platforms/issues/36

config_setting(
    name = "osx_arm64",
    constraint_values = [
        "@platforms//os:osx",
        "@platforms//cpu:aarch64",
    ],
)

config_setting(
    name = "osx_x86_64",
    constraint_values = [
        "@platforms//os:osx",
        "@platforms//cpu:x86_64",
    ],
)

copy_file(
    name = "copy_config",
    src = selects.with_or({
        "@platforms//os:android": "@bazel_machinery//libs/xz/xz-5.4.4:config.lzma-android.h",
        "@platforms//os:linux": "@bazel_machinery//libs/xz/xz-5.4.4:config.lzma-linux.h",
        ":osx_arm64": "@bazel_machinery//libs/xz/xz-5.4.4:config.lzma-osx-arm64.h",
        ":osx_x86_64": "@bazel_machinery//libs/xz/xz-5.4.4:config.lzma-osx-x86_64.h",
        ("@platforms//os:ios", "@platforms//os:watchos", "@platforms//os:tvos"): "apple_config",
        "@platforms//os:windows": "@bazel_machinery//libs/xz/xz-5.4.4:config.lzma-windows.h",
    }),
    out = "src/liblzma/api/config.h",  # minimize the number of exported include paths
)

# Configuration is the same across iOS, watchOS, and tvOS
alias(
    name = "apple_config",
    actual = select({
        "@platforms//cpu:arm64": "@bazel_machinery//libs/xz/xz-5.4.4:config.lzma-ios-arm64.h",
        "@platforms//cpu:armv7": "@bazel_machinery//libs/xz/xz-5.4.4:config.lzma-ios-armv7.h",
        "@platforms//cpu:x86_64": "@bazel_machinery//libs/xz/xz-5.4.4:config.lzma-osx-x86_64.h",  # Configuration same as macOS
        "@platforms//cpu:x86_32": "@bazel_machinery//libs/xz/xz-5.4.4:config.lzma-ios-i386.h",
    }),
)

# Note: lzma is bundled with Apple platforms, but sadly, not considered public API because its header is not exposed. lzma is not bundled on Android.

cc_library(
    name = "lzma",
    srcs = [
        "src/common/tuklib_cpucores.c",
        "src/common/tuklib_physmem.c",
        "src/liblzma/api/config.h",  # Generated, so missed by glob.
    ] + glob(
        [
            "src/**/*.h",
            "src/liblzma/**/*.c",
        ],
        exclude = [
            "src/liblzma/check/crc*_small.c",
            "src/liblzma/**/*_tablegen.c",
        ],
    ),
    hdrs = glob(["src/liblzma/api/**/*.h"]),
    copts = select({
        "@platforms//os:windows": [],
        "//conditions:default": ["-std=c99"],
    }) + [
        # Replace with local_includes if it's ever added https://github.com/bazelbuild/bazel/issues/16472
        "-I external/org_lzma_lzma/src/common",
        "-I external/org_lzma_lzma/src/liblzma",
        "-I external/org_lzma_lzma/src/liblzma/api",
        "-I external/org_lzma_lzma/src/liblzma/common",
        "-I external/org_lzma_lzma/src/liblzma/check",
        "-I external/org_lzma_lzma/src/liblzma/delta",
        "-I external/org_lzma_lzma/src/liblzma/lz",
        "-I external/org_lzma_lzma/src/liblzma/lzma",
        "-I external/org_lzma_lzma/src/liblzma/rangecoder",
        "-I external/org_lzma_lzma/src/liblzma/simple",
    ],
    defines = select({
        "@platforms//os:windows": ["LZMA_API_STATIC"],
        "//conditions:default": [],
    }),
    includes = [
        "src/liblzma/api",
    ],
    linkopts = select({
        "@platforms//os:android": [],
        "//conditions:default": ["-lpthread"],
    }),
    linkstatic = select({
        "@platforms//os:windows": True,
        "//conditions:default": False,
    }),
    local_defines = [
        "HAVE_CONFIG_H",
    ],
    visibility = ["//visibility:public"],
)
