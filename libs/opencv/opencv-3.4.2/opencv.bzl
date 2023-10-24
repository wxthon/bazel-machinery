load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _impl(repository_ctx):
    opencv_urls = repository_ctx.attr.urls
    opencv_sha256 = repository_ctx.attr.sha256
    opencv_strip_prefix = repository_ctx.attr.strip_prefix

    repository_ctx.download_and_extract(
        url = opencv_urls,
        sha256 = opencv_sha256,
        stripPrefix = opencv_strip_prefix,
    )

    contrib_urls = repository_ctx.attr.contrib_urls
    contrib_sha256 = repository_ctx.attr.contrib_sha256
    contrib_strip_prefix = repository_ctx.attr.contrib_strip_prefix

    repository_ctx.download_and_extract(
        url = contrib_urls,
        sha256 = contrib_sha256,
        stripPrefix = contrib_strip_prefix,
    )

    substitutions = {
        '@PROCESSOR_OPTS@' : str(repository_ctx.attr.config.get('opts', [])),
    }

    repository_ctx.template(
        "BUILD",
        repository_ctx.attr.build_file_template,
        substitutions = substitutions,
    )

_opencv_repository = repository_rule(
    implementation = _impl,
    attrs = {
        "build_file_template" : attr.label(allow_single_file = True),
        "config" : attr.string_list_dict(),
        "urls": attr.string_list(default = []),
        "sha256" : attr.string(default = ""),
        "strip_prefix": attr.string(default = ""),
        "contrib_urls": attr.string_list(default = []),
        "contrib_sha256" : attr.string(default = ""),
        "contrib_strip_prefix": attr.string(default = ""),
    }
)

def opencv_repository(index, name, config=None, **kwargs):
    opencv_info = index.get("opencv")
    contrib_info = index.get("opencv_contrib")
    
    _opencv_repository(
        name = name,
        build_file_template = Label("@bazel_machinery//libs/opencv/opencv-3.4.2:opencv.BUILD.template"),
        config = config or {},
        urls = opencv_info.get("urls"),
        sha256 = opencv_info.get("sha256"),
        strip_prefix = opencv_info.get("strip_prefix"),
        contrib_urls = contrib_info.get("urls"),
        contrib_sha256 = contrib_info.get("sha256"),
        contrib_strip_prefix = contrib_info.get("strip_prefix"),
        **kwargs
    )
