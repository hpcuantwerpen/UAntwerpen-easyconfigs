# buildtools module

Buildtools is a collection of various build tools installed in a single module and 
directory tree. We update it once with every toolchain and give it a version number 
based on the toolchain.

The original setup was to only include executables and not libraries. However, that 
created a build dependency on sufficiently recent versions of Bison 3.0 and flex, so 
we decided to include them also even though they provide libraries that we may want 
to compile with a more recent GCC when used in applications (though I expect that 
even then those libraries will only be used on a non-performance-critical part of 
the code, I would expect in I/O. And by specifying other flex and/or Bison modules 
in the right order when building those applications, we may even totally avoid 
these problems.


## Contents

The contents of the module evolved over time. It does contain a subset of:
  * GNU tools:
      * GNU Autoconf [version check](http://ftp.gnu.org/gnu/autoconf/)
      * GNU Automake [version check](http://ftp.gnu.org/gnu/automake/)
      * GNU Bison [version check](https://ftp.gnu.org/gnu/bison/)
      * GNU gperf [version check](https://www.gnu.org/software/gperf/)
      * GNU help2man [version check](http://ftpmirror.gnu.org/help2man/)
      * GNU libtool [version check](https://www.gnu.org/software/libtool/)
      * GNU M4 [version check](https://www.gnu.org/software/m4/)
      * GNU make [version check](http://ftp.gnu.org/gnu/make/)
      * GNU sed [version check](http://ftp.gnu.org/gnu/sed/)
  * Other configuration and build tools
      * CMake [version check](http://www.cmake.org/)
      * Meson [version check](https://pypi.org/project/meson/#history)
      * Ninja [version check](https://ninja-build.org/)
      * pkg-config [version check](https://www.freedesktop.org/wiki/Software/pkg-config/)
      * SCons [version check](https://github.com/SCons/scons/releases)
  * Assemblers
      * NASM [version check](http://www.nasm.us/)
      * Yasm [version check](http://yasm.tortall.net/Download.html)
  * Lexer/grammar generators
      * Byacc [version check](ftp://ftp.invisible-island.net/byacc)
      * Flex [version check](https://github.com/westes/flex/releases)
      * re2c [version check](https://github.com/skvadrik/re2c/releases)
  * Other tools
      * Doxygen [version check](http://www.doxygen.nl/download.html) or [version check](https://github.com/doxygen/doxygen/releases)
      * git [version check](https://github.com/git/git/releases)
      * patchelf [version check](https://github.com/NixOS/patchelf/releases)


## EasyConfigs

### Notes

  * This documentation was started when developing the 2020a version of the module.
  * CMake still requires an ncurses and OpenSSL library from the system.
  * There are dependencies between those packages, so sometimes the order in the 
    EasyConfig file does matter and is chosen to use the newly installed tools
    for the installation of some of the other tools in the bundle.


### 2020a

  * We did notice that some GNU tools are no longer available in the tar.bz2 format and 
    instead in .tar.lz. However, since there lzip was not yet installed on our systems 
    and since there is no easy-to-recognize SOURCE_TAR_LZ or SOURCELOWER_TAR_LZ constant
    defined in EasyBuild, we do not yet use that format.
  * We did add EBROOT and EBVERSION variables for all components for increased compatibility
    with standard EasysBuild-generated modules (in case those variables would, e.g., 
    be used in EasyBlocks for certain software packages).
  * Added re2c and SCons to the bundle.

Versions used:
  * GNU Autoconf 2.69
  * GNU Automake 1.16.2
  * GNU Bison 3.5.3
  * GNU gperf 3.1
  * GNU help2man 1.47.13
  * GNU libtool 2.4.6
  * GNU M4 1.4.18
  * GNU make 4.3. Switched back to .tar.gz as there was no .tar.bz2 file anymore
  * GNU sed 4.8
  * CMake 3.17.0
  * Meson 0.53.2
  * Ninja 1.10.0
  * pkg-config 0.29.2
  * SCons 3.1.2
  * NASM 2.13.03
  * Yasm 1.3
  * Byacc 20191125
  * Flex 2.6.4
  * re2c 1.3
  * Doxygen 1.8.16 (1.8.17 did not compile)
  * git 2.26.0 
  * patchelf 0.10


### 2020b

Versions used:
  * GNU Autoconf 2.69
  * GNU Automake 1.16.2
  * GNU Bison 3.6.4
  * GNU gperf 3.1
  * GNU help2man 1.47.16
  * GNU libtool 2.4.6
  * GNU M4 1.4.18
  * GNU make 4.3. Switched back to .tar.gz as there was no .tar.bz2 file anymore
  * GNU sed 4.8
  * CMake 3.17.3
  * Meson 0.54.3
  * Ninja 1.10.0
  * pkg-config 0.29.2
  * SCons 4.0.0
  * Byacc 20200330
  * Flex 2.6.4
  * re2c 1.3
  * NASM 2.15.02
  * Yasm 1.3
  * Doxygen 1.8.16 (1.8.17 and 1.8.18 fail to compile with the system compiler of CentOS 
    7)
  * git 2.27.0 
  * patchelf 0.11

