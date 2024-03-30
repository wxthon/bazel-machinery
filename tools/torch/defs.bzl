
load("@rules_python//python:defs.bzl", "py_library")

def torch_repository(name):
    rules = native.existing_rules()
    for name in rules:
        x = rules[name]
        print('----------- ', name, ' ------------')
        for k, v in x.items():
            print('  ', k, '=', v)
    for m in dir(native):
        print(m)
    # print(proto.encode_text(struct(name='hello world')))
    # print(native.module_name())
    # files = native.glob(include=['*'])
    # print(files)
    native.cc_library(
        name = 'hello',
        srcs = [],
        hdrs = [],
        visibility = ['//visibility:public'],
    )


def _pytorch_repo_impl(rctx):
    name = rctx.name
    version = rctx.attr.version

    # check python version
    ret = rctx.execute([
        "python3",
        "--version",
    ])
    if ret.return_code != 0:
        fail("Not found python3 interpreter")
    python_version = ret.stdout.strip().split(" ")[1].strip()
    print("Python(%s)" % python_version)

    python_lib_name = "python%s" % '.'.join(python_version.split('.')[:-1])

    # check pytorch version
    rctx.file("check_pytorch.py", """
try:
    import torch
    print(torch.__version__)
except Exception:
    print('none')
""")
    ret = rctx.execute([
        "python3",
        "check_pytorch.py",
    ])
    if ret.return_code != 0:
        fail("Cannot detect torch version")
    torch_version = ret.stdout.strip()
    if torch_version == 'none':
        fail("Please install torch by `pip install torch`")
    if torch_version.count(version) == 0:
        fail("Expect torch-%s, but found torch-%s, please reinstall it" % (
            version, torch_version
        ))
    
    # find the path of torch package
    ret = rctx.execute([
        "python3",
        "-c",
        "import torch; print(torch.__path__)"
    ])
    if ret.return_code != 0:
        fail("Cannot find the path of pytorch package")
    torch_dist_dir = ret.stdout.strip("[]'\n")

    print("PyTorch(%s) => %s" % (torch_version, torch_dist_dir))

    rctx.symlink(torch_dist_dir, "torch")

    rctx.file("BUILD.bazel", """
cc_library(
    name = "torch",
    srcs = select({
    "@bazel_tools//src/conditions:darwin": glob([
            "torch/lib/libcaffe2.dylib",
            "torch/lib/libc10_cuda.dylib",
            "torch/lib/libtorch.dylib",
            "torch/lib/libtorch_cuda.dylib",
            "torch/lib/libtorch.1.dylib",
            "torch/lib/libtensorpipe.dylib"
        ]),
        "//conditions:default": glob([
            # "torch/lib/lib*.so*",
        ], exclude=[
            #"lib/libtorch_python.so",
            #"lib/libnnapi_backend.so"
        ]),
    }),
    defines = [
        "C10_USE_GLOG=0",
        "_GLIBCXX_USE_CXX11_ABI=0",
    ],
    local_defines = [
        "NDEBUG=1",
    ],
    linkopts = [
        "-L%s",
        "-lc10",
        "-lc10_cuda",
        "-ltorch",
        "-ltorch_cpu",
        "-ltorch_cuda",
        "-l%s",
        "-pthread",
        # "-Wl,--disable-new-dtags",
        "-Wl,-rpath,%s",
    ],
    deps = select({
        "@bazel_tools//src/conditions:darwin": [
            "@mklml_repo_darwin//:mklml"
        ],
        "//conditions:default": [],
    }) + [
        "@com_github_google_glog//:glog",
    ],
    hdrs = glob([
        "torch/include/ATen/**",
        "torch/include/c10/**",
        "torch/include/caffe2/**",
        "torch/include/torch/**",
        "torch/include/torch/csrc/**",
        "torch/include/torch/csrc/jit/**",
        "torch/include/torch/csrc/api/include/**",
    ]),
    includes = [
        "torch",
        "torch/include",
        "torch/include/torch/csrc/api/include",
        "torch/include/THC",
        "torch/include/TH",
    ],
    visibility = ["//visibility:public"]
)
""" % (torch_dist_dir + '/lib',
       python_lib_name,
       torch_dist_dir + '/lib'))
    print("Remember to add 'build --copt=-D_GLIBCXX_USE_CXX11_ABI=0' to .bazelrc")
    
pytorch_repo = repository_rule(
    implementation = _pytorch_repo_impl,
    attrs = {
        'version': attr.string(mandatory = True),
    },
)    


LIBTORCH_ARCHIVES = {
    "2.0.1+cu118": {
        "urls": [
            "/workspace/install/libtorch-cxx11-abi-shared-with-deps-2.0.1+cu118.zip",
            "https://download.pytorch.org/libtorch/cu118/libtorch-cxx11-abi-shared-with-deps-2.0.1%2Bcu118.zip",
        ],
        "strip_prefix": "libtorch",
        "sha256": "843ad19e769a189758fd6a21bfced9024494b52344f4bc4fb75f75d36e6ea0c7",
    },
    "2.2.2+cu121": {
        "urls": [
            "/workspace/install/libtorch-cxx11-abi-shared-with-deps-2.2.2+cu121.zip",
            "https://download.pytorch.org/libtorch/cu121/libtorch-cxx11-abi-shared-with-deps-2.2.2%2Bcu121.zip",
        ],
        "strip_prefix": "libtorch",
        # "sha256": "843ad19e769a189758fd6a21bfced9024494b52344f4bc4fb75f75d36e6ea0c7",
    },
}

