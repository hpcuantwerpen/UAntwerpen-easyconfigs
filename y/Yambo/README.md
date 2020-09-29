# Yambo install instructions


## General information

### Dependencies

  * [libxc](https://www.tddft.org/programs/libxc/): Yambo needs libxc. 
    It however only seems to work with very old versions of libxc. It 
    downloads its own libxc if it cannot find a compatible one.
    **Search for `version.*used` in `config/libxc.m4'.**

### Build process

  * Building with iotk does not make much sense if QuantumESPRESSO supports netCDF/HDF5.
    It is then better to build with netCDF and HDF5 support.
  * The Yambo build process does download its own internal dependencies during the 
    build step. This can be avoided by putting the files into `lib/archive` beforehand.
    The problem is that some of those files don't seem to be the regular downloads, 
    but come from elsewhere. E.g., current downloads of `libxc` don't contain the 
    `configure script`; it has to be generated with `autoreconf -i`, but the Yambo
    build process assumes a file that does contain the configure script already.
  * Only in-place builds work. The Makefiles and configure script is buggy as hell
    and doesn't follow the GNU conventions at all (we checked 4.2.1 and 4.4.1). 
    A proper configure script and associated Makefiles are assumed to distinguish between
    the source tree (where the `configure` script is located), the build tree (where 
    `configure` is run) and the install tree. But the Yambo build process only works
    OK if all tree are the same (and there is no formal `install` target for make).
    Quite often the wrong variable is used in the Makefiles leading to various problems:
      * The Yambo build process has an option to keep object files. That option doesn't 
        seem to work in a non-inplace build as it goes looking for some scripts in the 
        install directory rather than where they are in the build directories. According 
        to the spack package for Yambo, this bug is present since version 4.2.1 ("As of 
        version 4.2.1 there are hard-coded paths that make the build process fail if the 
        target prefix is not the configure directory"). It is definitely still present 
        in the version 4.4.1. There is an configure option to not keep them, but that
        is pretty useless also due to other bugs.
      * A very similar bug also hits in other circumstances. When iotk is enabled, it
        tries to copy a file to the install directories rather than to the build directories.
      * Although Yambo claims to have a `make install` target it is actually not there
        (see also remarks in the spack code which confirm this).
   * `--enable-dp` has a different meaning than what one would expect. When it is set to yes, 
     it effectively promotes variables that would be single precision otherwise to double precision.
      
The conclusion can only be that Yambo can only be compiled in-place due to a very
buggy and non-standard install procedure. 
Therefore a clean central install is rather difficult. One would have to build
with `--prefix` set to the build directory during the configure phase and then
copy whatever need to be copied. There is also no proper `make install` support,
and the configure process has several options that are documented but do not work
as advertised.


## EasyBuild

The most elegant solution to compile Yambo is to write a custom EasyBlock
that does an in-place compile rather than compiling on `/dev/shm` due to bugs in the 
build procedure. There is however a workaround as a second `--prefix` argument
to configure will overwrite the first one.

As of September 2020, spack only supports up to 4.2.2 (version from May 2018)
and EasyBuild has given up at version 3.4.2.

We made our EasyConfig for Yambo 4.4.1 based on 
[the spack recipe for Yambo](https://code.ornl.gov/m9b/spack/-/tree/develop/var/spack/repos/builtin/packages/yambo).


### Yambo 4.4.1

  * Dependencies:
      * Yambo 4.4.1 relies on libxc 2.2.3. The files it auto-downloads are different
        though from those in the standard libxc repositories (see also the build process).
        We used an externally compiled version as the Yambo build process otherwise 
        failed.
      * Yambo 4.4.1 downloads etsf_io 1.0.4 if needed
      * Yambo 4.4.1 downloads iotk 1.2.2. Even though it can be disabled via configure,
        it shouldn't be disabled as due to bugs in the build process, Yambo will always
        try to compile some code that needs iotk. It doesn't make much sense though 
        with modern versions of QuantumESPRESSO that use HDF5.
  * Problems
      * Only an in-place build works, so we had to add `--prefix` to `configopts`. 
        Luckily it overwrites the default option added by EasyBuild.
      * There is no install target despite claims on some places. Our `files_to_copy` is
        derived form the spack recipe.
      * `etsf_io-1.0.4.tar.gz` could not be downloaded from the location indicated in the code.
     