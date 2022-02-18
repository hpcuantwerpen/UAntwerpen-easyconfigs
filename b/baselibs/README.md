# Baselibs

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

Note: Intermediate changes for easyBuild 4.5.0
* The EasyBlock for bzip2 has changed and now does the install the way it should
  so installopts is no longer needed (and fails in fact).
* libsndfile: Bumped the version to one that doesn't need autogen to be installed.
* libxml2: Explicitly use ConfigureMake as the EB_libxml2 EasyBlock crashes with an
  internal EasyBuild error. It also avoids problems with dependency detection that
  can go wrong (and triggers the bug as it does not occur when using libxml2 as
  a separate EasyConfig file).

### 2021b bundle

  * zlib is moved out again and included as a dependency. The reason is that we
    already need zlib to get binutils to work correctly. The approach that EasyBuild
    used to take to include zlib in the binutils libraries that need it, turned out
    to not always work correctly, causing trouble with static linking.

    See also [easybuild-easyblocks issue 1350](https://github.com/easybuilders/easybuild-easyblocks/issues/1350)

  * Several source directories or download file names needed corrections. Among them
    bzip2, fontconfig, JasPer, libffi, PCRE, PCRE2, x264, x265.

  * Update of the bzip2 build process which now uses the EasyBlock (works in a Bundle
    since EasyBuild 4.5.0) but also has an adapted patch to not only generate a pkg-config
    file but also puts the manual pages in share/man rather than man.

  * As we switched to different sources for x264, the start directory also needed updating.

  * cURL options needed to be changed to find zlib and to select the right TLS backend.
