load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

_BUILD = """
load("@rules_pkg//pkg:tar.bzl", "pkg_tar")
load("@rules_pkg//pkg:mappings.bzl", "pkg_filegroup", "pkg_files")

{subtar_content}

pkg_tar(
  name="archives",
  srcs = {srcs},
  package_dir = "{dirname}",
  visibility = ["//visibility:public"],
)

"""

_SUBTAR_BUILD = """
pkg_files(
  name = "{name}",
  srcs = {srcs},
  prefix = "{package_dir}",
)
"""

def _distdir_tar_impl(ctx):
    srcs = []
    SUBTAR_BUILD_CONTENT = ""
    for name in ctx.attr.archives:
        ctx.download(ctx.attr.urls[name], name, ctx.attr.sha256[name], False)
        if name in ctx.attr.distdirs:
            rule_name = name.replace("/", '-')
            dir = ctx.attr.distdirs[name]
            SUBTAR_BUILD_CONTENT += _SUBTAR_BUILD.format(name = rule_name, srcs = [name], package_dir = dir)
            srcs.append(":{}".format(rule_name))
        else:
            srcs.append(name)
            
    ctx.file("WORKSPACE", "")
    ctx.file(
        "BUILD",
        _BUILD.format(srcs = srcs, dirname = ctx.attr.dirname, subtar_content = SUBTAR_BUILD_CONTENT),
    )

_distdir_tar_attrs = {
    "archives": attr.string_list(),
    "sha256": attr.string_dict(),
    "urls": attr.string_list_dict(),
    "distdirs": attr.string_dict(),
    "dirname": attr.string(default = "distdir"),
}

_distdir_tar = repository_rule(
    implementation = _distdir_tar_impl,
    attrs = _distdir_tar_attrs,
)

def distdir_tar(name, archives, sha256, urls, dirname, distdirs, dist_deps = None):
    """Creates a repository whose content is a set of tar files.

    Args:
      name: repo name.
      archives: list of tar file names.
      sha256: map of tar file names to SHAs.
      urls: map of tar file names to URL lists.
      dirname: output directory in repo.
      dist_deps: map of repo names to dict of archive, sha256, and urls.
    """
    if dist_deps:
        for dep, info in dist_deps.items():
            archive_file = info["archive"]
            if "distdir" in info:
                archive_file = "{}/{}".format(info["distdir"], archive_file)
                distdirs[archive_file] = info["distdir"]
            archives.append(archive_file)
            sha256[archive_file] = info["sha256"]
            urls[archive_file] = info["urls"]
    _distdir_tar(
        name = name,
        archives = archives,
        sha256 = sha256,
        urls = urls,
        distdirs = distdirs,
        dirname = dirname,
    )

def create_index(deps):
    index = {}
    for repo_name in deps:
        repo = deps[repo_name]
        index[repo_name] = repo
        aliases = repo.get("aliases")
        if aliases:
            for alias in aliases:
                index[alias] = repo
    return index

def dist_http_archive(index, name, **kwargs):
    info = index[name]
    if "patch_args" not in kwargs:
        kwargs["patch_args"] = info.get("patch_args")
    if "patches" not in kwargs:
        kwargs["patches"] = info.get("patches")
    if "patch_cmds" in info:
        kwargs["patch_cmds"] = info.get("patch_cmds")
    if "patch_cmds_win" in info:
        kwargs["patch_cmds_win"] = info.get("patch_cmds_win")
    if "strip_prefix" not in kwargs:
        kwargs["strip_prefix"] = info.get("strip_prefix")
    if "build_file" in info:
        kwargs["build_file"] = info.get("build_file")
    if "build_file_content" in info:
        kwargs["build_file_content"] = info.get("build_file_content")
    if "workspace_file" in info:
        kwargs["workspace_file"] = info.get("workspace_file")
    if "workspace_file_content" in info:
        kwargs["workspace_file_content"] = info.get("workspace_file_content")
    maybe(
        http_archive,
        name = name,
        sha256 = info["sha256"],
        urls = info["urls"],
        **kwargs
    )

def dist_http_file(index, name, **kwargs):
    """Wraps http_file, providing attributes like sha and urls from the central list.

    dist_http_file wraps an http_file invocation, but looks up relevant attributes
    from distdir_deps.bzl so the user does not have to specify them.

    Args:
      name: repo name
      **kwargs: see http_file for allowed args.
    """
    info = index[name]
    http_file(
        name = name,
        sha256 = info["sha256"],
        urls = info["urls"],
        **kwargs
    )
