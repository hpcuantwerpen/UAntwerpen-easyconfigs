# libogg instructions

* [libogg web site](https://www.xiph.org/ogg/)
    * [downloads via the web site](https://www.xiph.org/downloads/)
* [libogg on GitHub](https://github.com/xiph/ogg)
    * [libogg releases on GitHub](https://github.com/xiph/ogg/releases)

## General information

* libogg has a configure - make - make install build process.

## EasyConfig

* No support was found in EasyBuild at the moment of the first installation,
  so we developed our own EasyConfig.
* Some compiler options are coded in the configure script. There is one which
  we expected might cause warnings even with gcc and removed that one (-O20)
  using sed, but we did not touch the other flags. The ones specified
  by EasyBuild are added to them at the end.
* Integrated into the baselibs module from the 2020a toolchains on,
  but we did use it in the libsnd bundle in the 2019b toolchains for a
  particular user.
