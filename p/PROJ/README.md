# PROJ installation instructions

* [PROJ web site](https://proj.org/index.html)
* [PROJ GitHub](https://github.com/OSGeo/PROJ)
* [PROJ datumgrid GitHub](https://github.com/OSGeo/proj-datumgrid)

## General installation instructions

* PROJ by itself is not complete. It needs a data files to be useful.
  Before 7.0.0, none of these data files were included in the EasyBuild recipes.
* 7.0.0 was a pretty major release, bringing with it changes in the datumgrid
  files and the way they are organized.
* The installation instructions on the web site are pretty good. PROJ supports
  installation with both autotools and CMake.

## EasyConfigs

We started from standard EasyConfigs, but reworked thoroughly for version 7.0.0.

### 7.0.0 - 2020a toolchains

* We switched the download location to downloading directly form the GitHub.
* We now also include the data files. It turns out that they do not decompress
  in their own directory. Hence, to keep things clean, we use extract_cmd
  to extract those files in a separate directory. We use ``postinstallcmds``
  to copy the files to the right location at the end of the installation
  process.
