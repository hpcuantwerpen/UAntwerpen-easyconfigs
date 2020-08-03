# Baselibs

## Versions of packages

  * Terminal I/O
      * [ncurses](https://ftp.gnu.org/pub/gnu/ncurses/)
      * [libreadline](https://ftp.gnu.org/pub/gnu/readline/)
  * File compression tools and libraries
      * [brotli](https://github.com/google/brotli/releases)
      * [bzip2](https://sourceforge.net/projects/bzip2/files/)
      * [lz4](https://github.com/lz4/lz4/releases)
      * [Szip](https://support.hdfgroup.org/ftp/lib-external/szip/)
      * [XZ](https://tukaani.org/xz/)
      * [zlib](https://zlib.net/)
      * [gzip](https://ftp.gnu.org/gnu/gzip/)
      * [lzip](http://download.savannah.gnu.org/releases/lzip/)
      * [zstd](https://github.com/facebook/zstd/releases)
      * [libb2](https://github.com/BLAKE2/libb2/releases)
      * [LZO](http://www.oberhumer.com/opensource/lzo/#download)
      * [snappy](# https://github.com/google/snappy/releases) 
      * [blosc](https://github.com/Blosc/c-blosc/releases)
      * [libdeflate](https://github.com/ebiggers/libdeflate/releases)
      * [libarchive](https://github.com/libarchive/libarchive/releases)
  * Graphics file formats
      * [giflib](https://sourceforge.net/projects/giflib/files/)
      * [JasPer](http://www.ece.uvic.ca/~frodo/jasper/#download)
      * [libjpegturbo](https://sourceforge.net/projects/libjpeg-turbo/files/)
      * [libpng](http://www.libpng.org/pub/png/libpng.html)
      * [LibTIFF](http://www.simplesystems.org/libtiff/)
      * [libwebp](https://github.com/webmproject/libwebp/releases)
  * Audio and video
      * [LAME](http://lame.sourceforge.net/)
      * [libopus](http://opus-codec.org/downloads/)
      * [libogg](https://github.com/xiph/ogg/releases) ([alternative site](https://www.xiph.org/downloads/))
      * [libvorbis](https://github.com/xiph/vorbis/releases) ([alternative site](https://xiph.org/downloads/))
      * [FLAC](https://github.com/xiph/flac/releases) ([alternative site, seems to be lagging](https://xiph.org/downloads/))
      * [libsndfile](https://github.com/erikd/libsndfile/releases)
      * [x264](https://download.videolan.org/pub/videolan/x264/snapshots/) (In the process 
        of moving to [code.videolan.org](https://code.videolan.org/videolan/x264/))
      * [x265](http://download.videolan.org/pub/videolan/x265/)
      * [libtheora](https://github.com/xiph/theora/releases) ([alternative site])
  * Networking, security and XML
      * [cURL](https://curl.haxx.se/download/)
      * [wget](https://ftp.gnu.org/gnu/wget/)
      * [expat](https://github.com/libexpat/libexpat/releases)
      * [libxml2](http://xmlsoft.org/sources/)
      * [libxslt](http://xmlsoft.org/sources/)
  * Mathematical libraries     
      * [GSL](https://ftp.gnu.org/gnu/gsl/) 
      * [libcerf](https://jugit.fz-juelich.de/mlz/libcerf/-/releases)
  * Arbitrary precision mathematics
      * [GMP](https://ftp.gnu.org/gnu/gmp/)
      * [MPFR](https://ftp.gnu.org/gnu/mpfr/)
      * [MPC](https://ftp.gnu.org/gnu/mpc/)
      * [mpdecimal](https://www.bytereef.org/mpdecimal/)
  * Drawing graphics
      * [pixman](https://www.cairographics.org/releases/)
      * [fontconfig](https://www.freedesktop.org/software/fontconfig/release/)
      * [freetype](https://download.savannah.gnu.org/releases/freetype/)
  * Unicode and multilingual support
      * [fribidi](https://github.com/fribidi/fribidi/releases)
      * [gettext](https://ftp.gnu.org/pub/gnu/gettext/)
      * [ICU (ICU4C)](http://site.icu-project.org/download)     
      * [libidn2](https://ftp.gnu.org/gnu/libidn/)
      * [libidn](https://ftp.gnu.org/gnu/libidn/)
      * [libiconv](https://ftp.gnu.org/pub/gnu/libiconv/)
      * [libunistring](https://ftp.gnu.org/gnu/libunistring/)
  * Miscellaneous
      * [double_conv](https://github.com/google/double-conversion/releases)
      * [file](http://ftp.astron.com/pub/file/)
      * [gc](http://hboehm.info/gc/gc_source/)
      * [GDBM](https://ftp.gnu.org/gnu/gdbm/)
      * [libevent](https://libevent.org/)
      * [libffi](http://sourceware.org/pub/libffi/)
      * [libyaml](https://github.com/yaml/libyaml/releases)
      * [LMDB](https://github.com/LMDB/lmdb/releases)
      * [PCRE2](https://ftp.pcre.org/pub/pcre/)
      * [PCRE](https://ftp.pcre.org/pub/pcre/)
      * [UDUNITS](https://www.unidata.ucar.edu/downloads/udunits/)
      * [util-linux](https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/)
      * libtool


## Remarks on individual packages

### wget

  * wget can now use libidn2 instead of libidn and PCRE2 instead of PCRE.
  * According to the [EasyBuilders recipes](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/w/wget)
    wget 1.20 needs OpenSSL 1.0.1s or newer or GnuTLS 1.2.11 or newer, with GnuTLS being 
    the default it looks for if no --with-ssl is specified.

## EasyConfigs

### 2020a bundle

  * Added lzip to the bundle.
  * Added libdeflate to the bundle. Note that libdeflate contains its own gzip program, 
    but when installing it renames the executables to deflate-gzip and deflate-gunzip 
    to avoid a name clash.
  * Added libidn and the newer libidn2 to the bundle
  * Added wget to the bundle. Not really a library, but it is a tool that gets used by
    some packages and that requires other components from baseutils, so this is a better
    place to put it than, e.g., our buildtools module.
  * Added mpdecimal to the bundle, a library that is used by Python in its built-in
    cdecimal package.
  * Added LZO and Blosc to the bundle. These libraries are used by PyTables (tables
    on PyPi) which is used by pandas, a package popular with our big data users.
  * Added GDBM, usefull for the dbm package in the Python standard library.
  * Added LMDB, used by BLAST+
  * Added double-conversion, needed for Qt5.
      * We perform 3 build passes for double-conversion: static, static with 
        position-independent code and shared. Note however that due to our choice
        of toolchainopts, the pure static in fact already contains position-independent
        code. We decided to still perform the three passes two have all library names
        generated (rather than solving it with symbolic links).
  * Added snappy, needed for Qt5
      * We perform 2 build passes to have both static and shared libraries.
      * Note that it also needs some care to set AVX-specific options.
  * Added libtool also to baselibs even though it is in buildtools already. It turns
    out that there is software that links to the libtools libraries (in particular
    NEST does so), and we want to keep buildtools build dependency only as we compile
    it with the system compilers.
  * Added various sound-related libraries
      * libogg (Ogg container format)
      * libvorbis: needs libogg, implements the OggVorbis codec.
      * FLAC: can use libogg
      * libsndfile: Encapsulates libopus, lib ogg/libvorbis, FLAC.
  * Also added libtheora to complete the line. It can be used in FFmpeg.

### 2020b bundle

  * Try to get rid of lib64 as having both lib and lib64 subdirectories in a single module
    confuses some EasyBlocks (including the Python one) if we define matching EBROOT variables.
  * Switched to GitHub as a download site for FLAC as that contains a newer version 
    than the xiph.org download site.
  * blosc 1.19.0 did not compile (error: undefined reference to blosc_internal_xgetbv).
    We found a patch on the web that we used to compile Blosc, and it is a problem 
    that will likely be solved in a future version. 
  * GDBM 1.18.1 does not compile with GCC 10.1. This is a known problem, see, e.g., 
    the [bug report on the SPACK GitHub](https://github.com/spack/spack/issues/16394).
    We took the solution suggested there (injecting `-fcommon` in CFLAGS) rather than the
    patch suggested for GENTOO Linux and also mentioned on that page.
  * Changed the directory structure:
      * CMake-based builds: One can change the library install directory by 
        adding `'-DCMAKE_INSTALL_LIBDIR="%(installdir)s/lib"'` to configopts.
        Packages done that way:
          * brotli
          * snappy
          * libjpeg-turbo
          * JasPer
          * double-conversion
      * libffi is a very special case. It uses a `ConfigureMake` build process but 
        it puts the libraries in `lib64` but the pkg-config information in `lib`.
        This cannot be disabled by simply setting `--libdir`. Instead, one needs to
        disable multi-OS build by adding `--disable-multi-os-directory` to `configopts`.

