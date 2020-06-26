def make_dist():
    return default_python_distribution()

def make_exe(dist):
    python_config = PythonInterpreterConfig(
        run_module='pyox.__main__'
    )
    exe = dist.to_python_executable(
        name="pyox",
        config=python_config,
        extension_module_filter='all',
        include_sources=False,
        include_resources=False,
        include_test=False,
    )
    exe.add_in_memory_python_resources(dist.pip_install(["django==2.2"]))
    for resource in dist.pip_install(["xlwings"]):
        if type(resource) == "PythonExtensionModule":
            exe.add_in_memory_extension_module(resource)
        else:
            exe.add_in_memory_python_resource(resource)
    exe.add_in_memory_python_resources()
    exe.add_in_memory_python_resources(dist.read_package_root(
       path=".",
       packages=["pyox"],
    ))
    return exe

def make_embedded_resources(exe):
    return exe.to_embedded_resources()

def make_install(exe):
    files = FileManifest()
    files.add_python_resource(".", exe)
    return files

register_target("dist", make_dist)
register_target("exe", make_exe, depends=["dist"], default=True)
register_target("resources", make_embedded_resources, depends=["exe"], default_build_script=True)
register_target("install", make_install, depends=["exe"])

resolve_targets()

PYOXIDIZER_VERSION = "0.7.0"
PYOXIDIZER_COMMIT = "UNKNOWN"
