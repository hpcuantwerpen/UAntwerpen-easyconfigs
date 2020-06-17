# miniasm instructions

  * [miniasm development on GitHub](https://github.com/lh3/miniasm)
      * [Releases](https://github.com/lh3/miniasm/releases)


## General information

  * Build process: Only a Makefile that needs editing or redefining variables on the 
    make command line, similar to minimap2 which is developed in the same GitHub account.
  * The build process generates two executables, `miniasm` and `minidot`.
  * Often used together with minimap2.
  * Development is extremely slow. At this time (June 2020) the most recent version
    is only 0.3 which was released in July 2018, with the most recent commit in
    October 2019.
  * There is documentation included in the source files, but only as TeX documents 
    so LaTeX would be needed to build the documentation which makes little sense on
    a cluster as there is no fast way to open these documents without a GUI.


## EasyBuild

At this time (June 2020) there is no EasyBuilders support for miniasm.

### Version 0.3 for 2020a

  * EasyConfig developed for inclusion in BioTools and derived from the one for
    mimimap2 as it uses a similar methodology.
