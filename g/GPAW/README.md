# GPAW installation notes

GPAW is a Quantum MD code.

* [GPAW web site](https://wiki.fysik.dtu.dk/gpaw/), which also contains the installation
  instructions.

## Dependencies

* GPAW is Python code (3.5 or newer) but it also contains some C code for some performance-critical
  parts and to interface to a number of libraries on which it depends (for GPAW 19.8.1):
    * BLAS
    * LAPACK
    * MPI
    * BLACS and ScaLAPACK
    * FFTW is highly recommended
    * [LibXC](https://www.tddft.org/programs/libxc/) 3.X or 4.X. LibXC is a library
      of exchange-correlation functions for density-functional theory
    * Optional dependency: [libvdwxc](https://gitlab.com/libvdwxc/libvdwxc), a portable C library 
      of density functionals with van der Waals interactions for density functional theory.
      As of December 2019, this library is still unreleased.
        * *It is not clear from the installation documentation whether we need the 
          MPI-aware version of libvdwxc or not, but further on in the documentation 
          it claims that libvdwxc will automatically parallelise which implies the 
          MPI-aware version is needed.*
    * Optional dependency: [ELPA](https://elpa.mpcdf.mpg.de/), 
      which should improve performance for large systems when GPAW is used in
      [LCAO mode](https://wiki.fysik.dtu.dk/gpaw/documentation/lcao/lcao.html) 
* GPAW depends on a number of standard Python packages. As of GPAW 19.8.1, these are:
    * [NumPY](https://pypi.org/project/numpy/) 1.9 or later
    * [SciPy](https://pypi.org/project/scipy/) 0.14 or later
* GPAW relies on [ASE](https://wiki.fysik.dtu.dk/ase/), a Python package from the same group
    * Check the release notes of GPAW as the releases of ASE and GPAW should match.
      E.g., when starting this documentation, version 19.8.1 was the most up-to-date release of 
      GPAW with 3.18.0 the matching ASE version. See further below for more instructions
      on how to determine the right versions for dependencies.
    * ASE has some optional dependencies that are not needed for the benchmarking: Matplotlib (2.0.0 or newer), tkinter and Flask.

BLAS, LAPACK, MPI, BLACS and ScaLAPACK are standard components of the Intel toolchain 
that we use for installing GPAW. See this repository for the FFTW and LibXC EasyConfig 
files as used at UAntwerp. 

NumPy and SciPy are standard components of the Python bundles in use at UAntwerp, see 
the EasyConfig files in this repository. ASE introduces additional dependencies on 
other Python packages: Matplotlib, tkinter and Flask. These are optional and only needed
for some of the functionality.
 * [Matplotlib](https://pypi.org/project/matplotlib/) is a standard component in the Python 
   modules at UAntwerp, see the Python
   and IntelPython3-Packages EasyConfigs in this repository.
 * tkinter, the TK interface, is a standard component of recent Python distributions.
 * [Flask](https://pypi.org/project/Flask/) needs to be installed. 
   It brings with it a set of other dependencies: 
    * [Werkzeug](https://pypi.org/project/Werkzeug/)
    * [Jinja2](https://pypi.org/project/Jinja2/), and this one needs
        * [MarkupSafe](https://pypi.org/project/MarkupSafe/)
    * [itsdangerous](https://pypi.org/project/itsdangerous/)
    * [click](https://pypi.org/project/click/): Included in recent standard Python packages at UAntwerp, 
      but not in some of the older ones.

GPAW, when installed automatically, rarely has the best configuration for HPC, 
so check the section on the internal organization of the compilation process on
how to customize to get a proper HPC build.

### Determining version numbers of dependencies

* Python versions: [On PyPi](https://pypi.org/project/gpaw/) or towards the bottom 
  of the file ``setup.py``
* ASE version: 
     * [In the release notes](https://wiki.fysik.dtu.dk/gpaw/releasenotes.html):
       preferred version, though other versions may also work.
     * Line ``install_requires`` towards the bottom of the file ``setup.py`` may give 
       a different restriction from the release notes.
     * In the file ``doc/install.rst``
* NumPy and SciPy:
     * In the file ``doc/install.rst``

<table cellpadding="3">
<tr><th>GPAW</th>   <th>Python</th>       <th>ASE</th>                 <th>NumPy</th>    <th>SciPy</th>     <th>LibXC</td></tr>
<tr><td>19.8.1</td> <td>3.4-3.7</td>      <td>3.18.0, &geq;3.18.0</td> <td>&geq;1.9</td> <td>&geq;0.14</td> <td>3.x or 4.x</td></tr>
<tr><td>20.1.0</td> <td>3.5-3.8</td>      <td>3.19.0, &geq;3.18.0</td> <td>&geq;1.9</td> <td>&geq;0.14</td> <td>3.x or 4.x</td></tr>
</table>


## Internal organization of the compilation process of GPAW

GPAW is compiled through Python scripts to integrate in the standard Python package
setup process. 
* Up to and including version 19.8.1: The scripts are fairly outdated though as they still rely on 
  [`distutils`](https://docs.python.org/3/distutils/index.html) rather than `setuptools`.
* From version 20.1.0 on, `setuptools` is used instead of `distutils` easing
  installation with ``pip``.

As a result of this, there are some differences between the way
versions up to 19.8.1 and versions from 20.1.0 are configured. There are
also differences in the files generated that are not related to this
switch.

However, togehter with this transition, there was also an important change to 
how parallel computations are organized, leading to even more differences.

In both cases the build process can be customized (and often has to be customized)
through a customization script.

### Version 19.8.1 and likely below

GPAW consists of a lot of Python code, a purely sequential shared library 
`_gpaw.cpython-<python version>-<architecture>.so` for some operations and
for a parallel installation also the specialised parallel Python
interpreter `gpaw-python`. There are two types of installation:
1. If `mpicc` is not found and no MPI compiler is specified in the customization
   script, of if the automatic detection of `mpicc` is undone in the customization 
   script by setting `mpicompiler` to `None`, a purely sequential version of GPAW
   is installed, including only the Python code and the shared library.
1. If `mpicc` is found or another MPI compiler is specified in the customization 
   script, a distributed memory version of GPAW is build, consisting of the
   Python code, the sequential shared library and the parallel Python interpreter
   `gpaw-python`. Only the latter links to the MPI libraries and to BLACS/ScaLAPACK
   (if used).

Note that the manual of GPAW advises to use `OMP_NUM_THREADS=1` which may influence 
other packages called from GPAW, but the default is to compile with single threaded 
libraries.
  
The other commands in the bin directory (beside `gpaw-python`) are all regular
Python scripts, except for `gpaw-runscript` which is executed by `gpaw-python`. 
Note that this script is only an example and has not been adapted to our particular 
cluster!
  
It is possible and needed to change the default configuration though by adapting
`customize.py` or writing your own variant of this script and then overwriting the
default by adding `--customize=<name of file>` to the argument list of
`python setup.py build` and `python setup.py install`.

At the point where `customize.py` is called, the NumPy include files
have been located, libxc is added to the library list, and the configure process
has done an effort to auto-locate the linear algebra libraries (at least
BLAS and Lapack, see below). However, we experienced that the choice was often wrong and
the resulting code refused to run. The MPI compiler and linker will be set to 'mpicc'
if that one is found, or 'None' otherwise. 

The script `config.py` tries very hard to auto-determine a suitable BLAS/LAPACK
library for various platforms that it recognizes (even ARM). However, it does so 
not by looking in `LIBRARY_PATH` or `LD_LIBRARY_PATH` but only checks default 
locations for installation of those libraries as part of the OS, except for MKL,
where it does use the `MKLROOT` environment variable. Hence it fails to
detect any library in modules that are installed elsewhere in the file system
(except then for MKL if the module make correct use of `MKLROOT`).
It is important that this is corrected in a customization file.
Note that on 64-bit Intel architecture if multiple supported BLAS libraries are found, 
the preferred order is:
1. ACML, in /opt/acml...
1. Intel MKL
1. [OpenBLAS](https://www.openblas.net/), in 'usr/lib', '/usr/local/lib', '/usr/lib64'
1. [ATLAS](http://math-atlas.sourceforge.net/), in 'usr/lib', '/usr/local/lib', '/usr/lib64/atlas'
1. libsatlas: Serial version of Atlas (recent versions of Atlas compile a serial 
   and a threaded version, the latter called libtatlas.) Search is in the same 
   directories as for libatlas.

The `distutils` `build_ext` method is redefined in `setup.py`. It first
calls the regular `distutils` `build_ext` method to build the shared library
and prepare some Python scripts for the bin directory, and then calls the
`build_interpreter` routing defined in `config.py` to build `gpaw-python`.
Only a limited set of C files contain calls to the MPI libraries. The
shared library contains no MPI calls. All C files that contain MPI calls include 
header files that define stub data types/routines/macros so that the sources 
can be compiled to a serial shared library without the use of a MPI compiler wrapper.
When building 'gpaw-python' at a later stage, those files that do contain
calls to MPI are recompiled using the MPI compiler wrapper, and all objects are 
then linked into the `gpaw-python` binary.

For the shared library, compiler flags are used in the `distutils` way, taking
them from the Python configuration and environment. This may lead to
very misleading results. You may find customization scripts that specify a
different compiler through the `compiler` variable, but that value is ignored
if `CC` and ``LDSHARED` are defined in the environment. We consider this a bug,
see below, as the code does not do what the comments in `setup.py` suggests.

For linking `gpaw-python`, one may need to check the argument that is used to detect 
the correct option for adding runtime library search paths to the command line
(if this is used in the customization script). The current code assumes the MPI
compiler wrapper is called `mpicc` and checks if this calls `gcc` but doesn't recognize
other compilers, so the option used may not be the right one.


#### Bugs in 19.8.1

* If `CC` and `LDSHARED`, the value of `compiler` customize.py script is
  ignored during the compilation process and `CC` respectively `LDSHARED` are used
  for the compilation and link steps. The hack to remove this in `setup.py` does not
  work. The code is simply incomplete as it does not push the variables back to
  the environment or fails to feed them in another way to the compilation process.
* `setup.py` suggests there is a flag `--remove-default-flags` which one can use to
  remove compiler flags imported from various environment variables (and/or Python
  configuration?), but the flag does not work at all. The hack that should actually
  remove those (located in the same block of code as the hack for the previous bug)
  does not work for the same reason that the hack to overrule setting `CC` or
  `LDSHARED` does not work.
* The code in `build_interpreter` in `config.py` to build the argument list
  for runtime library paths is suspicious. There is no way to set the right 
  options by hand. There are cases where it may use the wrong option, e.g., `-R` 
  rather than `-Wl,-R`.
   

### Version 20.1.0 and likely above

As in earlier versions, GPAW consists of a lot of Python code, a shared library
`_gpaw.cpython-<python version>-<architecture>.so` for some operations and optionally
the binary `gpaw-python`, a specialized parallel Python operator. There is however 
a major difference for the preferred parallel build of GPAW. There are now three
build types, the third one being undocumented in the documentation of version
20.1.0 and hence likely deprecated.
1. Sequential build: If `mpicc` is not found and no MPI compiler is specified in
   the customization script, of if the automatic detection of `mpicc` is undone in
   the customization script by setting `mpicompiler` to `None`, a purely sequential
   version of GPAW is installed, including only the Python code and the
   sequential shared library.
1. Prefered parallel build: If `mpicc` is found or another MPI compiler is specified 
   in the customization script, a distributed memory version of GPAW is build, 
   consisting of the Python code and a parallel shared library. Contrary to version
   19.8.1, MPI and the optional    BLACS/ScaLAPACK are now linked directly into the 
   shared library.
1. Old-style parallel build: To enable this build type, set `mpicompiler` (or make 
   sure `mpicc` is found) and set `parallel_python_interpreter` to `True` in the
   customization file. This build type consists of the the Python sources, the
   sequential shared library, and the parallel Python interpreter `gpaw-python` 
   linking to the MPI libaries and optional BLAC/ScaLAPACK. **We did not test
   this build type, the information is derived from analyzing the setup script.**

In the first two build types, all GPAW commands in the `bin` directory are Python scripts.

Note that the manual of GPAW advises to use `OMP_NUM_THREADS=1` which may influence 
other packages called from GPAW, but the default is to compile with single threaded
libraries.

It is possible and usually needed to change the default configuration by adapting
`siteconfig.py` or writing your own variant of this script and passing its name (and 
path if not in the root GPAW directory) to either `pip` or `python setup.py build` 
and `python setup.py install` through the environment variable `GPAW_CONFIG`
(like `GPAW_CONFIG=MySiteconfig.py pip gpaw`). The contents of `siteconfig.py` is
largely the same as for `customize.py` in prior versions, though the value of
certain variables at the start is different. The libxc library is added to the list,
but there is no automatic detection of the linear algebra libraries (which often did
not work as expected anyway). The NumPy include files are auto-located but only
just before compiling the shared library, and are not even shown in the configuration
log file. The MPI compiler and linker will be set to 'mpicc'
if that one is found, or 'None' otherwise. 


#### Bugs in 20.1.0

* If `CC` and `LDSHARED`, the value of `compiler` or `mpicompiler` in the siteconfig.py
  (the former for a sequential shared library, the latter for a parallel one) is
  ignored during the compilation process and `CC` respectively `LDSHARED` are used
  for the compilation and link steps. **Make sure `CC` and `LDSHARWED` are set to
  the MPI compiler/linker when doing a build with a parallel shared library, or make
  sure they are not set.**
* `setup.py` suggests there is a flag `--remove-default-flags` which one can use to
  remove compiler flags imported from various environment variables (and/or Python
  configuration?), but the flag does not work at all.
* The code in `build_interpreter` in `config.py` to build the argument list
  for runtime library paths is suspicious. There is no way to set the right 
  options by hand. There are cases where it may use the wrong option, e.g., `-R` 
  rather than `-Wl,-R`. Note that this code is only used when building `gpaw-python`,
  it is not clear if setuptools does the right thing though when processing
  `runtime_library_dirs`.


### Variables for customize.py or siteconfig.py

* compiler: Default is `None` which implies that the compiler as would normally result 
  from the standard Python extension configuration process. It is used for compiling 
  and linking the sequential shared library. *See the bugs for specific 
  GPAW versions as this variable is often ignored in practice.* 
* mpicompiler: Default is `mpicc` if found and `None` otherwise. Used for parallel 
  builds and in 20.1.0 and higher for linking the parallel shared library.
  *See the bugs for specific GPAW versions.*
* mpilinker: Default is `mpicc` if found and `None` otherwise. Used for linking
  `gpaw-python`. *See the bugs for specific GPAW versions.*
* libraries: List of libraries to be used when linking non-MPI code. Format of the
  list entries is 'XX' for libXX.a or libXX.so.
* mpi_libraries: Additional libraries for linking `gpaw-python`.
* library_dirs: Directories to search for the libraries in `libraries`.
* mpi_library_dirs: Directories to search for the libraries in `mpi_libraries`.
* include_dirs: Include directories needed to compile non-MPI source files.
* mpi_include_dirs: Additional include directories needed to compile sources 
  for `gpaw-python`.
* runtime_library_dirs: list of directories to search for shared (dynamically loaded) 
  libraries at run-time. *It is not clear if they are always added to the command
  line in the right way.* 
* mpi_runtinme_library_dirs: Additionsl list of directories to search for shared
  libraries at run-time for `gpaw-python`. *It is not clear if they are always 
  added to the command line in the right way.*
* extra_compile_args: Extra arguments used when compiling (on top of arguments
  by the regular Python procedure if `--remove-default-flags` is not used)
* extra_link_args: Extra arguments used when linking.
* define_macros: C preprocessor macros to define when compiling non-MPI code
* mpi_define_macros: Additionsl C preprocessor macros to define when compiling
  MPI code.
* undef_macros: C preprocessor macros to undefine.
* fftw (boolean, default `False`): Use FFTW instead of NumPy FFTW
* scalapack (boolean, default `False`): Use ScaLAPACK
* libvdwxc (boolean, default `False`): Use libvdwxc
* elpa (boolean, default `False`): Use ELPA
* noblas (20.1.0 and up only, default `False`): Compile GPAW without BLAS libraries.
* parallel_python_interpreter (20.1.0 and up only, default `False`): Build the
  parallel interpreter gpaw-python.

Note that in version 19.8.1 (and likely earlier versions) all of the above variables
starting with `mpi` are only used if `mpicompiler` points to a MPI compiler. They are
only used to build the parallel interpreter `gpaw-python`.

In version 20.1.0 (and likely later versions) all of the above variables starting with
`mpi` are only used if `parallel_python_interpreter` is `True`, to build the
parallel interpreter `gpaw-python`. This is simply confusing: What
has to be specified in the non-mpi variables and what has to be specified in the
`mpi_`-variables differs depending on whether the new-style build with a parallel
shared library is done, or the old-style with a sequential share library
and MPI-support provided by `gpaw-python`. 


## EasyConfig

### General remarks

We based our EasyBuild compile procedure on an EasyConfig for the 19.8.1 version
of GPAW included with EasyBuild 4.0.1 and the one for 20.1.0 included in
EasyBuild 4.2.0. Both use a customization file to adapt
various options for GPAW. This is a very standard procedure for GPAW and is almost 
always needed. A model customization file is in the GPAW sources as
`customize.py` (version 19.8.1) or `siteconfig_example.py` (version 20.1.0). 

Problems encountered:
* The patch in the GPAW EasyConfig of EasyBuild 4.0.1 poses several problems
    * It creates a new file and for some reason this does not work in an extension
      list. Even when specifying the level at which the patch should be applied,
      EasyBuild cannot find where to apply the patch.
    * The customization file is very incomplete and contained several errors
        * When building the shared library, compiler options are set the 
          distuitls/setuptools way. Options are picked up from the environment
          (`CFLAGS` but also some other variables that we do not use). Options
          specified in `extra_compile_args` in the customization script are then
          added to those. However, the executable `gpaw-python` is compiled in
          a different way (specifying the full build instructions in the setup
          script and config.py rather than organising it through distutils/setuptools)
          and there the compiler flags specified in the environment are not used.
          Hence when compiling `gpaw-python` one has to use `extra_compile_args`
          as otherwise no optimization options will be used when recompiling
          files with the MPI compiler for linking into `gpaw-python`. 
          This implies no host-specific optimizations with the Intel compiler 
          but implies `-O0` should the GNU compilers be used. But setting
          this variable will also imply that compiler options may be repeated or
          conflict when compiling the shared library. If `extra_compile_args`
          is simply set to whatever is in `CFLAGS`, options are simply repeated
          which does no harm while one can still use the EasyBuild mechanisms
          to influence compiler options.
        * No support for ELPA, but this is trivial to add.
        * Not specifically an error, but the Lapack/BLAS libraries were included
          multiple times.
        * Setting include_dirs to `[]` is just plain stupid as it already contains
          information about the NumPy installation. In some cases (IntelPython for 
          instance) the compilation process now fails to find the NumPy header
          files.
* Implementing the customization script as a patch has its restrictions. It is a 
  cumbersome process when one wants to experiment with options, as one has to 
  edit the true sources, then make a patch for it in a location that EasyBuild can
  find, and then apply it, which is sometimes tricky for a patch that adds a new
  file as we must be sure that it is added where we need it (which is tricky in
  particular with extensions). We've looked at two other mechanisms, and 
  ultimately went for the last after experimenting with the first and running
  into its limitation (too many files in the EasyConfig directories, 
  easy to edit the wrong file) 
    * Implement the customization file as an additional source file
      that is stored with the EasyConfig as this directory is
      also searched for sources by default. There are a number of pitfalls though
        * It is impossible to specify multiple source files in an extension list. 
          Hence this procedure works well when GPAW is installed as a PythonPackage
          type EasyConfig, but a trick was needed when installing in an extension list
          of a 'Bundle' EasyConfig: We specify a dummy component that simply puts
          the file in the overall source directory of the Bundle and then refer to 
          that one. This is easily done with a "Tarball" bundle component and a custom
          unpack procedure that creates the directory where we want the file to go. 
        * That source file is not automatically copied to the directory where EasyBuild
          stores the sources for further use. This is in fact a good thing, and we didn't
          copy manually, as the version in that directory would take precedence to the 
          one stored with the EasyConfig. Hence new edits wouldn't be taken into account.
          When not using the Tarball bundle component that puts the file automatically
          in the easybuild subdirectory of the installation directory, it is a good 
          idea to copy the customization script to the %(installdir)s/easybuild directory 
          so that we still have the exact file as it was used to install the program
          for reproducibility of the installation.
    * Put the configuation script as a string variable in the EasyConfig for GPAW,
      and then use `prebuildopts` to inject it into the GPAW sources using the
      Bash "Here Document" trick. The advantage of this approach is that all
      configuration information is in a single file which avoids errors when changing 
      the configuration.
* The build process could not find the FFTW include files of the Intel FFTW 
  wrappers. It turns out that the include file is not included as `fftw/fftw3.h`or 
  so, but without the subdirectory. This was solved by adapting our Intel compiler
  modules and simply including this directory as the problem may occur with other
  software also. The alternative is to simply compute the directory name from
  `MKLROOT` in the customization file and add that one to the list of directories
  to include in the search path.
* The optional libvdwxc needs the FFTW3 MPI-interfaces that are not provided by the
  Intel wrappers. To make sure any conflict between routine names is impossible, we
  compile GPAW with the regular FFTW libraries rather than the Intel MKL wrappers
  when libvdwxc is included.
* We also include the Atomic PAW setup files in the installation. They are put in
  the share/gpaw-setups subdirectory and pointed to by GPAW_SETUP_PATH as required 
  by GPAW. Since this is a comma-separated path rather than the usual colon-separated
  path we simply set the variable rather than using `prepend_path` in the module file
  (so put it in `mnodextravars` rather than `modextrapaths`).
* In version 19.8.1, the installation manual advises to set `OMP_NUM_THREADS` to 1.
  To avoid user errors, we do this in the module file.


### 2019b toolchain - GPAW 19.8.1

GPAW was compiled with both a EasyBuild Python 3.7.4 module and the Intel Python 3 
distribution, and in both cases both without libvdwxc using the Intel FFTW wrappers 
for MKL, and with libvdwxc but then using FFTW3 itself (as libvdwxc requires that 
library anyway). The versions without libvdwxc have the `-MKLFFTW` suffix.


#### Port of GPAW 19.8.1 to the 2020a toolchains

It turns out that there are dangerous `omp simd` pragmas in `c/bmgs/fd.c` and likely
also in `c/bmgs/relax.c` and `c/symmetry.c'. The one in `fd.c` caused segmentation violations, likely
due to an unaligned memory access. A compiler is allowed to assume that vectorization
is 100% safe when `omp simd` is used and hence to assume that alignment is OK. It looks
like the 2020 Intel compilers do make that assumption while the 2019 compilers did 
not, or that they are the first Intel compilers that turn on OpenMP SIMD support
without using the `-qopenmp` flag (they do it for optimization level `-O2` and higher). 

There are several possible solutions
* There is a patch from the authors for 20.1.0 that puts the `omp simd` in a conditional block.
  It may be that the only function of that patch is to avoid warnings about 
  unrecognized pragma's with some compilers if OpenMP is not enabled. The 
  pragmas are only included if `_OPENMP` is defined. We did not check if that
  solves the problem with the Intel 2020 compilers or if those compilers do
  define that preprocessor symbol already when they auto-enable OpenMP SIMD
  support.
* Develop a similar patch that simply omits those lines in `c/bmgs/fd.c`,
  `c/bmgs/relax.c` and possibly also in `c/symmetry.c` (we are not certain
  that that one never causes problems). The advantage of such a patch is that
  it is very clear what it does.
* Simply add `-qno-openmp-simd` to the `CFLAGS` to disable the automatically
  turned on OpenMP SIMD support also solves the problem. We have checked and there
  is no performance penalty compared to working with the patch in the second
  option, so it has no influence on the automatic vectorization capabilities
  of the compiler.

Since no patch is needed, we used the last option.


### 2020a toolchains - GPAW 20.1.0

* We checked our way of working with the EasyConfig files in the EasyBuilders
  repository as these are developed by people from the institute that also 
  develops GPAW. The customization script is very different from the one
  used for GPAW 19.8.1, not because the structure has changed, but because it
  is now developed by different people. There are a number of things that
  are no longer necessary though, e.g., cleaning libraries and mpi_libraries
  as there is no linear algebra junk in there. Also some variables for 
  ScaLAPACK do not need to be set anymore and are automatically correctly
  detected.
* Also take note of the change in the way the customization script is 
  named and/or specified otherwise due to the switch from distutils to
  setuptools.
* The change in architecture has a significant influence on how to 
  build GPAW. In particular, one now has to either set`use_mpi` in
  `optarch` to true to ensure that `CC` points to the MPI compiler,
  or unset `CC` when calling `setup.py` as it overwrites whatever
  the `setup.py` script tries to arrange based on the values of
  `compiler` and `mpicompiler` in the customization file. We use the
  latter approach and simply unset `CC` and `LDSHARED` to ensure that
  the value specified for `mpicompiler` is used.
* Note that besides the changes already mentioned earlier, GPAW is
  now also packaged as an egg, so `lib/python3.8/site-packages/gpaw' does no
  longer exist. We took the sanity check tests from the EasyBuilders recipes for
  GPAW 20.1.0.
* Note that we did try building with pip as in the EasyBuilders recipe but this did
  not work as GPAW tried to link to blas by adding `-lblas` to the link command
  line which is the wrong BLAS library.
* The problem with the `omp simd` pragmas causing segmentation violations is still
  present. See the remarks for the the port of 19.8.1 to the Intel 2020 compilers
  for the solution that we implemented.
* As we already cat the `configuration.log` file to the regular EasyBuild log,
  we do no longer store a copy of the file in %(installdir)s/easybuild, so
  `postinstallcmds` is no longer needed.


#### Backport of GPAW 20.1.0 to the 2019b toolchains

* Due to problems with the 2020a compiler that got solved later in the process,
  we also generated a version of GPAW 20.1.0 for the 2019b toolchains as we know 
  that 19.8.1 worked properly with those compilers.
* This is a trivial backport. Even though it seems that `-qno-openmp-simd` is
  not needed, we stuck to it as it does no harm either.


## Checking the build result

* Search in the EasyBuild log file for `python setup` to see if the compilation
  did not produce errors. Some packages have Python fallback code if the compilation
  fails, so the standard EasyBuild sanity check will not detect these problems,
  but the result will be a much slower Python package.
* The smallest of the PRACE UEABS benchmarks runs fine on a single node (finished
  in about 4 minutes on a 28-core broadwell node). Hence this is also an easy test.
  We did not that the benchmark does not work anymore with GPAW 20.1.0, which diverges.
  This may be due to a change in algorithms and not to a problem with the compilation
  of GPAW.

