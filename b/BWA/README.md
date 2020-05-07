# BWA EasyBuild recipe

EasyBuild has an EasyBlock for BWA. That derives from ConfigureMake, but
* with an empty configure step as there is no configure script
* The install step is replaced by a manual copy of the files to the correct
  location.
* A suitable sanity check is defined in the EasyBlock.

We started from the EasyBuilders recipes for BWA. At the time when we installed
BWA, those recipes didn't work as intended though as they did not pick up the
compiler and compiler options as specified by EasyBuild. The Makefile of BWA
has all variables hard coded into it and hence does not pick up variables from
the environment.

The solution to this is to define them through `buildopts`:

`  buildopts = 'CC="$CC" CFLAGS="$CFLAGS"'`

Furthermore, some additional extensions were made to the recipe:
* A sanity check was added: The recipe now checks if the files that should
  be generated are indeed generated.
* Added additional documentation to the EasyConfig.

EasyConfigs for both Intel and GCCcore are included in this directory and were
tested.
