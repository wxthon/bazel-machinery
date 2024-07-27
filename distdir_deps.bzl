

DIST_DEPS = {
    "rules_python": {
        "archive": "rules_python-0.1.0.tar.gz",
        "sha256": "b6d46438523a3ec0f3cead544190ee13223a52f6a6765a29eae7b7cc24cc83a0",
        "urls": [
            "https://github.com/bazelbuild/rules_python/releases/download/0.1.0/rules_python-0.1.0.tar.gz"
        ],
        "strip_prefix": "",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "rules_pkg": {
        "archive": "rules_pkg-0.7.0.tar.gz",
        "sha256": "8a298e832762eda1830597d64fe7db58178aa84cd5926d76d5b744d6558941c2",
        "urls": [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.7.0/rules_pkg-0.7.0.tar.gz",
            "https://github.com/bazelbuild/rules_pkg/releases/download/0.7.0/rules_pkg-0.7.0.tar.gz",
        ],
        "strip_prefix": "",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "bazel_skylib": {
        "archive": "bazel-skylib-1.4.2.tar.gz",
        "sha256": "66ffd9315665bfaafc96b52278f57c7e2dd09f5ede279ea6d39b2be471e7e3aa",
        "urls": [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.2/bazel-skylib-1.4.2.tar.gz",
        ],
        "strip_prefix": "",
        "used_in": [
            "additional_distfiles",
        ],        
    },
    "zlib": {
        "archive": "zlib-1.3.tar.gz",
        "sha256": "ff0ba4c292013dbc27530b3a81e1f9a813cd39de01ca5e0f8bf355702efa593e",
        "urls": [
            "https://github.com/madler/zlib/releases/download/v1.3/zlib-1.3.tar.gz",
        ],
        "strip_prefix": "zlib-1.3",
        "build_file": "@bazel_machinery//libs/zlib/zlib-1.3:zlib.BUILD",
        "used_in": [
            "additional_distfiles",
        ],
    },
    "org_bzip_bzip2": {
        "archive": "bzip2-1.0.8.tar.gz",
        "build_file": "@bazel_machinery//libs/bzip2/bzip2-1.0.8:bzip2.BUILD",
        "sha256": "ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269",
        "strip_prefix": "bzip2-1.0.8",
        "urls": [
            "https://mirror.bazel.build/sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz",
            "https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz",
        ],
        "used_in": [
            "additional_distfiles",
        ]
    },
    "org_lzma_lzma": {
        "archive": "xz-5.4.4.tar.gz",
        "build_file": "@bazel_machinery//libs/xz/xz-5.4.4:lzma.BUILD",
        "urls": [
            "https://github.com/tukaani-project/xz/releases/download/v5.4.4/xz-5.4.4.tar.gz",
        ],
        "sha256": "aae39544e254cfd27e942d35a048d592959bd7a79f9a624afb0498bb5613bdf8",
        "strip_prefix": "xz-5.4.4",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "com_github_facebook_zstd": {
        "archive": "zstd-1.5.5.tar.gz",
        "build_file": "@bazel_machinery//libs/zstd/zstd-1.5.5:zstd.BUILD",
        "urls": [
            "https://github.com/facebook/zstd/releases/download/v1.5.5/zstd-1.5.5.tar.gz",
        ],
        "sha256": "9c4396cc829cfae319a6e2615202e82aad41372073482fce286fac78646d3ee4",
        "strip_prefix": "zstd-1.5.5",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "boringssl": {
        "distdir": "boringssl",
        "archive": "boringssl-207f9c208a08ca6e931b30b5b89a2e0f02c5ee41.tar.gz",
        "urls": [
            "https://github.com/hedronvision/boringssl/archive/207f9c208a08ca6e931b30b5b89a2e0f02c5ee41.tar.gz",
        ],
        "sha256": "e2d8e5ed850a917e74a249d3bef3356c7e4c40622457d5a34871b73a18c92e3b",
        "strip_prefix": "boringssl-207f9c208a08ca6e931b30b5b89a2e0f02c5ee41",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "boost": {
	    "archive": "boost-1.83.0.tar.xz",
        "sha256": "c5a0688e1f0c05f354bbd0b32244d36085d9ffc9f932e8a18983a9908096f614",
	    "urls": [
		    "https://github.com/boostorg/boost/releases/download/boost-1.83.0/boost-1.83.0.tar.xz",
	    ],
        "strip_prefix": "boost-1.83.0",
        "build_file": "@bazel_machinery//libs/boost/boost-1.83.0:boost.BUILD",
        "patch_cmds": ["rm -f doc/pdf/BUILD"],
        "patch_cmds_win": ["Remove-Item -Force doc/pdf/BUILD"],
        "used_in": [
            "additional_distfiles",
        ]
    },
    "nasm": {
        "archive": "nasm-2.13.03.tar.xz",
        "urls": [
            "http://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.xz",
            "https://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.xz",
        ],
        "sha256": "812ecfb0dcbc5bd409aaa8f61c7de94c5b8752a7b00c632883d15b2ed6452573",
	    "strip_prefix": "nasm-2.13.03",
        "build_file": "@bazel_machinery//libs/nasm/nasm-2.13.03:nasm.BUILD",
        "patch_cmds": [
            "./autogen.sh",
            "./configure",
		    "make perlreq",
        ],
        "used_in": [
            "additional_distfiles",
        ]
    },
    "ffmpeg": {
        "archive": "ffmpeg-3.4.2.tar.xz",
        "urls": [
            "https://ffmpeg.org/releases/ffmpeg-3.4.2.tar.xz"
        ],
        "sha256": "2b92e9578ef8b3e49eeab229e69305f5f4cbc1fdaa22e927fc7fca18acccd740",
        "strip_prefix": "ffmpeg-3.4.2",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "yaml-cpp": {
        "distdir": "yaml-cpp",
        "archive": "0.8.0.tar.gz",
        "urls": [
            "https://github.com/jbeder/yaml-cpp/archive/refs/tags/0.8.0.tar.gz",
        ],
        "sha256": "fbe74bbdcee21d656715688706da3c8becfd946d92cd44705cc6098bb23b3a16",
        "strip_prefix": "yaml-cpp-0.8.0",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "com_github_gflags_gflags": {
        "distdir": "gflags",
        "archive": "v2.2.2.tar.gz",
        "urls": [
            "https://github.com/gflags/gflags/archive/refs/tags/v2.2.2.tar.gz",
        ],
        "sha256": "34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf",
        "strip_prefix": "gflags-2.2.2",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "com_github_google_glog": {
        "distdir": "glog",
        "archive": "v0.6.0.tar.gz",
        "urls": [
            "https://github.com/google/glog/archive/refs/tags/v0.6.0.tar.gz",
        ],
        "sha256": "8a83bf982f37bb70825df71a9709fa90ea9f4447fb3c099e1d720a439d88bad6",
        "strip_prefix": "glog-0.6.0",
        "build_file": "@bazel_machinery//libs/glog/glog-0.6.0:glog.BUILD",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "cmake": {
        "archive": "cmake-3.22.2-linux-x86_64.tar.gz",
        "urls": [
            "https://github.com/Kitware/CMake/releases/download/v3.22.2/cmake-3.22.2-linux-x86_64.tar.gz",
        ],
        "sha256": "38b3befdee8fd2bac06954e2a77cb3072e6833c69d8cc013c0a3b26f1cfdfe37",
        "strip_prefix": "",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "rules_foreign_cc": {
        "distdir": "rules_foreign_cc",
        "archive": "0.8.0.tar.gz",
        "urls": [
            "https://github.com/bazelbuild/rules_foreign_cc/archive/0.8.0.tar.gz",
        ],
        "sha256": "6041f1374ff32ba711564374ad8e007aef77f71561a7ce784123b9b4b88614fc",
        "strip_prefix": "rules_foreign_cc-0.8.0",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "leveldb": {
        "distdir": "leveldb",
        "archive": "1.23.zip",
        "build_file": "@bazel_machinery//libs/leveldb/leveldb-1.23:leveldb.BUILD",
        "strip_prefix": "leveldb-1.23",
        "urls": [
            "https://github.com/google/leveldb/archive/refs/tags/1.23.zip",
	    ],
	    "workspace_file_content": "",
        "sha256": "a6fa7eebd11de709c46bf1501600ed98bf95439d6967963606cc964931ce906f",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "com_github_grpc_grpc": {
        "distdir": "grpc",
        "archive": "v1.59.4.tar.gz",
        "urls": [
            "https://github.com/grpc/grpc/archive/refs/tags/v1.59.4.tar.gz",
        ],
        "strip_prefix": "grpc-1.59.4",
        "sha256": "6edc67c2ad200c5b618c421f6e8c1b734a4aa3e741975e683491da03390ebf63",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "eigen": {
        "archive": "eigen-3.4.0.tar.gz",
        "urls": [
            "https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz",
        ],
        "sha256": "8586084f71f9bde545ee7fa6d00288b264a2b7ac3607b974e54d13e7162c1c72",
        "strip_prefix": "eigen-3.4.0",
        "build_file": "@bazel_machinery//libs/eigen/eigen-3.4.0:eigen.BUILD",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "libpng": {
        "archive": "libpng-1.6.35.tar.xz",
        "urls": [
            "http://prdownloads.sourceforge.net/libpng/libpng-1.6.35.tar.xz?download",
        ],
        "sha256": "23912ec8c9584917ed9b09c5023465d71709dce089be503c7867fec68a93bcd7",
        "strip_prefix": "libpng-1.6.35",
        "build_file": "@bazel_machinery//libs/libpng/libpng-1.6.35:libpng.BUILD",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "libjpeg": {
        "archive": "jpegsrc.v6b.tar.gz",
        "urls": [
            "https://downloads.sourceforge.net/project/libjpeg/libjpeg/6b/jpegsrc.v6b.tar.gz",
        ],
        "sha256": "75c3ec241e9996504fe02a9ed4d12f16b74ade713972f3db9e65ce95cd27e35d",
        "strip_prefix": "jpeg-6b",
        "build_file": "@bazel_machinery//libs/libjpeg/libjpeg-v6b:libjpeg.BUILD",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "opencv": {
        "distdir": "opencv",
        "archive": "3.4.2.tar.gz",
        "urls": [
            "https://github.com/opencv/opencv/archive/3.4.2.tar.gz",
        ],
        "sha256": "81dbd5e7e9f8a4c936b94629bf4765745942a1d634ae38ec08bc57b73b28ffc5",
        "strip_prefix": "opencv-3.4.2",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "opencv_contrib": {
        "distdir": "opencv_contrib",
        "archive": "3.4.2.tar.gz",
        "urls": [
            "https://github.com/opencv/opencv_contrib/archive/3.4.2.tar.gz",
        ],
        "sha256": "45a52764ebd2558fa0b7fd8dc47379b37dd0956d912abbf7c786228374fdf60d",
        "strip_prefix": "opencv_contrib-3.4.2",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "com_google_absl": {
        "distdir": "abseil-cpp",
        "archive": "20230802.0.tar.gz",
        "urls": [
            "https://github.com/abseil/abseil-cpp/archive/refs/tags/20230802.0.tar.gz",
        ],
        "sha256": "59d2976af9d6ecf001a81a35749a6e551a335b949d34918cfade07737b9d93c5",
        "strip_prefix": "abseil-cpp-20230802.0",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "hedron_compile_commands": {
        "distdir": "bazel-compile-commands-extractor",
        "archive": "d1e95ec162e050b04d0a191826f9bc478de639f7.tar.gz",
        "urls": [
            "https://github.com/hedronvision/bazel-compile-commands-extractor/archive/d1e95ec162e050b04d0a191826f9bc478de639f7.tar.gz",
        ],
        "strip_prefix": "bazel-compile-commands-extractor-d1e95ec162e050b04d0a191826f9bc478de639f7",
        "sha256": "ab6c6b4ceaf12b224e571ec075fd79086c52c3430993140bb2ed585b08dfc552",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "platforms": {
        "archive": "platforms-0.0.4.tar.gz",
        "urls": [
            "https://mirror.bazel.build/github.com/bazelbuild/platforms/releases/download/0.0.4/platforms-0.0.4.tar.gz",
            "https://github.com/bazelbuild/platforms/releases/download/0.0.4/platforms-0.0.4.tar.gz",
        ],
        "sha256": "079945598e4b6cc075846f7fd6a9d0857c33a7afc0de868c2ccb96405225135d",
        #"strip_prefix": "platforms-0.0.4",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "com_google_googletest": {
        "distdir": "com_google_googletest",
        "archive": "v1.14.0.tar.gz",
        "urls": [
            "https://github.com/google/googletest/archive/refs/tags/v1.14.0.tar.gz",
        ],
        "strip_prefix": "googletest-1.14.0",
        "sha256": "8ad598c73ad796e0d8280b082cebd82a630d73e73cd3c70057938a6501bba5d7",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "com_googlesource_code_re2": {
        "distdir": "com_googlesource_code_re2",
        "archive": "a276a8c738735a0fe45a6ee590fe2df69bcf4502.zip",
        "sha256": "906d0df8ff48f8d3a00a808827f009a840190f404559f649cb8e4d7143255ef9",
        "strip_prefix": "re2-a276a8c738735a0fe45a6ee590fe2df69bcf4502",
        "urls": [
            "https://github.com/google/re2/archive/a276a8c738735a0fe45a6ee590fe2df69bcf4502.zip"
        ],
        "used_in": [
            "additional_distfiles",
        ]
    },
    "com_github_google_benchmark": {
        "distdir": "com_github_google_benchmark",
        "archive": "0baacde3618ca617da95375e0af13ce1baadea47.zip",
        "sha256": "62e2f2e6d8a744d67e4bbc212fcfd06647080de4253c97ad5c6749e09faf2cb0",
        "strip_prefix": "benchmark-0baacde3618ca617da95375e0af13ce1baadea47",
        "urls": [
            "https://github.com/google/benchmark/archive/0baacde3618ca617da95375e0af13ce1baadea47.zip"
        ],
        "used_in": [
            "additional_distfiles",
        ]
    },
    "rules_cuda": {
        "distdir": "rules_cuda",
        "archive": "d4d6b7b51dad5bf717d8e5bafe2ad94526308191.tar.gz",
        "sha256": "dfdf74a26aa01b051b7544f1b9880af928590f9ecc0e35c9912f70bae0560bee",
        "strip_prefix": "rules_cuda-d4d6b7b51dad5bf717d8e5bafe2ad94526308191",
        "urls": [
            "https://github.com/bazel-contrib/rules_cuda/archive/d4d6b7b51dad5bf717d8e5bafe2ad94526308191.tar.gz"
        ],
        "used_in": [
            "additional_distfiles",
        ]
    },
    "fftw3": {
        "archive": "fftw-3.3.10.tar.gz",
        "sha256": "56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467",
        "strip_prefix": "fftw-3.3.10",
        "urls": [
            "http://www.fftw.org/fftw-3.3.10.tar.gz",
        ],
        "build_file": "@bazel_machinery//libs/fftw/fftw-3.3.10:fftw.BUILD",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "spdlog": {
        "distdir": "spdlog",
        "archive": "v.12.0.tar.gz",
        "sha256": "4dccf2d10f410c1e2feaff89966bfc49a1abb29ef6f08246335b110e001e09a9",
        "strip_prefix": "spdlog-1.12.0",
        "urls": [
            "https://github.com/gabime/spdlog/archive/refs/tags/v1.12.0.tar.gz"
        ],
        "build_file": "@bazel_machinery//libs/spdlog/spdlog-v1.12.0:spdlog.BUILD",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "highfive": {
        "distdir": "highfive",
        "archive": "v2.9.0.tar.gz",
        "sha256": "6301def8ceb9f4d7a595988612db288b448a3c0546f6c83417dab38c64994d7e",
        "strip_prefix": "HighFive-2.9.0",
        "urls": [
            "https://github.com/BlueBrain/HighFive/archive/refs/tags/v2.9.0.tar.gz",
        ],
        "build_file": "@bazel_machinery//libs/highfive/highfive-2.9.0:highfive.BUILD",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "cocoapi": {
        "distdir": "cocoapi",
        "archive": "8c9bcc3cf640524c4c20a9c40e89cb6a2f2fa0e9.tar.gz",
        "sha256": "4dd3450bab2287d1c1b271cf4a1420db05294194f0ad9af4e3af592d6f2b4410",
        "strip_prefix": "cocoapi-8c9bcc3cf640524c4c20a9c40e89cb6a2f2fa0e9",
        "urls": [
            "http://github.com/cocodataset/cocoapi/archive/8c9bcc3cf640524c4c20a9c40e89cb6a2f2fa0e9.tar.gz",
        ],
        "build_file": "@bazel_machinery//libs/cocoapi/master:cocoapi.BUILD",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "range-v3": {
        "distdir": "range-v3",
        "archive": "0.12.0.tar.gz",
        "sha256": "015adb2300a98edfceaf0725beec3337f542af4915cec4d0b89fa0886f4ba9cb",
        "strip_prefix": "range-v3-0.12.0",
        "urls": [
            "https://github.com/ericniebler/range-v3/archive/refs/tags/0.12.0.tar.gz",
        ],
        "used_in": [
            "additional_distfiles",
        ]
    },
    "easy_profiler": {
        "distdir": "easy_profiler",
        "archive": "v2.1.0.tar.gz",
        "sha256": "fabf95d59ede9da4873aebd52ef8a762fa8578dcdbcc6d7cdd811b5a7c3367ad",
        "strip_prefix": "easy_profiler-2.1.0",
        "urls": [
            "https://github.com/yse/easy_profiler/archive/refs/tags/v2.1.0.tar.gz",
        ],
        "build_file": "@bazel_machinery//libs/easy_profiler/v2.1.0:easy_profiler.BUILD",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "libpqxx": {
        "distdir": "libpqxx",
        "archive": "7.9.1.tar.gz",
        "sha256": "4fafd63009b1d6c2b64b8c184c04ae4d1f7aa99d8585154832d28012bae5b0b6",
        "strip_prefix": "libpqxx-7.9.1",
        "urls": [
            "https://github.com/jtv/libpqxx/archive/refs/tags/7.9.1.tar.gz",
        ],
        "build_file": "@bazel_machinery//libs/libpqxx/7.9.1:libpqxx.BUILD",
        "used_in": [
            "additional_distfiles",
        ]
    },
    "drogon": {
        "distdir": "drogon",
        "archive": "v1.9.5.tar.gz",
        "sha256": "",
        "strip_prefix": "drogon-1.9.5",
        "urls": [
            "https://github.com/drogonframework/drogon/archive/refs/tags/v1.9.5.tar.gz",
        ],
        "build_file": "@bazel_machinery//libs/drogon/v1.9.5:drogon.BUILD",
        "used_in": [
            "additional_distfiles",
        ]
    },
}
