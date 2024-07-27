

def _torchvision_repo_impl(rctx):
    name = rctx.name
    version = rctx.attr.version
    print("%s: torchvision(%s)" % (name, version))
    # use the correct archive configuration
    archive = {}
    if rctx.attr.version in LIBTORCH_ARCHIVES:
        archive = LIBTORCH_ARCHIVES[rctx.attr.version]
    else:
        archive = {
            "urls": [],
            "strip_prefix": "",
        }
    if rctx.attr.urls:
        archive["urls"] = rctx.attr.urls
    if rctx.attr.strip_prefix:
        archive["strip_prefix"] = rctx.attr.strip_prefix


torchvision_repo = repository_rule(
    implementation = _torchvision_repo_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "urls": attr.string_list(default=[]),
        "strip_prefix": attr.string(default=''),
    }
)
