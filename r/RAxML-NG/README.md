# RAxML-NG installation instructions

* [GitHub](https://github.com/amkozlov/raxml-ng)

## General information

* RAxML has a number of dependencies that have no official releases. They are not
  included in the source code if you download a tar file from the GitHub repository.
  Therefore it is better to get the sources via a recursive git clone.
* Dependencies: RAxML-NG uses the following libraries (``libs`` subdirectory)
    * [terraphast](https://github.com/amkozlov/terraphast-one) from the same developer
      as RAxML-NG
    * [pll-modules](https://github.com/ddarriba/pll-modules) which has a different 
      author
        * Which uses [libpll](https://github.com/xflouris/libpll-2) which has yet another
          author. Stored in the ``libs/libpll`` subdirectory of ``libs/pll-modules``.
* RAxML-NG supports distributed memory parallelisation with MPI and shared memory 
  parallelisation using pthreads. It is not clear if using both together really gives
  a hybrid executable as the documentation is mostly missing.

## EasyConfigs

EasyConfigs were developed at UAntwerp as there was no support for the -NG version
in EasyBuild.

This documentation was started when installing version 0.9.0. However, we did try to
reconstruct what we did in earlier versions and cover this in the documentation also.

The main problem with installing RAxML-NG is the poor quality of the build scripts.
They impose certain compiler options that 
  1. are only valid for GCC and
  2. are for ancient systems (Ivy Bridge and before) and suboptimal for later systems.

As the root CMake file then further calls configure scripts  


### Version 0.4.1

* This was still without terraphast.
* We needed to adapt the main CMakeList.txt file to recognize the Intel compilers.
  This was not sufficient though, libpll was still compiled in a suboptimal way
  (no ``-xHost``).
* The recipe does not do a download of the sources from GitHub, this still has to
  be done manually.


## Version 0.8.1

* This version now comes with with terraphast which we didn't get to compile with 
  the Intel compiler. Since we didn't have a full FOSS toolchain with working MPI 
  set up at the time, we did not build a distributed memory version.
* We made similar changes to the main CMakeLists.txt file. We now had to stick to
  the GCC compilers though. Which also were used in a suboptimal way for the 
  dependencies. We tried to add the Intel compiler to the recognized compilers,
  and additional options for the SIMD settings chosing better compiler options.


### Version 0.9.0

* Added GMP as this turned out to be an option in the CMake file.
* The CMake configuration now supports "make install" so we now use that to
  install the software.
* Using the default CMakeLists.txt file: Compiled with GCCcore for Hopper 
  (Ivybridge architecture) as this is the only machine for which the compiler
  flags are somewhat reasonable. This still implies that the terraphast component
  is compiled without any optimizations, just the default generic architecture
  -O0 of GCC due to bugs in the configuration procedure.

#### Remarks on the configuration and compilation process

* ``pll-modules`` and ``libpll`` pick up compiler options that are passed through 
  the environment, but add additioal ones that may not be optimal for the chosen 
  compiler or not be valid.
* ``terraphast`` is a complete disaster. It is compiled in a very suboptimal way.
  When compiled with AVX on our Ivybridge cluster and with GCC, it only uses
  ``-mavx`` as the optimization option. Which imples that even though it is told
  to generate code for AVX-aware processors, it does so at the default optimization
  level, which is``-O0`` for GCC... This is clearly unacceptable on a high performance
  system.

