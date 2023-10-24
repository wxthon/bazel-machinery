load("@bazel_machinery//libs/ffmpeg/ffmpeg-3.4.2:template_file.bzl", "template_file")
load("@bazel_machinery//libs/ffmpeg/ffmpeg-3.4.2:generate_file.bzl", "generate_file")
load("@bazel_machinery//libs/ffmpeg/ffmpeg-3.4.2:config.bzl", "flatten_config")
load("@bazel_machinery//libs/nasm/nasm-2.13.03:nasm.bzl", "nasm_objects")

# TODO(jpieper): This could be refactored even more for reduced
# redundancy.  Particularly, we could have internal cc_library rules
# for the compilation of each module that exported every header, then
# the external ones which reference the .so and only the public
# headers.

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "ffmpeg",
    deps = [
        ":swscale_lib",
        ":swresample_lib",
        ":avformat_lib",
        ":avfilter_lib",
        ":avdevice_lib",
        ":avcodec_lib",
    ],
)

cc_library(
    name = "internal_headers",
    hdrs = glob(["**/*.h"]) + [
        "private/avversion.h",
        "private/config.h",
        "libavutil/avconfig.h",
        "libavutil/ffversion.h",
    ],
    textual_hdrs = glob(["**/*.c", "**/*.S", "**/*.asm", "**/*.inc"]),
    includes = ["."],
    visibility = ["//visibility:private"],
)

COMMON_COPTS = [
    "-I$(GENDIR)/external/ffmpeg/private",
    "-Iexternal/ffmpeg/private",
    "-DHAVE_AV_CONFIG_H",
    "-DPIC",

    "-Wno-deprecated",
    "-Wno-unused-function",
    "-Wno-pointer-sign",
    "-Wno-incompatible-pointer-types",
    "-Wno-parentheses",
    "-Wno-switch",
    "-Wno-unused-variable",
] + select({
    "@bazel_machinery//conditions:gcc" : [
        "-Wno-discarded-qualifiers",
    ],
    "@bazel_machinery//conditions:clang" : [
        "-Wno-shift-negative-value",
        "-Wno-incompatible-pointer-types-discards-qualifiers",
        "-Wno-constant-conversion",
        "-Wno-unused-const-variable",
        "-Wno-#warnings",
        "-Wno-sometimes-uninitialized",
        "-Wno-logical-op-parentheses",
        "-Wno-implicit-int-float-conversion",
        "-Wno-string-plus-int",
        "-Wno-absolute-value",
        "-Wno-deprecated-declarations",
        "-Wno-bool-operation",
    ],
    "//conditions:default" : [],
})

BIN_LINKOPTS = [
    "-Wl,-Bsymbolic",
    "-ldl",
] + select({
    "@bazel_machinery//conditions:clang" : [
        "-Wl,-znotext",
    ],
    "//conditions:default" : [],
})

cc_library(
    name = "avutil_lib",
    hdrs = @AVUTIL_HEADERS@ + [
        "libavutil/avconfig.h",
        "libavutil/ffversion.h",
    ],
    srcs = [":libavutil.so"],
    includes = ["."],
)

cc_library(
    name = "compat",
    hdrs = [
        "compat/va_copy.h",
        "compat/nvenc/nvEncodeAPI.h",
        "compat/cuda/dynlink_loader.h",
        "compat/cuda/dynlink_cuda.h",
        "compat/cuda/dynlink_nvcuvid.h",
        "compat/cuda/dynlink_cuviddec.h",
        "compat/w32dlfcn.h",
    ],
)

cc_binary(
    name = "libavutil.so",
    linkshared = True,
    srcs = @AVUTIL_SOURCES@ +select({
        "@bazel_machinery//conditions:arm" : @AVUTIL_ARM_SOURCES@,
        "@bazel_machinery//conditions:aarch64" : @AVUTIL_AARCH64_SOURCES@,
        "@bazel_machinery//conditions:x86_64" : (@AVUTIL_X86_SOURCES@ + [":avutil_x86asm"]),
    }),
    copts = COMMON_COPTS,
    linkopts = BIN_LINKOPTS + [
        "-Wl,--version-script,$(location libavutil/libavutil.lds)",
    ],
    deps = [
        ":internal_headers",
        ":libavutil/libavutil.lds",
    ],
)

