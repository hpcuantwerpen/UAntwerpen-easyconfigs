# libvorbis instructions

* [libvorbis web site](https://www.xiph.org/vorbis/)
    * [downloads via the web site](https://www.xiph.org/downloads/)
* [libvorbis on GitHub](https://github.com/xiph/vorbis)
    * [libvorbis releases on GitHub](https://github.com/xiph/vorbis/releases)

## General information

* libvorbis needs libogg.
* libvorbis has a configure - make - make install build process.

## EasyConfig

* No support was found in EasyBuild at the moment of the first installation,
  so we developed our own EasyConfig.
* Some compiler options are coded in the configure script. As we use GCC anyway
  which is what the configure script assumes in its selection of options, we did
  no effort to remove them using a patch or sed. The compiler flags specified
  by EasyBuild are added at the end by the configure procedure.
* Integrated into the baselibs module from the 2020a toolchains on,
  but we did use it in the libsnd bundle in the 2019b toolchains for a
  particular user.
