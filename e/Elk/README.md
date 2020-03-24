# Elk installation instructions

* [Elk web site](http://elk.sourceforge.net/)

## General instructions

* Elk has a rather primitive build system. 
    * There is no configure whatsoever, instead it has a setup script that
      generates a make.inc file.
    * There is also no install procedure.

## EasyConfigs

First version covered by this documentation: 5.2.14.

### Version 5.2.14 for Intel 2019b and 2020a

* The EasyConfig file is derived from some very old ones. It is based on the
  MakeCp generic EasyBlock
* There is no config step
* In the build step we first generate a make.inc file with those options that are
  not passed through the environment.
* In the install step we then copy the generated executables.

### Version 6.3.2 for Intel 2020b

* There are a number of extra variables that should be initialized in make.inc.
  Otherwise link errors occur. Stubs for OpenBLAS and BLIS should be included.
* New in this version (actually one slightly before) is support for Wannier90,
  which we have also integrated in the recipe.

