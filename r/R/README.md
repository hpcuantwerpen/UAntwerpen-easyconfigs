# R instructions

  * [R web site](https://www.r-project.org/)
      * [Comprehensive R Archive Network](https://cran.r-project.org/)
  * [Bioconductor](https://bioconductor.org/)


## General information

  * Each R package corresponds to a subdirectory in `lib64/R/library`. These 
    subdirectories have a very fixed structure. 
      * Shared objects corresponding to a package are in the subdirectory `libs` of 
        the package directory.
  * Checking if a package can be loaded: Start R and execute `library(<ext>)` with 
    `<ext>` the name of the package.


## Problems with specific packages

### Rmpi

  * Rmpi support in EasyBuild for the Intel toolchain consists of two components:
      * A patch that corrects the name of the MPI library in the configure script
        (as it is not called libmpich even though Intel MPI is derived from that 
        implementation and the other libraries don't even exist anymore).
      * An EasyBlock that generates the `--configure-args` argument.
  * On our local installation of the Intel toolchain, the EasyBlock generates the
    wrong values for `--with-Rmpi-libpath` and `--with-Rmpi-include` in
    `--configure-args`. We solve this in two components
      * We add the right `--configure-args` flag via `installopts`.
      * Since forcing the easyblock for the Rmpi extension to `RPackage` doesn't
        seem to work in the R easyconfig and since removing that EasyBlock from the
        EasyBuild installation is prone to error as it needs to be redone whenever 
        a new version of EasyBuild is installed, we include an empty EasyBlock for
        Rmpi in our own EasyBlock repository that overwrites the default one.
  * Note that we have corrected this problem in the 2020a Intel modules. Hence the
    regular Rmpi EasyBlock can now be used. We continue to compile the old way
    however as the dummy EasyBlock is still in place to be able to restore
    former R configurations.

### XML

  * There is an EasyBlock that adds a flag pointing to the zlib library. That
    turns out not to be needed on our installation and since it also refers to
    EBROOTZLIB, doesn't even work in our case.
  * As for Rmpi, rather than removing the EasyBlock, we use an empty one in our
    custom EasyBlocks.

### tseries version 0.10-47

  * In version 0.10-47, tseries introduced a new file, `cfuncs.f95`. This file is in 
    free form source format. There is one other Fortran file, `dsumsl.f`, which is in
    fixed form source format. The problem is that the Intel compiler does not recognize
    the (non-standard) `.f95` extension and considers it as fixed form source format.
    On the other hand, adding the option `-free` through `PKG_FFLAGS` also does not
    work as then all source files are considered to be in free form source format.
    Possible solutions:
      * Unpack and rename, but it seems that this can not be done easily in EasyBuild
        4.2 as the unpack_sources of RPackage doesn't seem to work the way it should.
      * An idea of Davide Vanzo: Add the directive `!DIR$ FREEFORM` to the top of 
        `cfuncs.f95`. This can be done with a patch file.

### Rtsne and several other packages that produce error #308: member "std::complex<double>::_M_value"

  * Rtsne does not compile anymore with the Intel C++ compiler. It produces a lot
    of error #308. The root of the problems is actually in the GCC complex header 
    file and not in Rtsne itself. However, R shouldn't be using that header file
    in the first place but should use the one in the Intel system directories.
  * Possible solutions:
      * Make sure the option `-diag-disable 308` is used. This is sometimes easier
        said than done. In some packages you can inject this option by setting 
        the environment variable `PKG_CXXFLAGS`. But in recent versions of Rtsne this
        does not work anymore. It sets the variable in its own `src/Makevars` file 
        and refuses to pick it up from the environment. One workaround is to change
        it permanently in all CXXFLAGS lines in the system `Makeconf` file 
        ($EBROOTR/lib64/R/etc/Makeconf). TODO: One way to accomplish this may be to
        simply add that option already to the CXXFLAGS when compiling R.
      * Some sources suggest to use `-isystem<dir>` to add the Intel compiler include
        file directory to the front of the directory search path. This can also be 
        done by editing `Makeconf`. However, even though the line was added to the 
        compiler command line, R kept using the `complex` header file from GCC which
        caused the error.

### git2r

  * git2r depends on libgit2 but will use an internal version if none can be found.
  * git2r optionally depends on LibSSH2 (libssh2-devel package on CentOS). It should
    find those libraries automatically if they are in a standard location where configure
    can find them.
  * git2r also uses the openssl package and zlib.

### openssl

  * openssl provides an interface to libssl and libcrypto and hence depends on development 
    packages for those libraries.
      * On CentOS 8 the necessary headers are provided by `openssl-devel`, the libraries 
        by `openssl-libs`. 

### V8

  * The V8 package needs v8-devel which was omitted in early (and later?) versions 
    of CentOS 8, so one needs to look elsewhere.
      * [Interesting issue thread (issue 84) on the V8 GitHub](https://github.com/jeroen/V8/issues/84).


## Problems on CentOS 8 and some other linux versions with a recent glibc (2.27 or 
later?)

  * Compilation fails in `artihmetic.c`. A good source of information for the deeper 
    roots of the cause is 
    [the answer from rolandd to a question in the Intel community forum](https://community.intel.com/t5/Intel-C-Compiler/Error-when-compiling-R-from-source-code-ubuntu-18-04/td-p/1176401).
      * The problem has to do with the removel of the SVID math library exception handling 
        from `math.h` in glibc 2.27 and later (and the corresponding macro definitions, 
        which is where the compilation fails). The test in configure fails with `gcc`
        during the link phase but does not fail with the Intel compiler as it has a 
        replacement function but the corresponding Intel header does not define the
        excpetion structure for whatever reason.
      * The workaround suggested in that forum post is to remove the `HAVE_MATHERR`
        symbol from `src/include/config.h` between the configure and the build steps.

## Scripts to ease testing and writing EasyConfigs

When installing version 4.0.2, we developed three Perl scripts that help to generate
various files to ease the installation process.

This scripts start from a list file. This is a tab-separated file with up to 
four fields per record
  1. Type of the package, with currently 4 different values:
       1. CRAN for a package that can be found on CRAN
       2. BIOC for a regular Bioconductor package
       3. BIOCDA for a Bioconductor data annotation package
       4. BIOCEX for a Bioconductor experiment package
  2. Name of the package
  3. Environment variable to be specified when building
  4. Add an additional remark if this field is non-empty. It is used simply to
     warn that some manual intervention will be needed in the files generated by\
     the scripts.

The scripts all work as a filter, i.e., they take input from standard input and
print to standard output. So simply use I/O redirection to use the scripts.

The scripts are:
  * `list2htmml.pl`: Generates a HTML-file with a link to the repository for
    each package. It is useful to check version numbers etc.
  * `list2ext_list.pl`: Generates the ext_list structure without the version
    numbers. Some packages may need some more work than just adding the version
    number.
  * `list2R.pl` generates a R script to install the packages instead. Again, it
    may need some work. We found this very useful to install packages by hand to
    check for dependencies when `easy_update` failed on us.


### sf in combination with ncdf4

  * The package `sf` links to PROJ, GDAL and GEOS.
  * The package `ncdf4` is an interface to the netCDF 4 libraries (version 4.1 and 
    later).
  * If you explicitly load netCDF as a dependency, be careful as it already comes in
    as a dependency of GDAL, so make sure you use the right netCDF library. Otherwise
    GDAL may fail to load leading to a failure to load the package `sf`.


## EasyBuild

This documentation was started when installing R 4.0.1 in the 2020a toolchains.

We started from an older EasyConfig in the [R EasyBuilders
repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/master/easybuild/easyconfigs/r/R)
and updated from there as we have added several packages requested by our users
throughout the years.

We do also have a number of Bioconductor modules in our base R setup.

### Version 4.0.2 in the Intel toolchains

  * Adapted the syntax in the exts_list to the current way of doing things in EasyBuild.
  * Moved initialisation of Bioconductor up to the front of the extensions list.
  * Packages that require special care or have caused trouble recently are moved up
    the list as much as possible to detect compile problems early.
  * Package tseries: We tried several solutions and stuck to the last one in the end 
    as there was no working solution without a patch file anyway:
     * Using `unpack_sources`, then using `preconfigopts` to rename `cfuncs.f95` and
       adapt the corresponding line in `MD5`: Does not work due to bugs in the RPackage
       EasyBlock.
     * Using a patch for `MD5` that simply changes `cfuncs.f95` to `cfuncs.f90` in 
       that file to force unpacking of the sources, then renaming `cfuncs.f95` in 
       `preinstallopts`: Works.
     * Using a patch from Davide Vanzo that adds `!DIR$ FREEFORM` to the top of 
       `cfuncs.f95` also works. In the end we used this solution as there is no 
       solution without a patch file that actually works.
  * Rmpi: Even though we corrected the problem in the Intel modules that cause the
    Rmpi EasyBlock to fail, we continue using our previous approach with `installopts`
    and the empty EasyBlock to be able to recompile old versions without having
    to change the EasyConfig.
  * Rtsne: We decided to simply add `-diag-disable 308` to `CXXFLAGS` when compiling
    R itself, even though R itself doesn't need it. But we assume it will do no harm
    to other packages anyway.
  * XML: This package install perfectly fine and can find the libraries it needs (which
    come from the Baselibs packages in this repository), but there is an EasyBlock that 
    sits in the way since that checks for EBROOTZLIB and sets an option which is not 
    needed at all. We moved that package to the front of the list so that problems
    become clear quickly and have our own empty custom easyblock as the `easyblock` parameter
    doesn't seem to work in an extension list.
  * ModelMetrics supports OpenMP. We've enabled that support through `PKG_CXXFLAGS` 
    and moved that package far to the front so that we don't have to scroll that far
    through the logs to check if everything is OK.
  * When compiling the git2r package, we use the embedded libgit2 implementation and
    a libssh2 installed on the system.
  * Package penalized: We define `ARMA_ALLOW_FAKE_GCC` (via `PKG_CXXFLAGS`) which according
    to the messages in the log when this symbol is not set, should give enable data 
    alignment.
  * For CentOS 8 we need to remove `HAVE_MATHERR` from `src/include/config.h` between 
    the configure and build steps. It turns out that the only solution to do this is 
    via `prebuildopts` as the R EasyBlock adds further options after adding `configopts` 
    to the `configure` command line.

### Future version

  * RcppParallel: Illegal options because it set compiler to gcc? But it does use icpc as intended.
  * Try to move packages that provide interfaces to external libraries forward as much as possible?
