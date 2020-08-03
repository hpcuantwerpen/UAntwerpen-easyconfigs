# snappy instructions

 * [snappy on GitHub](https://github.com/google/snappy)
     * [Releases on GitHub](https://github.com/google/snappy/releases)

## General information

 * Snappy is build using CMake.
 * Snappy can use zlib and lzo2.
 * There are CMake flags to enforce AVX or AVX2 but it is not clear if these
   are needed as I cannot find where they define symbols that would then be
   used in the code. It does influence compiler options that are added though.
 * Note that building snappy requires two iterations if we want both static
   and shared libraries.

## EasyBuild

This README was developed starting with snappy 1.1.8 in the 2020a toolchains.

There is [EasyBuilders support for snappy](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/s/snappy)
but the dependencies are incomplete.

### 1.1.8 in 2020a

 * This EasyConfig was made to prepare for inclusion in the baselibs Bundle.
 * The dependencies on zlib and LZO (lzo2) were added to the dependencies list to ensure
   a build with maximum potential.

### 1.1.8 in 2020b

  * Added `'-DCMAKE_INSTALL_LIBDIR="%(installdir)s/lib"'` to `configopts` to generate 
    the libraries in the `lib` subdirectory rather than the CMake defaule `lib64`.
