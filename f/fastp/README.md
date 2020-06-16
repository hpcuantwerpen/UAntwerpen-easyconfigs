# fastp installation instructions

  * [fastp on GitHub](https://github.com/OpenGene/fastp)

## General instructions

  * As of version 0.20.0, fastp has no configure or CMake support. It is build
    using a simple Makefile with a build and a ``make install`` step. 
      * Build step:
          * Picks up the compiler from the CXX environment variable
          * Adds the flags specified through CXXFLAGS in the environment to 
            the hard-coded values which luckily also work for Intel. The
            alternative is to define CXXFLAGS as one of the arguments of the
            Make command. In version 0.20.0, the default flags are 
            ``-std=c++11 -g -O3 -I./inc``.
      * Install step: Define PREFIX to set the installation directory. It is
        necessary to also create the installation directory for binaries as it
        is not done automatically.
  * Depends on zlib
  * The build process produces a single executable and no libraries

## EasyConfigs

There is support for fastp in EasyBuild. We did make a couple of changes though.

### Version 0.20.0 - Intel 2019b and 0.20.1 - Intel 2020a

  * Added the missing dependency for zlib. In our case, this is the baselibs
    package.
  * Removed CXX from buildopts as the Makefile picks up the correct value from the
    EasyBuild environment.
  * Added CXXFLAGS to overwrite the internally set ones. This results in the 
    behaviour which is most in line with what EasyBuild expects.
  * Did specify the C++ standard in toolchainopts since the default compiler options
    imposed this.
  * Moved to the BioTools bundle for the 2020a toolchains.
  * Note that we added the `-std=c++11` option by hand instead of through toolchainopts
    as in a Bundle we can currently not yet specify individual toolchainopts for a
    single component.


