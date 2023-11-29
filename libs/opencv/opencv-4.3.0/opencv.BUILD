load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

filegroup(name = "all", srcs = glob(["**/*"]), visibility = ["//visibility:public"])

cmake(
    name = "opencv",
    generate_args = [ 
        "-G Ninja",
        "-DBUILD_LIST=core,highgui,imgcodecs,imgproc,video,videoio",
        "-DWITH_GTK_2_X=OFF",
        "-DWITH_GTK=OFF",
        "-DWITH_QT=ON",
        "-DWITH_JPEG=ON",
        "-DWITH_PNG=ON",
        "-DCMAKE_PREFIX_PATH=/workspace/code/install/Qt5.12.12/5.12.12/gcc_64",
    ],  
    lib_source = "@opencv//:all",
    #build_args = [
    #    "ninja",
    #    "ninja install",
    #], 
    out_lib_dir = "lib",
    out_include_dir = "include/opencv4",
    out_shared_libs = [ 
        "libopencv_core.so",
        "libopencv_core.so.4.3",
        "libopencv_core.so.4.3.0",
        "libopencv_highgui.so",
        "libopencv_highgui.so.4.3",
        "libopencv_highgui.so.4.3.0",
        "libopencv_imgcodecs.so",
        "libopencv_imgcodecs.so.4.3",
        "libopencv_imgcodecs.so.4.3.0",
        "libopencv_imgproc.so",
        "libopencv_imgproc.so.4.3",
        "libopencv_imgproc.so.4.3.0",
        "libopencv_video.so",
        "libopencv_video.so.4.3",
        "libopencv_video.so.4.3.0",
        "libopencv_videoio.so",
        "libopencv_videoio.so.4.3",
        "libopencv_videoio.so.4.3.0",
    ],
    visibility = ["//visibility:public"],
)
