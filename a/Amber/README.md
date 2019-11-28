# Notes for installing Amber

* [Amber web site](https://ambermd.org/index.php)

Amber consists of two parts that should be installed together. There is the actual 
Amber package itself, and AmberTools, with a number of additional tools that
can also be used without Amber. AmberTools seems to be updated more frequently than 
Amber.

The software has an EasyBlock that is capable of installing both. Yet even then the 
software needs a significant amount of patching to make the installation process compatible 
with the EasyBuild conventions. There are some bad decisions in the configure scripts 
of Amber, including explicitly looking for X11 libraries in specific directories.

Since Amber is semi-commercial software, an account is needed to download the software. 
Hence Amber and a matching version of AmberTools should be downloaded beforehand to 
the sources directory as downloading them from EasyBuild will fail, even with the correct 
URL. The patches for Amber and AmberTools can be downloaded freely though.

## Amber installation process

The Amber documentation process is very badly documented. Hence this text with a number 
of problems we ran into trying to install Amber on the UAntwerp systems. Basically 
one needs to investigate installation code and the output of the configuration and 
build processes to figure out all the options and dependencies of the code.

### Choice of build processes

In Amber 18, there are two build processes that are kind of supported. However, both 
appear to be very buggy.
* A `configure`-based one that is considered to be the stable build process. Though 
  very similar to traditional autotools-generated configure scripts, it looks like 
  at least part if not all of the configure scripts that are being used are actually 
  hand-written or modified from generated ones. There are definitely hidden parameters 
  that are not shown with `--help` or `--full-help`.
* A CMake-based process that in version 18 is still considered experimental. It is 
  not guaranteed to work in all environments or for all types of builds, and I indeed 
  could not get it to work.

Note that some people have reported that using a parallel make process may fail...

### CPU build types

Not counting the CUDA GPU builds, different types of builds are supported. However,
it seems that only the executables that are explicitly supported for that build type 
are being build and rather than do a fallback to a 'lower' level for the other 
executables.
 * Serial build. This seems to build the largest set of executables.
 * MPI build: Using either `-mpi` or `-itelmpi` with `configure`
 * OpenMP build: Using `-openmp` with `configure`
 * Hybrid MPI/OpenMP build: Using `-openmp` in combination with either `-mpi` or `-intelmpi`.

### Adding the Amber and AmberTools patches

A new version of Amber is released roughly every two years, a new version of AmberTools
roughly every year. They come as two `.tar.bz2` files. AmberTools can be installed
without Amber, but Amber cannot be installed without AmberTools.
However, during their life span, both receive numerous patches while the tar 
archives are not updated.
These can be found on:
 * [AmberTools patches page](https://ambermd.org/ATPatches.php)
 * [Amber patches page](https://ambermd.org/AmberPatches.php)

Amber does come with a tool that will automatically download and apply the patches.
`update_amber`. With this tool, it is possible to specify up to which patchlevel both
Amber and AmberTools should be upgraded to get reproducible installations.

Moreover, it is possible to download the patches by hand, put them in a specific directory, 
and let update_amber then apply the patches without re-downloading them again. 
That may save some time, but using this mechanism we can also save the patches together 
with the sources files for later re-installations so that Amber can be reinstalled 
in a reproducible way also should the patches no longer be available.
Patches are stored in:
 * `.patches/Amber<version>_Unapplied_Patches` for Amber (replace `<version>` with 
   the version number of Amber)
 * `.patches/AmberTools<version>_Unapplied_Patches` for AmberTools (replace `<version>` with 
   the version number of AmberTools)

Running `update_amber` with the specification of the right patch level will not re-download
the patches but only apply them. E.g.,
```bash
./update_amber --update-to AmberTools/9,Amber/17
```

### Amber and AmberTools dependencies

* libz
* bzip2, though the CMake build process fails to recognize the library even though 
  it is provided through a module.
* It is best to use an optimised BLAS and Lapack implementation. MKL is supported.
* Arpack, but the code comes with an internal version (in AmberTools)
* FFTW, but the code comes with an internal version and fails to recognize the one 
  we build with EasyBuild according to the EasyConfigs in this repository.
* netCDF, preferably with PnetCDF as the parallel backend for the old netCDF data
  formats. The PnetCDF support is used by `cpptraj`.
* Boost, though the code comes with an internal version
* Perl 5, as it does install a number of Perl scripts (optional?)
* Python, as some of the tools come as Python scripts. It is not clear which other
  packages are needed...


## Remarks about the EasyConfig

* There is a EasyBlock for Amber that makes sure that updates are applied, etc. It 
  does seem to require a remarkable number of patches mostly to the configure scripts 
  of Amber to work properly.
* Places where other EasyConfigs for Amber can be found:
    * [EasyBuilder EasyConfig repository on github](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/a/Amber),
      with the [matching EasyBlock](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/a/Amber).
      These EasyConfigs require a lot of patching of the Amber and AmberTools sources. 
      One problem with this is that even just a patch to Amber or AmberTools may invalidate 
      one or more of the EasyBuild-provided patches, making upgrading to a newer version 
      a real pain in the ass.
    * [ComputeCanada github repository](https://github.com/ComputeCanada/easybuild-easyconfigs/tree/computecanada-master/easybuild/easyconfigs/a/Amber).
      ComputeCanada starts from the default EasyBuilder EasyConfigs.
    * [IT4I github repository](https://code.it4i.cz/sccs/easyconfigs-it4i/tree/master/a/Amber). 
      IT4I does use the EasyBlock for Amber, but doesn't seem to need the pletora of 
      patches used in the EasyBuilder EasyConfigs.
    * [CSCS github repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/a/Amber). 
      In their typical way, they avoid using the application-specific EasyBlock and 
      instead push all steps in a traditional MakeCp-based EasyConfig. In their newer 
      versions they build several build types together in one module, which may be 
      a good thing as otherwise some modules would be missing some commands (e.g., 
      the ones that don't support MPI, OpenMP or hybrid mode).
* One should set the number of patches for AmberTools and Amber at the start of the 
  EasyConfig file, see the variable patchlevel. To determine the correct number, go to
    * [AmberTools patches page](https://ambermd.org/ATPatches.php)
    * [Amber patches page](https://ambermd.org/AmberPatches.php)
