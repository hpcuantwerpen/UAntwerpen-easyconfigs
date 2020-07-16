# OpenMX instructions

  * [OpenMX web site](http://www.openmx-square.org/)
      * [Version check on the Donwload page](http://www.openmx-square.org/download.html)


## General information

  * The installation of OpenMX usually requires two files:
      * One with the major.minor release
      * One with the patch which is in fact not a true patchfile but simply a file that
        you have to untar in the `source` subdirectory to upgrade the sources to the
        major.minor.patchlevel version.
  * The build process is very unconventional. 
      * There is no configure process. Instead 
        one needs to either edit the makefile to define the variables CC, FC and LIB to
        point to the C-compiler (with all compiler flags), the Fortran compiler (again
        with all compiler flags) and the libraries that need to be added respectively,
        or define those on the command line.
          * If this is done by specifying them on the make command line rather than by editing
            `source/makefile` then keep in mind that in the makefile, extra options 
            are added to CC and/or FC (depending on the version of OpenMX) in a separate
            line which needs to be added by hand when specifying CC and FC on the make
            command line. With some clever shell syntax to avoid expanding the variable, 
            this can be done on the command line also.
      * The make target `all` will build the `openmx` executable and a bunch of utilities
        and copy them to the directory pointed to by the variable `DESTDIR`. There 
        is also an `install` make target, but all it does is run the `strip` command 
        on the `openmx` executable and copy it again to `DESTDIR`.
  * Some included programs are not covered by the `all` target.
  * Some executables are hard-coded for gcc and generated without using any optimization 
    options. These seem to be small utilities that likely are not performance-critical.


## EasyBuild

This documentation was written when installing for the 2020a toolchains, starting with
redoing our 3.8.5 installation for those toolchains.

At that time (EasyBuild 4.2.2), there was no support for OpenMX in EasyBuild.

### 3.8.5 on Intel 2020a toolchain.

  * Older EasyConfigs in this repository required assembling a source file that contained
    the patches. This is not needed anymore. By specifying both source files and an extract
    command for the patch this is now fully automated.
  * Since there is no configure step and no working `make install` that does a complete
    installation, we use a `MakeCp` EasyBlock to build OpenMX. We do use `DESTDIR` 
    though to avoid that the binaries are put in the `work` subdirectory.
  * From the 2020a toolchains on, we do a full copy of all files except for the sources:
      * The binaries to the 'bin' subdirectory
      * The PDF manual to the 'doc' subdirectory
      * The data directory DFT_DATA13 is copied over unmodified.
      * The contents of the `work` subdirectory from the distribution is put in the
        `examples` subdirectory.
  * We do a sanity check on:
      * The existence of the `openmx` executable
      * All executables in the UTILS variable in `source/makefile`
      * The executables `check_lead` and `OpticalConductivityMain` that were not covered by
        the `all` makefile target.
  * check_lead was not included as it does not compile, and it is very likely to be an error
    in the code as `DFT_DATA_DIR` is used without including the include file that defines it,
    and it can't be meant to be given as a preprocessor symbol as that would break the
    other files that use that symbol.

### 3.9.2 on Intel 2020a toolchains

  * There are a lot of new utilty programs included.
  * `check_lead` is again not compiled by the all target and still does not compile.
  * The default makefile now also has a defintion of `MKLROOT` in the example configurations
    that is not commented out.
  * Version 3.9 now uses ELPA (also included) instead of liberi so the includes have 
    to change when specifying CC and FC.
  * All example configurations use the `-ip` option to enable extra interprocedural
    optimizations and `-no-prec-div` for less precise devisions but stick to the 
    default floating point model otherwise. EasyBuild does set a floating point model
    though. We stick to fully EasyBuild-generated options, but if problems with the
    accuracy are found, this may be the place to look.
  * The PDF manual is no longer included in the distribution.



 