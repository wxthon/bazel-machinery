
load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

filegroup(
    name = "srcs",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)

cmake(
    name = "easy_profiler",
    generate_args = [
        "-DBUILD_SHARED_LIBS=OFF",
        "-DEASY_PROFILER_NO_GUI=ON",
        #"-DEASY_OPTION_LOG=ON",
        #"-DEASY_OPTION_LISTEN=ON",
        #"-DBUILD_WITH_EASY_PROFILER=1",
    ],
    lib_source = ":srcs",
    out_static_libs = ["libeasy_profiler.a"],
    #out_shared_libs = ["libeasy_profiler.so"],
    out_include_dir = "include",
    visibility = [
        "//visibility:public",
    ],
    alwayslink = True,
)
