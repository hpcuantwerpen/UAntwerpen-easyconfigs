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
* Byacc [version check](ftp://ftp.invisible-island.net/byacc)
* Flex [version check](https://github.com/westes/flex/releases)
* git [version check](https://github.com/git/git/releases)
* GNU Autoconf [version check](http://ftp.gnu.org/gnu/autoconf/)
* GNU Automake [version check](http://ftp.gnu.org/gnu/automake/)
* GNU Bison [version check](https://ftp.gnu.org/gnu/bison/)
* GNU libtool [version check](https://www.gnu.org/software/libtool/)
* GNU M4 [version check](https://www.gnu.org/software/m4/)
* GNU make [version check](http://ftp.gnu.org/gnu/make/)
* GNU sed [version check](http://ftp.gnu.org/gnu/sed/)
* CMake [version check](http://www.cmake.org/)
* Ninja [version check](https://ninja-build.org/)
* Meson [version check](https://pypi.org/project/meson/#history)
* NASM [version check](http://www.nasm.us/)
* Yasm [version check](http://yasm.tortall.net/)
* patchelf [version check](https://github.com/NixOS/patchelf/releases)
* pkg-config [version check](https://www.freedesktop.org/wiki/Software/pkg-config/)
* GNU gperf [version check](https://www.gnu.org/software/gperf/)
* GNU help2man [version check](http://ftpmirror.gnu.org/help2man/)
* Doxygen [version check](http://www.doxygen.nl/download.html) or [version check](https://github.com/doxygen/doxygen/releases)


## EasyConfigs

### Notes

* This documentation was started when developing the 2020a version of the module.
* CMake still requires an ncurses and OpenSSL library from the system.
* There are dependencies between those packages, so sometimes the order in the
  EasyConfig file does matter and is chosen to use the newly installed tools
  for the installation of some of the other tools in the bundle.

#### What about Autoconf etc.?

  * Autoconf provides: `autoconf`, `autoreconf`, `autom4te`, `autoscan`, `autoupdate`,
    `ifnames`

  * Autoconf_archive provides a lot of macros in `share/aclocal`

  * Automake provides `aclocal`, `automake`, and versioned versions of
    these commands, e.g., `aclocal-1.16` and `automake-1.16`.


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
* Byacc 20191125
* Flex 2.6.4
* re2c 1.3
* git 2.26.0
* GNU Autoconf 2.69
* GNU Automake 1.16.2
* GNU Bison 3.5.3
* GNU libtool 2.4.6
* GNU M4 1.4.18
* GNU make 4.3. Switched back to .tar.gz as there was no .tar.bz2 file anymore
* GNU sed 4.8
* CMake 3.17.0
* Ninja 1.10.0
* Meson 0.53.2
* SCons 3.1.2
* NASM 2.13.03
* Yasm 1.3
* patchelf 0.10
* pkg-config 0.29.2
* GNU gperf 3.1
* GNU help2man 1.47.13
* Doxygen 1.8.16 (1.8.17 did not compile)

* Note: We have one package that needs AutoGen but installing that is a pain as it
  also needs Guile. Newer versions of that package seem to be fine without AutoGen
  so we do not install it in EasyBuild at the moment as it is only temporarily
  needed.


### 2021b

  * `makeinfo` was added to the bundle. It is not fully functional as there is no TeX
    on the system, but for some builds it seems to be enough.

  * `xxd`, which is a tiny hex editor that comes with Vim, was also added to the bundle.
    It is a dependency for PLUMED and available on most systems, but it was added to
    the bundle for completeness.

  * Versions used: See the EasyConfig file.

  * AutoGen is still not included as that package is a pain to install.
