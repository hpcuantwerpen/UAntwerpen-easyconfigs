# ABINIT instructions

  * [ABINIT web site](https://www.abinit.org/)
      * [Available versions](https://www.abinit.org/packages)
  * [ABINIT development on GitHub](https://github.com/abinit/abinit)
      * [GitHub releases](https://github.com/abinit/abinit/releases),
        not always in sync with the main web site.

## General information

  * The project lead is Xavier Gonze, LLN. 
  * Configurations used to compile on some of the Walloon clusters can be found 
    on [the abinit/abiconfig GitHub]( https://github.com/abinit/abiconfig/tree/master/abiconfig/clusters)
      * Note that very few options are installed which shows that it may be tricky…
  * We compile with -mcmodel=large. However, this is incompatible with the -static-intel 
    link option imposed by the configure script. Therefore we need to patch the configure script.
      * Done because one of our users had problems.
  * We also enforce 64-bit integers which were needed by one of our users. 
    (--enable-64bit-flags and -i8 in the compiler options)
      * This had caused trouble with BigDFT in the past, but it is not the only problem with BigDFT.
  * ABINIT is rather tricky to install. There seem to be numerous conflicts between its 
    dependencies, depending on how things are being compiled. Configure tests that fail 
    with our Python modules, … It looks like it is one of those packages that one would 
    like to install in a single directory tree with all dependencies tuned to the specific 
    needs of the package, and even that may not always work.

## EasyBuild

  * There is [support for ABINIT in the EasyBuild
    repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/master/easybuild/easyconfigs/a/ABINIT).
  * There is no application-specific EasyBlock. ABINIT in EasyBuild is compiled through
    a `ConfigureMake` EasyConfig, with a length `xonfigopts` to adapt the configuration.
    We don't really follow that approach. Instead, we let ABINIT compile its own dependencies
    as much as possible after past compatibility problems when getting the dependencies
    from other modules.
  * A user mentioned problems with 8.10.2 when compiled with newer compilers than Intel 
    2016 so be careful; other builds may be faulty!

### ABINIT 8.10.3 for the 2020a toolchains

  * Compiled with Intel MKL for BLAS and LAPACK. We also use the Intel FFTW interfaces.
  * Compiled with the netCDF fallback code from ABINIT after having ran into compatibility
    problems before.
  * We don't use ETSF_IO and BigDFT.
  * After problems getting ABINIT 8.10.x to work with GSL, we do no longer include GSL.
  * Levmar hasn't been developed since 2011 so we also skip this as it seems very few users
    need that functionality.
  * After problems with the configure process in combination with our own Python modules,
    we no longer include Python as a dependency and instead rely on the system Python.
  * We have not yet tried to compile ABINIT with the ELPA library, though it may be
    useful according to documentation that we once found on the ABINIT Wiki
    (but has since moved or has been removed).

