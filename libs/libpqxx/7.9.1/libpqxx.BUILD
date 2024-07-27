
load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)

cmake(
    name = "libpqxx",
    cache_entries = {
        "CMAKE_C_FLAGS": "-fPIC",
    },
    linkopts = ["-lpq"],
    lib_source = "@libpqxx//:all_srcs",
    out_static_libs = ["libpqxx.a"],
    visibility = [
        "//visibility:public",
    ]
)
