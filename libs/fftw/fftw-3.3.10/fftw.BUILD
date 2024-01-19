
filegroup(name = "all", srcs = glob(["**"]), visibility = ["//visibility:public"])

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

cmake(
    name = "fftw3",
    generate_args = [
        "-G Ninja",
    ],
    lib_source = "@fftw3//:all",
    out_lib_dir = "lib",
    #out_include_dir = "fftw3/include",
    out_include_dir = "include",
    out_shared_libs = [
        "libfftw3.so",
    ],
    visibility = ["//visibility:public"],
)