generate_file(
    name = "libavutil/avconfig.h",
    content = """
/* Generated by ffconf */
#ifndef AVUTIL_AVCONFIG_H
#define AVUTIL_AVCONFIG_H
#define AV_HAVE_BIGENDIAN 0
#define AV_HAVE_FAST_UNALIGNED 0
#endif /* AVUTIL_AVCONFIG_H */
    """,
)

cc_library(
    name = "swscale_lib",
    hdrs = @SWSCALE_HEADERS@,
    srcs = [":libswscale.so"],
    includes = ["."],
    deps = [":avutil_lib"],
)

cc_binary(
    name = "libswscale.so",
    linkshared = True,
    srcs = @SWSCALE_SOURCES@ + select({
        "@bazel_machinery//conditions:arm" : @SWSCALE_ARM_SOURCES@,
        "@bazel_machinery//conditions:aarch64" : @SWSCALE_AARCH64_SOURCES@,
        "@bazel_machinery//conditions:x86_64" : (@SWSCALE_X86_SOURCES@ + [":swscale_x86asm"]),
    }),
    copts = COMMON_COPTS,
    deps = [
        ":internal_headers",
        ":avutil_lib",
        ":libswscale/libswscale.lds",
    ],
    linkopts = BIN_LINKOPTS + [
        "-Wl,--version-script,$(location libswscale/libswscale.lds)",
    ],
)

cc_library(
    name = "swresample_lib",
    hdrs = @SWRESAMPLE_HEADERS@,
    srcs = [":libswresample.so"],
    includes = ["."],
    deps = [":avutil_lib"],
)

cc_binary(
    name = "libswresample.so",
    linkshared = True,
    srcs = @SWRESAMPLE_SOURCES@ + select({
        "@bazel_machinery//conditions:arm" : @SWRESAMPLE_ARM_SOURCES@,
        "@bazel_machinery//conditions:aarch64" : @SWRESAMPLE_AARCH64_SOURCES@,
        "@bazel_machinery//conditions:x86_64" : (@SWRESAMPLE_X86_SOURCES@ + [":swresample_x86asm"]),
    }),
    copts = COMMON_COPTS,
    deps = [
        ":internal_headers",
        ":avutil_lib",
        ":libswresample/libswresample.lds",
    ],
    linkopts = BIN_LINKOPTS + [
        "-Wl,--version-script,$(location libswresample/libswresample.lds)",
    ],
)

cc_library(
    name = "avcodec_lib",
    hdrs = @AVCODEC_HEADERS@,
    srcs = [":libavcodec.so"],
    includes = ["."],
    deps = [":avutil_lib", ":swresample_lib"],
)

cc_binary(
    name = "libavcodec.so",
    linkshared = True,
    srcs = @AVCODEC_SOURCES@ + ["libavcodec/" + x for x in [
        # HAVE_THREADS
        "pthread.c",
        "pthread_slice.c",
        "pthread_frame.c",
    ]] + select({
        "@bazel_machinery//conditions:arm" : @AVCODEC_ARM_SOURCES@,
        "@bazel_machinery//conditions:aarch64" : @AVCODEC_AARCH64_SOURCES@,
        "@bazel_machinery//conditions:x86_64" : (@AVCODEC_X86_SOURCES@ + [":avcodec_x86asm"]),
    }),
    copts = COMMON_COPTS + [
        "-Iexternal/ffmpeg/libavcodec/",
    ],
    deps = [
        ":internal_headers",
        ":avutil_lib",
        ":swresample_lib",
        ":libavcodec/libavcodec.lds",
        "@zlib",
    ],
    linkopts = BIN_LINKOPTS + [
        "-Wl,--version-script,$(location libavcodec/libavcodec.lds)",
    ],
)

