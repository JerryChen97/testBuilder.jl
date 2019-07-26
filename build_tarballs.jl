# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "testBuilder.jl"
version = v"233.0.0"

# Collection of sources required to build testBuilder.jl
sources = [
    "http://ftp.gnu.org/gnu/glpk/glpk-4.65.tar.gz" =>
    "4281e29b628864dfe48d393a7bedd781e5b475387c20d8b0158f329994721a10",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/glpk-4.65/
./configure --prefix=$prefix --host=$target 
make -j$(nproc)
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf),
    MacOS(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libglpk", :libglpk)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