def _libtorch_repo_impl(rctx):
    name = rctx.name
    version = rctx.attr.version
    print("%s: libtorch(%s)" % (name, version))
    # use the correct archive configuration
    if 'urls' not in rctx.attr.archive:
        archive = LIBTORCH_ARCHIVES[rctx.attr.version]
    else:
        archive = rctx.attr.archive

    # find python library
    ret = rctx.execute([
        "bash",
        "-c",
        "ldconfig -p | grep -oE 'lib(python3\\.[0-9]+)?.so$'",
    ])
    if ret.return_code != 0:
        fail('Cannot find libpython3.x.so')
    python_lib_name = ret.stdout.strip().replace('lib', '').replace('.so', '')

    # check cuda
    if version.count('cu10') > 0:
        if rctx.execute(['ls', '/usr/local/cuda-10']).return_code != 0:
            fail('Not found /usr/local/cuda-10, please install it')
    elif version.count('cu11') > 0:
        if rctx.execute(['ls', '/usr/local/cuda-11']).return_code != 0:
            fail('Not found /usr/local/cuda-11, please install it')
    elif version.count('cu12') > 0:
        if rctx.execute(['ls', '/usr/local/cuda-12']).return_code != 0:
            fail('Not found /usr/local/cuda-12, please install it')
    else:
        fail('Bad version: ' + version)
    abi_define = "_GLIBCXX_USE_CXX11_ABI=0"
    # print(archive)
    for url in archive['urls']:
        if url.count('cxx11-abi') > 0:
            abi_define = "_GLIBCXX_USE_CXX11_ABI=1"
        else:
            abi_define = "_GLIBCXX_USE_CXX11_ABI=0"
        if url.startswith('http'):           
            ret = rctx.download_and_extract(
                url, sha256=archive['sha256'],
                stripPrefix = archive['strip_prefix'])
            if ret.success:
                break
        elif url.startswith('file') or url.startswith('/'):
            archive_name = url.replace('file://', '')
            ret = rctx.extract(archive_name,
                               stripPrefix = archive['strip_prefix'])
            break
    # print('download ok')
    
    rctx.file("BUILD.bazel", """
package(default_visibility=["//visibility:public"])
cc_library(
    name = "torch",
    srcs = select({
        "@bazel_tools//src/conditions:darwin": glob([
            "lib/libcaffe2.dylib",
            "lib/libc10_cuda.dylib",
            "lib/libtorch.dylib",
            "lib/libtorch_cuda.dylib",
            "lib/libtorch.1.dylib",
            "lib/libtensorpipe.dylib"
        ]),
        "//conditions:default": glob([
            "lib/lib*.so*",
	        #"lib/libnvrtc-builtins-fed02928.so.*",
	        #"lib/libc10_cuda.so",
            #"lib/libtorch.so",
            #"lib/libtorch_cuda.so",
            #"lib/libc10.so",
            #"lib/libclog.a",
        ], exclude=[
            #"lib/libtorch_python.so",
            #"lib/libnnapi_backend.so"
        ]),
    }),
    defines = [
        "C10_USE_GLOG=0",
        "%s",
    ],
    local_defines = [
        "NDEBUG=1",
    ],
    linkopts = [
        "-ltorch",
        "-pthread",
        "-l%s",
    ],
    deps = select({
        "@bazel_tools//src/conditions:darwin": [
            "@mklml_repo_darwin//:mklml"
        ],
        "//conditions:default": [],
    }) + [
        "@com_github_google_glog//:glog",
    ],
    hdrs = glob([
        "include/ATen/**",
        "include/c10/**",
        "include/caffe2/**",
        "include/torch/**",
        "include/torch/csrc/**",
        "include/torch/csrc/jit/**",
        "include/torch/csrc/api/include/**",
    ]),
    includes = [
        "include",
        "include/torch/csrc/api/include",
        "include/THC",
        "include/TH",
    ],
)
filegroup(
    name = "so",
    srcs = glob([
        "lib/*.so",
        "lib/*.so.*",
    ]),  
)
filegroup(
    name = "headers",
    srcs = glob([
        "include/*",
        "include/**/*",
    ])
)
filegroup(
    name = "srcs",
    srcs = glob([
        "**/*"
    ], exclude=[
        "BUILD.bazel",
        "WORKSPACE",
    ]),
)
""" % (abi_define, python_lib_name))
    print("Remember to add 'build --copt=-D%s' to .bazelrc" % abi_define)

libtorch_repo = repository_rule(
    implementation = _libtorch_repo_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "archive": attr.string_dict(),
    }
)