cc_library(
    name = "avformat_lib",
    hdrs = @AVFORMAT_HEADERS@,
    srcs = [":libavformat.so"],
    includes = ["."],
    deps = [":avutil_lib", ":avcodec_lib"],
)

cc_binary(
    name = "libavformat.so",
    linkshared = True,
    srcs = @AVFORMAT_SOURCES@ + select({
        "@bazel_machinery//conditions:arm" : @AVFORMAT_ARM_SOURCES@,
        "@bazel_machinery//conditions:aarch64" : @AVFORMAT_AARCH64_SOURCES@,
        "@bazel_machinery//conditions:x86_64" : @AVFORMAT_X86_SOURCES@,
    }),
    copts = COMMON_COPTS + [
        "-Iexternal/ffmpeg/libavcodec",
    ],
    deps = [
        ":internal_headers",
        ":avutil_lib",
        ":avcodec_lib",
        ":libavformat/libavformat.lds",
        "@bzip2",
        "@zlib",
    ],
    linkopts = BIN_LINKOPTS + [
        "-Wl,--version-script,$(location libavformat/libavformat.lds)",
    ],
)

cc_library(
    name = "avfilter_lib",
    hdrs = @AVFILTER_HEADERS@,
    srcs = [":libavfilter.so"],
    includes = ["."],
    deps = [":avutil_lib", ":avcodec_lib", ":avformat_lib", ":swscale_lib"],
)

cc_binary(
    name = "libavfilter.so",
    linkshared = True,
    srcs = @AVFILTER_SOURCES@ + ["libavfilter/" + x for x in [
        "pthread.c",
    ]] + select({
        "@bazel_machinery//conditions:arm" : @AVFILTER_ARM_SOURCES@,
        "@bazel_machinery//conditions:aarch64" : @AVFILTER_AARCH64_SOURCES@,
        "@bazel_machinery//conditions:x86_64" : (@AVFILTER_X86_SOURCES@ + [":avfilter_x86asm"]),
    }),
    copts = COMMON_COPTS + [
        "-Iexternal/ffmpeg/libavfilter",
    ],
    deps = [
        ":internal_headers",
        ":avutil_lib",
        ":avcodec_lib",
        ":avformat_lib",
        ":swscale_lib",
        ":libavfilter/libavfilter.lds",
    ],
    linkopts = BIN_LINKOPTS + [
        "-Wl,--version-script,$(location libavfilter/libavfilter.lds)",
    ],
)

cc_library(
    name = "avdevice_lib",
    hdrs = @AVDEVICE_HEADERS@,
    srcs = [":libavdevice.so"],
    includes = ["."],
    deps = [":avutil_lib", ":avcodec_lib", ":avformat_lib", ":avfilter_lib"],
)

cc_binary(
    name = "libavdevice.so",
    linkshared = True,
    srcs = @AVDEVICE_SOURCES@,
    copts = COMMON_COPTS,
    deps = [
        ":internal_headers",
        ":avutil_lib",
        ":avcodec_lib",
        ":avformat_lib",
        ":avfilter_lib",
        ":libavdevice/libavdevice.lds",
    ],
    linkopts = BIN_LINKOPTS + [
        "-Wl,--version-script,$(location libavdevice/libavdevice.lds)",
    ],
)

