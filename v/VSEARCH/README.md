# VSEARCH installation instrictions

  * [VSEARCH on GitHub](https://github.com/torognes/vsearch)

## General information

  * VSEARCH needs zlib and bzip2.
  * The build process only produces a single executable.

## EasyConfigs

There is support for VSEARCH in EasyBuild.

### Version 2.14.2, intel 2019b

  * Started from an EasyBuilders recipe for Intel for an older version of the package.
  * Checking the log files however shows that the wrong compiler options are used.
    The root of the problem is that the C++ compiler options are hardcoded in 
    src/Makefile.am. Rather than working with a patch file, we chose to edit the
    file with sed in preconfigopts which may be more portable to newer versions
    and keeps everything in a single file.

