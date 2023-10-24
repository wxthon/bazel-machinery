
def _impl(ctx):
    hdrs = [x for x in
            depset(transitive = [x.files for x in ctx.attr.textual_hdrs]).to_list()]
    force_includes = depset(transitive = [x.files for x in ctx.attr.force_includes])
    includes = depset(transitive = [x.files for x in ctx.attr.includes])

    outs = []

    for src in ctx.attr.srcs:
        for name in src.files.to_list():
            this_out = ctx.actions.declare_file(name.path.replace(".asm", ".o"))
            outs.append(this_out);

            ctx.actions.run(
                outputs = [this_out],
                mnemonic = "Assembling",
                progress_message = "Assembling " + name.path,
                inputs = [name] + hdrs + force_includes.to_list(),
                executable = ctx.attr._nasm.files.to_list()[0],
                arguments = (
                    ctx.attr.extra_args +
                    ["-I" + x.dirname + "/" for x in force_includes.to_list()] +
                    [
                        "-o", this_out.path,
                        name.path,
                    ] +
                    ["-P" + x.path for x in force_includes.to_list()]
                ),
            )

    return [DefaultInfo(
        files = depset(outs),
    )]


_nasm_object = rule(
    implementation = _impl,
    attrs = {
        "srcs" : attr.label_list(allow_files = True),
        "_nasm" : attr.label(
            default = Label("@nasm//:nasm"),
            allow_single_file = True,
            cfg = "host",
            executable = True,
        ),
        "extra_args" : attr.string_list(),
        "textual_hdrs" : attr.label_list(allow_files = True),
        "force_includes" : attr.label_list(allow_files = True),
        "includes" : attr.label_list(allow_files = True),
    },
)

def nasm_objects(name, srcs, **kwargs):
    _nasm_object(
        name = name,
        srcs = srcs,
        **kwargs)