[nasm_objects(
    name = module + "_x86asm",
    srcs = select({
        "@bazel_machinery//conditions:x86_64" : asm_files,
        "//conditions:default" : [],
    }),
    textual_hdrs = [
        "libavutil/x86/x86util.asm",
        "libavutil/x86/x86inc.asm",
        "libavcodec/x86/vp9itxfm_template.asm",
        "libavcodec/x86/simple_idct10_template.asm",
        "libavcodec/x86/vp9itxfm_16bpp.asm",
    ],
    force_includes = [
        "private/config.asm",
    ],
    extra_args = [
        "-f", "elf64",
        "-g",
        "-DPIC",
        "-F", "dwarf",
        "-Iexternal/ffmpeg/",
        "-Iexternal/ffmpeg/lib{}/x86/".format(module),
    ],
) for module, asm_files in [
    ("swresample", @SWRESAMPLE_X86_X86ASM@),
    ("swscale", @SWSCALE_X86_X86ASM@),
    ("avutil", @AVUTIL_X86_X86ASM@),
    ("avcodec", @AVCODEC_X86_X86ASM@),
    ("avformat", @AVFORMAT_X86_X86ASM@),
    ("avfilter", @AVFILTER_X86_X86ASM@),
    ("avdevice", @AVDEVICE_X86_X86ASM@),
]]

generate_file(
    name = "private/avversion.h",
    content = """
#define LIBAV_VERSION "12.3"
    """,
)

[genrule(
    name = "{x}_linkerscript".format(x=module),
    outs = ["lib{x}/lib{x}.lds".format(x=module)],
    srcs = ["lib{x}/lib{x}.v".format(x=module)],
    cmd = "cp $< $@",
) for module in @MODULES@]

template_file(
    name = "private/config.asm",
    src = "private/config.h",
    substitutions = {
        "#define" : "%define",
        "#endif" : "",
        "#ifndef FFMPEG_CONFIG_H" : "",
        "#define FFMPEG_CONFIG_H" : "",
    },
)

X86_OPTS = [
    "MMX",
    "SSE",
    "SSE2",
    "SSE3",
    "SSE4",
    "SSE42",
    "AVX",
    "AVX2",
]

ARM_OPTS = [
    "NEON",
    "ARMV6",
    "ARMV6T2",
]

AARCH64_OPTS = [
    "NEON",
    "VFP",
]

template_file(
    name = "private/config.h",
    src = "private/config.h.in",
    substitution_list = select({
        "@bazel_machinery//conditions:arm" : ([
            "#define ARCH_ARM 0=#define ARCH_ARM 1",
        ] + [
            "#define HAVE_{x} 0=#define HAVE_{x} 1".format(x=x)
            for x in ARM_OPTS
        ] + [
            "#define HAVE_{x}_EXTERNAL 0=#define HAVE_{x}_EXTERNAL 1".format(x=x)
            for x in ARM_OPTS
        ]),
        "@bazel_machinery//conditions:aarch64" : ([
            "#define ARCH_AARCH64 0=#define ARCH_AARCH64 1",
        ] + [
            "#define HAVE_{x} 0=#define HAVE_{x} 1".format(x=x)
            for x in AARCH64_OPTS
        ] + [
            "#define HAVE_{x}_EXTERNAL 0=#define HAVE_{x}_EXTERNAL 1".format(x=x)
            for x in AARCH64_OPTS
        ]),
        "@bazel_machinery//conditions:x86_64" : ([
            "#define ARCH_X86 0=#define ARCH_X86 1",
            "#define ARCH_X86_64 0=#define ARCH_X86_64 1",
            "#define HAVE_X86ASM 0=#define HAVE_X86ASM 1",
        ] + [
            "#define HAVE_{x} 0=#define HAVE_{x} 1".format(x=x)
            for x in X86_OPTS
        ] + [
            "#define HAVE_{x}_EXTERNAL 0=#define HAVE_{x}_EXTERNAL 1".format(x=x)
            for x in X86_OPTS
        ]),
    }),
)


generate_file(
    name = "libavutil/ffversion.h",
    content = """
/* Automatically generated by version.sh, do not manually edit! */
#ifndef AVUTIL_FFVERSION_H
#define AVUTIL_FFVERSION_H
#define FFMPEG_VERSION "3.4.2"
#endif /* AVUTIL_FFVERSION_H */
""")