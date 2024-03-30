cc_library(
	name = "HighFive",
    hdrs = glob([
        "include/highfive/*.hpp",
        "include/highfive/**/*.hpp",
    ]),
    includes = [
        "include",
        "include/highfive",
    ],
    copts = [
    ],
    linkopts = [
        "-lhdf5_serial",
    ],
    strip_include_prefix = "include",
    visibility = ["//visibility:public"],
)
