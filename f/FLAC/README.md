# FLAC instructions

* [FLAC web site](https://xiph.org/flac/)
    * [Release information](https://ftp.osuosl.org/pub/xiph/releases/flac/)
* [FLAC on GitHub](https://github.com/xiph/flac)
    * [Releases](https://github.com/xiph/flac/releases)

## General instructions

* [Ogg](https://www.xiph.org/ogg/) is an optional but highly recommended dependency.
* [XMMS](http://www.xmms.org/) is an optional dependency that we did not include 
  given that it is of little use on a cluster.

## EasyConfig

* We developed our EasyConfig with the eye on inclusion in baselibs in the 2020a
  toolchain, but backported to 2019b as part of libsndfile and librosa for a
  user.
* We started our development from an old EasyBuilders EasyConfig that was included
  with EasyBuild 3.9.4 but not supported anymore in later versions. However, we did 
  make the usual modifications and also some corrections.
    * Added documentation in the module file.
    * Added the dependency on libogg
    * Made it explicit in configopts that we do not include XMMS support, thus also
      avoiding warnings about it during the run of `configure`.

