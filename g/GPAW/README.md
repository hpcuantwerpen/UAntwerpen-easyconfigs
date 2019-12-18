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
      E.g., at the time of writing, version 19.8.1 is the most up-to-date release of GPAW with 3.18.0 the matching ASE version.
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

GPAW searches for an appropriate BLAS library in config.py and sets a number of default 
compiler options also in that file. However, that code is not suitable for a HPC system 
that installs software in modules as it looks for the library files in default directories 
rather than in the library search path. Hence a customize.py file pointing to the right 
library locations is needed on any system that uses modules or the script may pick 
up default Linux libraries rather than the intended ones.

## Internal organization of the compilation process of GPAW

GPAW is compiled through Python scripts to integrate in the standard Python package
setup process. The scripts are fairly outdated though as they still rely on 
[`distutils`](https://docs.python.org/3/distutils/index.html) rather than `setuptools`.

Besides pure Python files, the installation process generates two binary files:
* The shared library `_gpaw.cpython-<python version>-<architecture>.so` in the 
  Python packages directory is a purely sequential library. In fact, the manual
  of GPAW advises to use `OMP_NUM_THREADS=1` which may influence other packages
  called from GPAW, but the default is to compile with single threaded libraries.
  This shared library does not call the MPI libraries.
* `gpaw-python` in the `bin` directory is a Python interpreter for GPAW that is
  used to run the MPI version of GPAW. It links to the MPI libraries.
  
The other commands in the are all regular Python scripts, except for
`gpaw-runscript` which is executed by `gpaw-python`. Note that this script
is only an example and has not been adapted to our particular cluster!
  
It is possible and needed to change the default configuration though by adapting
customize.py or writing your own variant of this script and then overwriting the
default by adding `--customize=<name of file>` to the argument list of
`python setup.py build` and `python setup.py install`.

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
1. Intel MKL
1. [OpenBLAS](https://www.openblas.net/)
1. [ATLAS](http://math-atlas.sourceforge.net/)
1. libsatlas: Serial version of Atlas (recent versions of Atlas compile a serial 
   and a threaded version, the latter called libtatlas.)

Only a limited set of C files contain calls to the MPI libraries. During the 
compilation process, the `_gpaw....` shared library is generated by the `distutils`
`build_ext` method. All C files that contain MPI calls include header files that
define stub data types/routines/macros so that the sources can be compiled to 
a serial shared library without the use of a MPI compiler wrapper. Next the
`gpaw-python` interpreter is compiled by the `build_interpreter` routine 
defined in `config.py`. This routine is called by overwriting the standard 
`distutils` `build_ext` method in `setup.py`. Only those files that do contain
calls to MPI are recompiled using the MPI compiler wrapper, and all objects are 
then linked into the `gpaw-python` binary.

For the shared library, one needs to the compiler flags in the `distutils` way.
However, the setup script contains a hack that makes it possible to reset them
the way you want. All one needs to do is to set the `compiler` variable in the 
customization script to the name of the compiler that should be used and call
`setup.py` with the `--remove-default-flags` option. Note however that this 
will also remove some flags that may make sense, so make sure that 
`extra_compiler_flags` is set in the proper way. We did notice that the compiler
flags are still added twice to the call of the compiler, once at the front and 
once at the back. It is not clear what is causing this behaviour.

For `gpaw-python`, one may need to check the argument that is used to detect the correct option for
adding libraries to the command line as it assumes that the MPI compiler wrapper is
called `mpicc`. The options thus chosen for gcc may be better than the default `-R` 
which is chosen now for the Intel compiler? The flags for the MPI compiler wrapper
are simply taken from `extra_compile_args` so no surprises here (search for
'Compile the parallel sources' and 'Link the custom interpreter' in `config.py`).

## EasyConfig

### General remarks

We based our EasyBuild compile procedure on an EasyConfig for the 19.8.1 version
of GPAW included with EasyBuild 4.0.1. It uses a customization file to adapt
various options for GPAW. This is a very standard procedure for GPAW and is almost 
always needed. A model customization file is in the EasyBuild sources as
`customize.py`. 

Problems encountered:
* The patch in the GPAW EasyConfig of EasyBuild 4.0.1 poses several problems
    * It creates a new file and for some reason this does not work in an extension
      list. Even when specifying the level at which the patch should be applied,
      EasyBuild cannot find where to apply the patch.
    * The customization file is very incomplete and contained several errors
        * The `compiler` variable was not defined. This is needed in combination
          with the `--remove-default-args` option of `setup.py` to remove the 
          default Python compiler options and impose the ones we want.
        * Compiler options (`extra_compile_args`) wasn't set properly either.
          The regular C compiler was called with default options that `distutils`
          gets somewhere (probably from the Python configuration?) while no options
          where used for the MPI wrapper (which only means no host-specific 
          optimizations with the Intel compiler but implies `-O0` should the GNU
          compilers be used).
        * No support for ELPA, but this is trivial to add.
        * Not specifically an error, but the Lapack/BLAS libraries were included
          multiple times.
* Rather than using a patch, we decided to implement the customization file as an
  additional source file that we store with the EasyConfig as this directory is
  also searched for sources by default. There are a number of pitfalls though
    * It is impossible to specify multiple source files in an extension list. 
      Hence this procedure works well when GPAW is installed as a PythonPackage
      type EasyConfig, but a trick was needed when installing in an extension list
      of a 'Bundle' EasyConfig: We specify a dummy component that simply puts
      the file in the overall source directory of the Bundle and then refer to 
      that one.
    * That source file is not automatically copied to the directory where EasyBuild
      stores the sources for further use. This is in fact a good thing, and we didn't
      copy manually, as the version in that directory would take precedence to the 
      one stored with the EasyConfig. Hence new edits wouldn't be taken into account.
      The sourcefile is copied to the %(installdir)s/easybuild directory instead
      so that we still have the exact file as it was used to install the program
      for reproducibility of the installation.
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

### 2019b toolchain

The `-easybuilders` EasyConfig isn't actually deployed at UAntwerp but is an effort
to stay as close as possible to the EasyBuilders EasyConfig. It can be used as the 
basis for a file to be contributed back as we made several improvements.

GPAW was compiled with both a EasyBuild Python 3.7.4 module and the Intel Python 3 
distribution, and in both cases both without libvdwxc using the Intel FFTW wrappers 
for MKL, and with libvdwxc but then using FFTW3 itself (as libvdwxc requires that 
library anyway). The versions without libvdwxc have the `-MKLFFTW` suffix.


## Checking the build result

* Search in the EasyBuild log file for `python setup` to see if the compilation
  did not produce errors. Some packages have Python fallback code if the compilation
  fails, so the standard EasyBuild sanity check will not detect these problems,
  but the result will be a much slower Python package.

