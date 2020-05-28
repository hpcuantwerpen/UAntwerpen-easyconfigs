# minimap2 instructions

* [Minimap2 on GitHub](https://github.com/lh3/minimap2)
     * [Check latest release](https://github.com/lh3/minimap2/releases)

## General information

As of May 2019, minimap2 is still further developed with frequent commits.
Yet the base of the code is ancient and not up to modern standards anymore.
Thee seems to be no form of multi-core parallelism, and though there are
SIMD-specific routines in the code, they only go up to SSE4.1 with zero
support for the newer AVX2 or AVX512 instruction set extensions.

There is no configure proces and no `make install` support in the code.
CFLAGS is also hard-coded for the GNU compiler in a way that cannot be 
overwritten from the environment, only from the make command line.


## EasyBuild support

There is support for minimap2 in the 
[EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/m/minimap2).

We started from those files, but made a few enhancements, see below.

The package is integrated in BioTools at UAntwerp.


### Version 2.17 in the 2020a toolchains

* Started from the EasyBuilders recipe for GCCcore but made several modifications
* Switched to the Intel toolchain
* Added `buildopts` to make sure `CFLAGS` from the EasyBuild environment is used
  rather than the hard-coded GCC flags that don't optimize for recent architectures.
* Edit the Makefile via `prebuildopts` to remove some flags that may in fact turn of
  certain optimizations for modern CPUs.
* Build the `extra` rather than the default target `all` so that the optional
  executables `minimap2-lite` and `sdust` are also generated.
