# HTSlib instructions

  * [HTSlib home page](http://www.htslib.org/)
  * [Development on GitHub](https://github.com/samtools/htslib)


## General information

  * HTSlib is the underlying library of SAMtools
  * The build process creates three binaries, a shared and a static library.
  * HTSlib dependencies:
      * zlib
      * libbz2
      * liblzma
      * libcurl: Optional but recommended for network access.
      * libcrypto: We always take this one from the OS to ensure that security patches
        are applied.

## EasyBuild

There is [support for HTSlib in the EasyBuilders
repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/h/HTSlib)
which we used as a starting point for our EasyConfig files.


### Version 1.10.2 in the 2020a toolchain

  * EasyConfig developed to prepare for inclusion in the BioTools bundle.
  * We added some configopts to make clear which configuration we build.
