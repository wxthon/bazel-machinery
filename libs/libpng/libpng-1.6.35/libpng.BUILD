load("@bazel_machinery//tools/autoconf:autoconf_config.bzl",
	 "autoconf_config", "autoconf_standard_defines")

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "libpng",
    hdrs = [
        "pngconf.h",
        "pngdebug.h",
        "png.h",
        "pnginfo.h",
        "pngpriv.h",
        "pngstruct.h",
        "pnglibconf.h",
    ],
    include_prefix = "libpng",
    srcs = [
        "pngconf.h",
        "pngdebug.h",
        "png.h",
        "pnginfo.h",
        "pngpriv.h",
        "pngstruct.h",
        "pnglibconf.h",
        "private/config.h",
        "png.c",
        "pngerror.c",
        "pngget.c",
        "pngmem.c",
        "pngpread.c",
        "pngread.c",
        "pngrio.c",
        "pngrtran.c",
        "pngrutil.c",
        "pngset.c",
        "pngtrans.c",
        "pngwio.c",
        "pngwrite.c",
        "pngwtran.c",
        "pngwutil.c",
    ] + select({
        "@bazel_machinery//conditions:arm" : [
            "arm/arm_init.c",
            "arm/filter_neon.S",
            "arm/filter_neon_intrinsics.c",
        ],
        "@bazel_machinery//conditions:aarch64" : [
            "arm/arm_init.c",
            "arm/filter_neon.S",
            "arm/filter_neon_intrinsics.c",
        ],
        "@bazel_machinery//conditions:x86_64" : [
            "intel/filter_sse2_intrinsics.c",
            "intel/intel_init.c",
        ],
    }),
    includes = ["."],
    copts = [
        "-DHAVE_CONFIG_H",
        "-I$(GENDIR)/external/libpng/private",
        "-w",
    ],
    deps = ["@zlib"],
)

autoconf_config(
    name = "private/config.h",
    src = "config.h.in",
    package = "libpng",
    version = "1.6.35",
    defines = autoconf_standard_defines + select({
        "@bazel_machinery//conditions:arm" : [
            "PNG_ARM_NEON_OPT=0",
        ],
        "@bazel_machinery//conditions:aarch64" : [
            "PNG_ARM_NEON_OPT=1",
        ],
        "@bazel_machinery//conditions:x86_64" : [
            "PNG_INTEL_SSE_OPT",
        ],
    }),
)

genrule(
    name = "pnglibconf",
    srcs = ["scripts/pnglibconf.h.prebuilt"],
    outs = ["pnglibconf.h"],
    cmd = "cp $< $@",
)
