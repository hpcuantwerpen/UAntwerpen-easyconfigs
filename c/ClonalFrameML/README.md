# ClonalFrameML instructions

  * [ClonalFrameML on GitHub](https://github.com/xavierdidelot/ClonalFrameML)
      * [Releases](https://github.com/xavierdidelot/ClonalFrameML)


## General information

  * ClonalFrameML consists of a single binary and a R script.
  * No configure process for building the software. Some editing of the Makefile
    needed instead.

## EasyBuild

There is (likely disappearing) [support for ClonalFrameML in the EasyBuilders
repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/c/ClonalFrameML).
(At the time of installing the 2020a toolchains the EasyConfigs had not been changed 
since the 2016b toolchains).

### Version 1.12 in the 2020a toolchains, preparation for inclusion in BioTools

  * Started from the standard EasyBuilders EasyConfigs.
  * Made our usual changes to the documentation.
  * Changed the location of some installed files.
     * There is an R script which we have put in bin for lack of better options.
       I guess it should have started with `#!/usr/bin/env Rscript` to run as an
       independent program.
     * Put the README file in `share/doc/ClonalFrameML`
