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

Discovering the true dependencies requires a lot of engineering as there is no complete 
list in the manual. It really requires looking into all output of configure and/or 
cmake and sometimes even figuring it out from the output of the build process and from
the source code.

* libz
* bzip2, though the CMake build process fails to recognize the library even though 
  it is provided through a module.
* It is best to use an optimised BLAS and Lapack implementation. MKL is supported.
* Arpack, but the code comes with an internal version (in AmberTools)
* FFTW, but the code comes with an internal version and fails to recognize an external 
  FFTW3 library. The configure script in Amber 18 doesn't even try to find one.
* netCDF, preferably with PnetCDF as the parallel backend for the old netCDF data
  formats. The PnetCDF support is used by `cpptraj`. The code contains an internal 
  version; however, it is not clear if and when it tries to compile the internal PnetCDF. 
  (TODO: Check further, maybe only included automatically in MPI builds which is actually 
  very reasonable?)
* Boost, though the code comes with an internal version
* Perl 5, as it does install a number of Perl scripts (optional?)
* Python, as some of the tools come as Python scripts. It is not clear which other
  packages are needed... The manual mentions that either Python 2.7 or Python 3.4 or
  later should be used.
  It is also not fully clear which other Python packages are needed, though 
  the manual does mention:
    * NumPy
    * SciPy
    * matplotlib
    * cython
    * IPython and notebook? Not useful for job scripts, these are tools for interactive 
      work.

### Other problems I ran into with Amber 18 and AmberTools 19

The cmake build process clearly does not yet work properly when trying to do a MPI/OpenMP 
build. Moreover, it fails to find libraries that are clearly present, e.g., libbz2.

The configure script is considered to be mature even though there are features that 
are marked as experimental, in particular `--prefix`. Note that without `--prefix`, one 
needs to do an in-place build and then clean up (likely by hand) files that are not 
needed for running Amber. In fact, all EasyConfigs I found (see further down) for versions 
of Amber available in December 2019 used in-place builds. In some configurations we 
got crashes during the build process that may be due to bugs in the Makefiles in combination 
with a configure with `--prefix`.

Usual practice with cmake or configure generated makefiles using libtool is that `VERBOSE=1` 
or `V=1` show the full command being executed. This does not work with the Amber makefiles. 
To discover what is really happening, set the variable SHELL in calls of make to `sh 
-x`, hence add `SHELL='sh-s'` to the make command line.

When selecting Intel as the compiler, the configure process does seem to know how to 
set suitable compiler options without using environment variables such as CXX_FLAGS. 
Some files are compiled with -O0 but this may be deliberate since they are known to 
sometimes fail when optimization is turned on. However, though most modules are compiled 
with very reasonable options, in some modules only -O or -O3 is used without -xHost. 
This implies that these modules are only optimized for whatever Intel considers the 
default processor for the version of the compiler, and this in turn implies that AVX 
or younger vector instructions typically are not used. Which means that the performance 
potential of every recent processor (where recent really is less than 6 years old) 
remains unexploited.

Likely suboptimal compile options were found in:
 * UCPP: AmberTools/src/ucpp-1.3: No optimization options given
 * CIFPARSE: AmberTools/src/cifparse: No optimization options given
 * ANTECHAMBER: AmberTools/src/antechamber: No optimization options given
 * REDUCE, 
    * AmberTools/src/reduce/toolclasses: Uses only `-O`, without `-xHost`.
    * AmberTools/src/reduce/libpdb: idem
    * AmberTools/src/reduce/reduce_src: Uses `-O3` but no `-xHost`
 * LEAP: AmberTools/src/leap/src/leap: No optimization options given
 * EMIL: AmberTools/src/emil: Uses `-O3` but no `-xHost`
 * NMRAUX:
    * AmberTools/src/nmr_aux/prepare_input: No optimization options
 * CPPTRAJ: AmberTools/src/cpptraj/src and subdirectories: Uses `-O3` but no `-xHost`
 * AMBPDB: AmberTools/src/ambpdb: Uses `-O3` but no `-xHost`
 * NAB: AmberTools/src/nab: No optimization options
 * ETC: AmberTools/src/etc: No optimization options
 * RISM: AmberTools/src/rism: The build process returns repeatedly to this directory, 
   and somtimes files get compiled with very reasonable optimization options while 
   sometimes these options appear to be completely missing.
 * SAXS: AmberTools/src/saxs: Uses `-O3` but no `-xHost`
 * CPHSTATS: AmberTools/src/cphstats: No optimization options
 * NFE: AmberTools/src/nfe-umbrella-slice: No optimization options 


## Remarks about the EasyConfig

* There is a EasyBlock for Amber that makes sure that updates are applied, etc. It 
  does seem to require a remarkable number of patches mostly to the configure scripts 
  of Amber to work properly.
* Places where other EasyConfigs for Amber can be found:
    * [EasyBuilder EasyConfig repository on github](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/a/Amber),
      with the [matching EasyBlock](https://github.com/easybuilders/easybuild-easyblocks/blob/develop/easybuild/easyblocks/a/amber.py).
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

For the development of the EasyConfig used at UAntwerp, we started from the CSCS one
but extended it in several ways.

* As `--prefix` still works unreliably in Amber18, we do an in-place build and 
  remove the sources afterwards.
* As with the regular EasyConfig for Amber, one should set the number of patches 
  for AmberTools and Amber at the start of the 
  EasyConfig file, see the variable patchlevel. To determine the correct number, go to
    * [AmberTools patches page](https://ambermd.org/ATPatches.php)
    * [Amber patches page](https://ambermd.org/AmberPatches.php)
* We specify the extract command for the tar files so that the amberXX/-prefix is already
  removed at the untar phase. Furthermore we extend the source list with all patches for
  Amber and AmberTools, and make sure they are downloaded to the appropriate subdirectories
  AmberXX and AmberToolsYY of the Sources subdirectory to avoid name conflicts. We use
  `extract_cmd` to move these to the correct subdirectories of the unpacked sources.
* As we cannot adapt the installation of the patches without writing or adapting the 
  EasyBlock for Amber, we install the patches with `update_amber` during the configure phase.
* Just as in the CSCS EasyConfig, we do 4 builds of Amber in the same directories, 
  in the order serial, OpenMP, hybrid MPI+OpenMP and MPI. Note that the serial build is 
  needed to ensure that the full set of tools is installed, as the other options only seem
  to install those tools that support either OpenMP or MPI. However, by first doing the 
  serial build, we also ensure that OpenMP versions of the tools will overwrite the serial
  ones if they exist.
* We use `postinstallcmds` to clean up the sources.